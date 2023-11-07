import PairQL

extension CodegenRoute.Admin: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [
      ("SelectableDocument", SelectableDocuments.SelectableDocument.self),
      ("EditableAudioPart", EditDocument.EditAudioPart.self),
      ("EditableAudio", EditDocument.EditAudio.self),
      ("EditableEdition", EditDocument.EditEdition.self),
      ("EditableDocument", EditDocument.EditDocumentOutput.self),
      ("EditableFriendQuote", EditFriend.FriendOutput.Quote.self),
      ("EditableFriendResidence", EditFriend.FriendOutput.Residence.self),
      ("EditableFriend", EditFriend.FriendOutput.self),
    ]
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      EditDocument.self,
      EditFriend.self,
      GetOrder.self,
      ListDocuments.self,
      ListFriends.self,
      ListOrders.self,
      ListTokens.self,
      SelectableDocuments.self,
    ]
  }
}
