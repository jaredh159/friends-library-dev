import PairQL

extension CodegenRoute.Admin: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [
      ("SelectableDocument", SelectableDocuments.SelectableDocument.self),
      // todo... why all the `Editable*` prefixes? ¯\_(ツ)_/¯
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
      EditToken.self,
      GetOrder.self,
      ListDocuments.self,
      ListFriends.self,
      ListOrders.self,
      ListTokens.self,
      OrderEditions.self,
      SelectableDocuments.self,
    ]
  }
}
