precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
  f(a)
}

precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
  return { a in
    g(f(a))
  }
}
