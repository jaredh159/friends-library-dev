import React, { useState } from 'react';
import cx from 'classnames';

interface Props {
  setToken(token: string): unknown;
}

const SignIn: React.FC<Props> = ({ setToken }) => {
  const [input, setInput] = useState(``);
  const inputValid = input.length === 36 && input.match(MATCH_UUID);

  function submit(e: React.FormEvent<HTMLFormElement>): void {
    e.preventDefault();
    if (inputValid) {
      setToken(input);
      return;
    }
  }

  return (
    <div className="min-h-screen bg-white flex">
      <div className="flex-1 flex flex-col justify-center py-12 px-4 sm:px-6 lg:flex-none lg:px-20">
        <div className="mx-auto w-full max-w-sm lg:w-96">
          <div className="mt-8">
            <div className="mt-6">
              <form onSubmit={submit} className="space-y-6">
                <div>
                  <label
                    htmlFor="email"
                    className="block text-md font-light text-gray-600"
                  >
                    Enter Authorization Token:
                  </label>
                  <div className="mt-1">
                    <input
                      type="password"
                      required
                      spellCheck={false}
                      value={input}
                      onChange={(e) => setInput(e.target.value)}
                      className="font-mono appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-200 focus:outline-none focus:ring-flprimary-500 focus:border-flprimary-500 sm:text-md"
                    />
                  </div>
                </div>
                <div>
                  <button
                    type="submit"
                    disabled={!inputValid}
                    className={cx(
                      !inputValid && `opacity-50 cursor-not-allowed`,
                      `font-sans bg-flprimary antialiased w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-md text-white hover:bg-flprimary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-flprimary-500`,
                    )}
                  >
                    Log in
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div className="hidden lg:block relative w-0 flex-1">
        <div
          className="inset-0 absolute xbg-contain"
          style={{
            backgroundSize: `120%`,
            backgroundPosition: `0 0%`,
            backgroundImage: `radial-gradient(rgba(0, 0, 0, 0.55), rgba(0, 0, 0, 0.975) 65%), url(https://raw.githubusercontent.com/friends-library-dev/design-assets/master/hi-res-images/books.png)`,
          }}
        />
      </div>
    </div>
  );
};

export default SignIn;

const MATCH_UUID =
  /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i;
