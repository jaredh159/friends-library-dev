import PairQL

extension CodegenRoute.Admin: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [
      ("EntityType", AdminRoute.EntityType.self),
      ("SelectableDocument", SelectableDocuments.SelectableDocument.self),
      ("EditableAudioPart", EditDocument.EditAudioPart.self),
      ("EditableAudio", EditDocument.EditAudio.self),
      ("EditableEdition", EditDocument.EditEdition.self),
      ("EditableDocument", EditDocument.EditDocumentOutput.self),
      ("EditableDocumentTag", EditDocument.EditDocumentOutput.TagOutput.self),
      ("EditableRelatedDocument", EditDocument.EditDocumentOutput.RelatedDocumentOutput.self),
      ("EditableFriendQuote", EditFriend.FriendOutput.Quote.self),
      ("EditableFriendResidence", EditFriend.FriendOutput.Residence.self),
      ("EditableFriendResidenceDuration", EditFriend.FriendOutput.Residence.Duration.self),
      ("EditableFriend", EditFriend.FriendOutput.self),
      ("EditableTokenScope", EditToken.Output.ScopeOutput.self),
      ("EditableToken", EditToken.Output.self),
      ("UpsertFriend", AdminRoute.Upsert.FriendInput.self),
      ("UpsertAudio", AdminRoute.Upsert.AudioInput.self),
      ("UpsertAudioPart", AdminRoute.Upsert.AudioPartInput.self),
      ("UpsertEdition", AdminRoute.Upsert.EditionInput.self),
      ("UpsertDocument", AdminRoute.Upsert.DocumentInput.self),
      ("UpsertDocumentTag", AdminRoute.Upsert.DocumentTagInput.self),
      ("UpsertRelatedDocument", AdminRoute.Upsert.RelatedDocumentInput.self),
      ("UpsertFriendQuote", AdminRoute.Upsert.FriendQuoteInput.self),
      ("UpsertFriendResidence", AdminRoute.Upsert.FriendResidenceInput.self),
      ("UpsertFriendResidenceDuration", AdminRoute.Upsert.FriendResidenceDurationInput.self),
      ("UpsertTokenScope", AdminRoute.Upsert.TokenScopeInput.self),
      ("UpsertToken", AdminRoute.Upsert.TokenInput.self),
      ("UpsertEntity", AdminRoute.Upsert.self),
    ]
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      CreateEntity.self,
      DeleteEntity.self,
      EditDocument.self,
      EditFriend.self,
      EditToken.self,
      GetOrder.self,
      GetFreeOrderRequest.self,
      ListDocuments.self,
      ListFriends.self,
      ListOrders.self,
      ListTokens.self,
      OrderEditions.self,
      SelectableDocuments.self,
      UpdateEntity.self,
    ]
  }
}
