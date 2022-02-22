import Fluent
import FluentPostgresDriver
import Vapor

struct HandleEditionIds: AsyncMigration {

  func prepare(on database: Database) async throws {
    Current.logger.info("Running migration: HandleEditionIds UP")
    let sqlDb = database as! SQLDatabase

    try await createNonForeignKeyNullableColumns(database)

    if Env.get("SKIP_LEGACY_DATA_MIGRATION_STEPS") != "true" {
      try await addEditionIds(sqlDb)
    }

    try await removeColumns(database)
  }

  private func createNonForeignKeyNullableColumns(_ database: Database) async throws {
    try await database.schema(Download.M1.tableName)
      .field(Download.M10.editionId, .uuid)
      .update()
    try await database.schema(OrderItem.M3.tableName)
      .field(OrderItem.M10.editionId, .uuid)
      .update()
  }

  private func removeColumns(_ database: Database) async throws {
    try await database.schema(Download.M1.tableName)
      .deleteField(Download.M1.documentId)
      .deleteField(Download.M1.editionType)
      .update()
    try await database.schema(OrderItem.M3.tableName)
      .deleteField(OrderItem.M3.documentId)
      .deleteField(OrderItem.M3.editionType)
      .deleteField(OrderItem.M3.title)
      .update()
  }

  private func addEditionIds(_ db: SQLDatabase) async throws {
    for (combined, uuidString) in editionIdMigrationMap {
      let parts = combined.split(separator: "/")
      let documentId = parts[0]
      let editionType = parts[1]

      let updateDownload = """
      UPDATE \(Download.M1.tableName)
      SET \(Download.M10.editionId) = '\(uuidString)'
      WHERE
        \"\(Download.M1.documentId)\" = '\(documentId)'
      AND
        \"\(Download.M1.editionType)\" = '\(editionType)'
      """
      _ = try await db.raw("\(raw: updateDownload)").all()

      let updateOrderItem = """
      UPDATE \(OrderItem.M3.tableName)
      SET \(OrderItem.M10.editionId) = '\(uuidString)'
      WHERE
        \"\(OrderItem.M3.documentId)\" = '\(documentId)'
      AND
        \"\(OrderItem.M3.editionType)\" = '\(editionType)'
      """
      _ = try await db.raw("\(raw: updateOrderItem)").all()
    }
  }

  func revert(on database: Database) async throws {
    Current.logger.info("Running migration: HandleEditionIds DOWN")
    // don't really care to try to reverse this one...
  }
}

// extensions

extension Download {
  enum M10 {
    static let editionId = FieldKey("edition_id")
  }
}

extension OrderItem {
  enum M10 {
    static let editionId = FieldKey("edition_id")
  }
}

// @TODO this will be replaced last minute with final export data
extension HandleEditionIds {
  var editionIdMigrationMap: [String: String] {
    [
      "69c5fc26-76e3-4302-964e-ba46d889003b/modernized": "0a4e9e87-3a4a-4bd3-8361-457f78893983",
      "a5a7cc71-bee0-4e71-80ae-e9167e140df4/modernized": "a6a83b89-77ff-4851-a4c9-3acca52d7283",
      "a5a7cc71-bee0-4e71-80ae-e9167e140df4/original": "9b4bce94-fff3-43ed-9f00-a8a3db8d618d",
      "a5a7cc71-bee0-4e71-80ae-e9167e140df4/updated": "02d6889a-b100-4de5-a168-d78aa91145d7",
      "b7cdfbb1-abf9-47b9-a483-a9e7dee6b435/updated": "8656ba11-86c6-4384-8dc2-b8d9012ba3ae",
      "6b0e134d-8d2e-48bc-8fa3-e8fc79793804/modernized": "bf3c1f44-b4e1-4f64-9370-4a3cbea7081b",
      "6b0e134d-8d2e-48bc-8fa3-e8fc79793804/original": "50eabf9a-02d8-4495-8179-10d252dbe533",
      "841500ef-cd48-4a42-8bd4-90ee841d19b4/modernized": "1e251e38-81eb-456d-9266-0e52ec5bf8dc",
      "841500ef-cd48-4a42-8bd4-90ee841d19b4/original": "f9486227-ab16-4824-827c-03e38b9a8f02",
      "025ae678-5e76-4128-9b59-b0761a7cb9d1/modernized": "d475b4a5-8957-47b6-a003-964bcee1601d",
      "025ae678-5e76-4128-9b59-b0761a7cb9d1/original": "498514dd-08bd-41ec-82df-12638b96582c",
      "a242c43b-2c05-43d8-836d-08efb90c7844/modernized": "4133c85f-500b-464a-982a-2c6c272ca2c7",
      "a242c43b-2c05-43d8-836d-08efb90c7844/original": "bcf950b9-051a-416d-a96e-6e4c15eaed06",
      "81171796-9b62-46dd-a73e-44cb807e48b0/modernized": "321e13fd-7ebc-4e62-8cad-884eb0f4d170",
      "81171796-9b62-46dd-a73e-44cb807e48b0/original": "f27417fb-e3a2-4f3f-b7e5-571abb7ce6af",
      "08b94a0b-b96f-4525-bd46-79b0d60c4302/modernized": "24694414-cd8a-481e-bf71-0f4cd118bc37",
      "a40a3ac1-af68-474f-bf76-66028ca17b49/updated": "a29cf610-f393-4342-9c02-42640a56f31c",
      "0e7ca047-14ff-4883-8977-877d36632d11/modernized": "7d9a2412-73b4-440d-ac70-66827c3e601e",
      "0e7ca047-14ff-4883-8977-877d36632d11/original": "2432eee2-44c8-4c05-94f7-fd6617059d38",
      "9ac03f31-dba4-4723-a8cd-4a67bde65757/updated": "3e8a4632-1eb4-42ef-aa8c-a5db4e500b8f",
      "8efe55b2-00e9-432b-853f-fc5f3cb8deaf/modernized": "36761379-8ebb-4624-9790-60d1106ef0a0",
      "8efe55b2-00e9-432b-853f-fc5f3cb8deaf/original": "2d54e55d-b35c-48e1-b4ce-92c0a5afece0",
      "769b12e4-b909-4fb0-9177-b74a1bef9f35/modernized": "9c00a7d7-9663-4466-a9cf-7320526a9b31",
      "769b12e4-b909-4fb0-9177-b74a1bef9f35/original": "1a964b57-d725-492b-8b9f-a79323ef2c7b",
      "769b12e4-b909-4fb0-9177-b74a1bef9f35/updated": "5adba698-9af8-4129-8fb7-ec864a67400a",
      "ede0dbbf-d031-4180-9ee5-e78641be72cd/modernized": "62cc22cc-25d5-46fa-b091-d081f5e7f802",
      "ede0dbbf-d031-4180-9ee5-e78641be72cd/original": "881d771e-73b1-43aa-bbde-18dd594858d3",
      "843e3d87-d877-432c-a54e-fbe7996022a8/modernized": "8d0252a1-0a52-4f5f-bda2-b9842bfa02f8",
      "843e3d87-d877-432c-a54e-fbe7996022a8/original": "381f222d-ed48-4439-9c0f-9b94ddeaac30",
      "1613ce28-3ff2-4802-b22f-111039e6e0ac/modernized": "7aeb0364-1055-4140-bab3-bdceb0886a60",
      "1613ce28-3ff2-4802-b22f-111039e6e0ac/original": "613df88a-7322-4a7a-b76d-d111b1403652",
      "8e77ebe3-8678-44d2-9826-8c1be2633dcc/modernized": "bd0769f5-7de0-4d73-bbb3-f061a637a641",
      "8e77ebe3-8678-44d2-9826-8c1be2633dcc/original": "20679748-f37a-4870-8cd2-636e92386fef",
      "951f52bb-fc11-4e76-a08d-c3dc52b8a07c/modernized": "bb24858e-0412-47b3-94cc-3883dedeafaf",
      "951f52bb-fc11-4e76-a08d-c3dc52b8a07c/original": "9e121e50-297d-4d26-abb8-9f114fdd37a2",
      "46cffe12-7fac-486d-8597-afecee546baa/modernized": "344d7ff0-dc84-448a-9412-6a9421d0066e",
      "46cffe12-7fac-486d-8597-afecee546baa/original": "84c89c05-b80a-4741-862c-8384245dc67e",
      "280c72ea-df5b-4504-a140-51aec77455e0/updated": "e986ad70-8971-4046-aed8-f472411402b6",
      "6793d8a5-4352-4c10-901c-7d1afbff80a6/updated": "9ed966b2-ad98-416d-9f9d-d9e044c04124",
      "778b9e77-1c50-4044-b6e5-487d629fb08b/updated": "2560da8a-69ac-4f83-b442-1fb8ac5f42e6",
      "960e1f3b-deb2-480a-83bf-ca7dfd3b965c/modernized": "4bb9182a-be38-47a7-868f-1053daa1ca76",
      "960e1f3b-deb2-480a-83bf-ca7dfd3b965c/original": "b3eceba1-edc1-4e91-982e-589dd43c1e62",
      "9811730b-0a00-4dea-b01f-c676df865802/modernized": "eb55ed1b-8b21-4346-921c-8bef4b689382",
      "9811730b-0a00-4dea-b01f-c676df865802/original": "433bf04a-73a9-4f15-bd36-18d98194d0a2",
      "3c1f4d2b-cefb-4a8f-a0aa-ad9de657b15f/modernized": "fafadb66-c2ab-4c0a-9ba8-7612496a6589",
      "3c1f4d2b-cefb-4a8f-a0aa-ad9de657b15f/original": "ddf46bf3-76e6-4f1a-a677-e006d66380af",
      "fbcf0659-f2d1-45fd-b560-15b98271dac2/updated": "e4a143d9-035c-417c-a8e1-5e36e707bb0c",
      "ad6a0837-7797-4c6c-a641-bfb722bedf21/modernized": "9d99a0bf-7b3e-4aff-bc92-aa537d1152cc",
      "ad6a0837-7797-4c6c-a641-bfb722bedf21/original": "1b55f9be-ca94-4a5d-aa1b-e4a681a6b783",
      "052ac10e-2c75-42c5-aa35-f38f34aa1214/modernized": "74f23862-f9e9-468e-98c6-6fb4799cf7b7",
      "052ac10e-2c75-42c5-aa35-f38f34aa1214/original": "6e238e18-4228-4096-b197-1024cef2fcdc",
      "14f4fcbb-1027-4364-977e-5a2aba92a827/modernized": "a35974de-9a23-4ac1-a8bf-cfc28b393e7e",
      "14f4fcbb-1027-4364-977e-5a2aba92a827/original": "a28726eb-7169-48d6-b184-ee618659458b",
      "135d7df6-48b1-4808-a810-e69756cd9279/modernized": "a86ca7e2-97c9-49a1-ab65-bbbc9a8609e6",
      "135d7df6-48b1-4808-a810-e69756cd9279/original": "2c210d96-3113-487f-b461-6a3bc50813e3",
      "c3f25765-0b8a-4fd4-99cf-28a159a23e21/modernized": "bf8b0e15-80fb-496d-b20e-24024a9cdd3a",
      "c3f25765-0b8a-4fd4-99cf-28a159a23e21/original": "3df76be3-dfa8-4e7e-a277-9aac09709dab",
      "492a89d4-0f81-490a-9619-b3a390d51307/updated": "0d28c268-ae5d-4ec8-a9af-b7cf04eaa129",
      "e27bc78c-ab04-4020-8c9f-9f1eed4f98e2/modernized": "658b8b2e-7720-48f2-a574-b9a5bf47085e",
      "e27bc78c-ab04-4020-8c9f-9f1eed4f98e2/updated": "35d53d1e-5a3e-44c2-ba0b-4990575760ab",
      "4cde3c89-ab46-4f03-9346-5608a58e8393/modernized": "716c37e6-d2d7-4b84-b0b1-78bb8ac7a31d",
      "4cde3c89-ab46-4f03-9346-5608a58e8393/original": "6899d0b6-f99e-4544-ae6b-54cab16c3ca3",
      "a52eb875-8a1a-4f2f-b1b4-650eb3af1126/updated": "445d861f-4881-4d29-90ce-874b792eb1e9",
      "20d1e00c-dd8b-4d28-9270-58c42b5c2b55/updated": "383f3a7d-91bc-4b96-97dc-716d0af88a01",
      "ac772bbc-3684-4436-801a-6a80215cda04/modernized": "3d7658f5-04e9-4467-ac63-20e31e114a8a",
      "ac772bbc-3684-4436-801a-6a80215cda04/original": "c38f6de1-15e0-45ad-839b-449016748a5c",
      "fa1addc4-a434-48da-8d82-bbb1db322151/updated": "4729beeb-f0e0-42b3-8441-bced787f7e8c",
      "dd809ae4-b0c0-46b4-8091-37329545d2d1/modernized": "577ed517-d911-4758-9a98-d45f7e9b9659",
      "dd809ae4-b0c0-46b4-8091-37329545d2d1/original": "2edd99b0-5774-4824-a142-b17a18f261a3",
      "8f5f5597-76f0-4d36-9bdb-2746c9530a4e/original": "404cb79a-e013-4b2f-a431-d4ae6682cb5e",
      "cb61d22a-4fc3-4fcb-94de-446fe50b49d2/original": "986338e3-f0fa-4c12-ba31-db57beefba23",
      "c352db51-cabc-47e8-ac58-bad1624bc070/original": "927e51c3-0108-48e5-91cb-b3d3362fc450",
      "f2ec6e4f-e07b-4f1f-a952-ab2e8ec8b041/original": "815a7a74-7777-4db6-8c6a-e0f0838d95df",
      "8558ff68-4d9d-47b6-8f00-57cade88b4c7/original": "5918e484-5a0f-4318-ace9-a056210e3c60",
      "f04088fc-c008-4630-a63a-b9bc40697080/original": "05c1b47e-1f94-4126-8974-32702cd252f5",
      "dcf39e10-9eaf-4878-98de-380b531fc2ee/updated": "b9520cec-f30e-4d65-913d-01f78f10ba50",
      "e5a1ecfb-4f0a-4c71-80bf-3ee924d0f46c/original": "e5b5cec2-4aca-4852-97df-6877a74bf92e",
      "1003add3-09be-4deb-8476-8a2be7c34405/updated": "291f945d-1eff-4d73-b131-ca8179dae3c3",
      "eca687be-9a29-49d3-8394-2ed21b85f9a3/modernized": "a8ad0c5b-75d2-4070-9e4c-11f1dbf99bc2",
      "eca687be-9a29-49d3-8394-2ed21b85f9a3/original": "049bb0e0-eec7-4701-aaa2-6d8e189c6219",
      "c43536d9-7992-4e18-9aea-9e51a5b93802/modernized": "a8092bb3-7ccf-44b0-a6e3-d3f5e23d6e92",
      "c43536d9-7992-4e18-9aea-9e51a5b93802/original": "dddd149c-3fd7-4dff-94e7-21e0bfd89b04",
      "35cd4c65-ea35-418d-a146-5bc3e5559247/modernized": "4ef6f53c-6040-4b66-b591-bf71a02d159e",
      "35cd4c65-ea35-418d-a146-5bc3e5559247/original": "13c94185-4d08-4429-8931-c9ddad724b11",
      "c9d8a647-792f-47c2-a0c5-4ba8773d5cc6/modernized": "19336fe9-7d31-4649-a48e-fd4ddebd2943",
      "c9d8a647-792f-47c2-a0c5-4ba8773d5cc6/original": "4529d9ed-9cb4-4c7f-9b07-4724f025322b",
      "9333dd0a-d92b-401e-a086-f611cc20f984/modernized": "2865d6ae-3150-4af9-aeae-04355c6d435d",
      "9333dd0a-d92b-401e-a086-f611cc20f984/original": "cf37696e-e184-44a2-a48e-a6bceb2c5862",
      "9333dd0a-d92b-401e-a086-f611cc20f984/updated": "b19eda35-d5bd-4d1a-8c23-2f0f7adadcef",
      "bed1a75e-bf7c-4bb4-9a84-1e6c908f6011/modernized": "661f3f96-17ae-48d3-a862-9aabb49a6e30",
      "bed1a75e-bf7c-4bb4-9a84-1e6c908f6011/original": "a8d7ebaa-9041-408a-aaea-592b6cc74321",
      "491af758-8872-4de2-a958-d9059761a661/original": "f55e6328-62ec-47fd-b8d0-1ac11b848bec",
      "1e2ad3c4-d14e-4277-b2f4-a520de5d5409/original": "5408d027-dd8d-40d0-a6fc-cecdf22aedf1",
      "f2f76200-7cb1-491a-a6d5-e5ecae939d28/original": "1902ccf6-9fe7-437b-92fa-607b1965cb52",
      "7727b95b-960f-491c-ac61-cf876d10b278/original": "4588c7c4-40f0-488d-99ed-01fd98cddad7",
      "c248c2e7-947b-4629-8296-0cdff67a6d99/updated": "01c22a50-d066-47a4-aed2-4ab9e8d44385",
      "62213938-9464-4930-9478-5f112c43fe54/updated": "e5d65567-c91f-4133-9fcb-5a6d89e3e784",
      "d0d15232-db51-48fc-a8ed-5e0b206f9a3f/modernized": "d45d6ee1-3ab3-474b-bd41-25e4db169fdc",
      "d0d15232-db51-48fc-a8ed-5e0b206f9a3f/original": "9e5a3b2c-46bd-4822-b7ae-db2b60ccb05f",
      "9c43d93e-8bfb-43bc-a238-310cf00b77a1/modernized": "59318155-8da1-48c3-b4c6-0debc89287f3",
      "9c43d93e-8bfb-43bc-a238-310cf00b77a1/original": "10c6441a-5534-4a2c-a66d-e7541c6826f0",
      "d94f2fb3-f19f-4aa3-a3a0-9b2ddf87da9c/updated": "138d9738-4d99-4252-934d-9f04988435f0",
      "3159f4ec-2dd4-465b-8b40-ca8056af7a0e/updated": "af418198-4ad6-4578-a0cd-e9ebd4fa990d",
      "b439fc1a-49d9-40df-8754-2faad952375d/modernized": "b1f60165-2982-4e44-9efa-b1d4e32b378b",
      "b439fc1a-49d9-40df-8754-2faad952375d/original": "741ea559-15ba-4768-93be-4043ff1e57e1",
      "3b301c59-f8dd-4029-b650-644b737a70ed/updated": "23dae5f8-1446-463d-a0ed-f248877c3504",
      "0f940360-9aaf-41d1-9601-e8ce60cfd4d7/modernized": "bb2be683-41aa-4383-a3c7-7df2faedb6cf",
      "0f940360-9aaf-41d1-9601-e8ce60cfd4d7/original": "e00fec98-95b7-4a01-a96b-463711c02ca5",
      "0f940360-9aaf-41d1-9601-e8ce60cfd4d7/updated": "e3a7ce26-3678-4716-9c54-ccb6b4857ae2",
      "d70a65d2-a3b6-48d8-8de0-b962aca084bf/updated": "090d73cd-710e-4819-a519-8e40ec04f0cf",
      "5721d1c1-0c0c-4ac7-96d6-dea095446958/modernized": "fb126ddf-c027-4844-83fc-64cfcc4fd17a",
      "d5d7987d-29a2-4ecb-ab5b-26e355d06a54/modernized": "726caed4-c25b-4112-a734-71f1be082995",
      "d5d7987d-29a2-4ecb-ab5b-26e355d06a54/original": "842f6b88-6cab-4b9c-ba45-64097b8831e4",
      "010d8d13-61c7-4485-8ab9-6fcd8297765b/updated": "11841f16-1db9-4c44-9edb-a4d35984804f",
      "6237d678-48f8-44df-9eac-004562987a60/modernized": "9bac50be-07d4-470c-9372-b50200f201c8",
      "6237d678-48f8-44df-9eac-004562987a60/original": "d4f8d9f5-f805-4212-a188-e44dd1e824f5",
      "b67bb076-0fe3-4959-9ebe-0aa1c7e41b28/modernized": "e4d12846-07f1-4340-8685-be3cc85461e8",
      "b67bb076-0fe3-4959-9ebe-0aa1c7e41b28/original": "f1779257-f32a-4835-a2fa-3069d1232898",
      "032c09e7-d87a-4fa2-95c2-5f2a04c5ee94/modernized": "c892518c-2965-43bb-b3e3-b8f791e42f65",
      "032c09e7-d87a-4fa2-95c2-5f2a04c5ee94/original": "62dc9e2f-1763-4694-88bb-b94846785c76",
      "318ac4f2-08ba-43d1-8d96-80d1714caddc/modernized": "1f668658-b005-4152-b1b9-a0daa56fa83e",
      "318ac4f2-08ba-43d1-8d96-80d1714caddc/original": "e90abeba-6a86-45d7-a4e2-ace154b5494c",
      "3e29db68-80d4-4361-aab2-8be702338705/modernized": "6e73b254-5f40-41e2-a8c0-7080f379135d",
      "3e29db68-80d4-4361-aab2-8be702338705/original": "c2d35656-4509-46c2-91e1-2e768e22c57b",
      "2bb79cd9-88c3-4801-ae66-ac70970c97bc/modernized": "9562d458-6ea1-43be-9f45-30ca46c69c1a",
      "2bb79cd9-88c3-4801-ae66-ac70970c97bc/original": "288df292-b2f3-4919-99e8-0d387546f4d5",
      "b40a8274-196a-43e3-9fef-0c96ab9ce55a/updated": "a27480c9-8efa-4fe5-ab51-c663cfe0c467",
      "54d7505f-a7af-40fd-a21b-33cb6ad5b0a0/modernized": "5cdd4a69-f5b1-4f32-ac37-6b048ba4fb95",
      "54d7505f-a7af-40fd-a21b-33cb6ad5b0a0/original": "22a81e11-8fb5-4ee1-ba10-5485b2a5145f",
      "91324cab-b3aa-4b46-abab-703f24a68f95/updated": "a126b08c-2e38-4a93-afa4-7d95e80d47e8",
      "bc710dda-f13a-4208-a8dc-e94fac82dbe6/modernized": "fe46744c-1ba4-4f89-8002-6a870b545164",
      "bc710dda-f13a-4208-a8dc-e94fac82dbe6/original": "6824ed38-8695-45be-a859-212c6f6c7d03",
      "cf6f05e2-e5c9-4ec3-8096-d283f3e4c020/updated": "ae7ee680-4143-48e8-be13-1a521f575a58",
      "ad348a05-9f91-4f36-90eb-cf5ad94835b1/modernized": "68a1e974-c233-4a6e-9f22-ccfa6e8a2f75",
      "ad348a05-9f91-4f36-90eb-cf5ad94835b1/original": "32fa80a7-f4ee-4ee2-a425-92c41cd77701",
      "b74bd655-8907-4484-a3bd-a658b3267dea/modernized": "295cfd90-7ddb-4813-a35b-b5f7fc58451c",
      "b74bd655-8907-4484-a3bd-a658b3267dea/original": "bf195905-bed4-4442-a932-73b68e2a6eee",
      "af2d9f25-005b-4144-bdac-80bb059700a6/modernized": "20e3705f-2637-40e6-b9f2-8ea6fc75823b",
      "af2d9f25-005b-4144-bdac-80bb059700a6/original": "a4c4ffaa-17f2-4cfc-bde4-cdfe862295c3",
      "6f47a04b-de86-4646-ba0f-52c7bdbd2ae3/original": "b156064c-4895-4511-b2c8-e439d10e58ed",
      "073e1a75-2193-4b5b-9de1-5a06a8a970e4/original": "69ba388b-7b79-48ad-b807-60d42d4f1bb2",
      "d4f97e5f-72fa-4d07-b6c5-21f4712e6f70/original": "10c564d4-5f26-4253-99af-f990a61643be",
      "041de011-afa1-45fb-bf77-9618e4bdb529/original": "c18c79a8-5f83-4b3f-8d0b-37a7e455ee30",
      "29b459d6-16ae-4f64-a03c-4ee1794b3523/updated": "4ac8b7ae-085c-4d04-a440-4a166c1bd7a0",
      "0e46ae49-4202-446a-b5c3-06514aa16fa5/modernized": "3f6c171a-2991-4bcc-9017-cf3669720412",
      "0e46ae49-4202-446a-b5c3-06514aa16fa5/original": "313be497-3c15-4dae-bc2a-b05f3073da70",
      "0e46ae49-4202-446a-b5c3-06514aa16fa5/updated": "e941e648-2459-4692-bad1-19c58d1904f7",
      "1b31482a-5cba-4ab3-b562-462b0a2b4fd3/updated": "5da5e1e5-b498-4c07-8d1c-a2a59dc7ee6c",
      "a3016ba9-1370-4b8c-b680-98f383317f3b/updated": "32c4e7ed-af29-41fc-bcfc-b16c84ee50c4",
      "f93a7eb9-cef7-4b30-81da-7d1a3cd35de2/modernized": "dfaa4e7e-b1e7-4272-b3ae-37b4af3c8da9",
      "f93a7eb9-cef7-4b30-81da-7d1a3cd35de2/original": "6cefe8e1-c679-45a9-83ce-360b205faee1",
      "5f77b4a4-74e8-4d20-a524-c16e1488ff7d/modernized": "d8605252-fd37-4a3a-b52d-eff3a75b7a52",
      "5f77b4a4-74e8-4d20-a524-c16e1488ff7d/original": "341166fd-bf10-415d-b210-fc7118ad7010",
      "671213db-60a7-42ed-9c07-4785e321de26/modernized": "104df08c-c6da-4329-bf12-ea5a5cb45dea",
      "671213db-60a7-42ed-9c07-4785e321de26/original": "1242a4ee-e0b0-4e2a-a31e-3f336d6a32ee",
      "06d0660f-5f23-4e27-a13d-5c670dbb41e6/modernized": "eaf64657-9203-4c6d-834b-4dce2f06a7b5",
      "06d0660f-5f23-4e27-a13d-5c670dbb41e6/original": "35c7fc3f-c765-40ec-80db-d006c5f695c2",
      "470677d5-c6e0-4d1f-a61d-69827d25a14c/updated": "eccee862-c659-42d5-bfb7-e30f72f172b9",
      "1e81ab5f-4f72-4570-93a1-e446e1e70267/modernized": "e31c8644-bd73-45a3-ab5f-6f30becc76ce",
      "1e81ab5f-4f72-4570-93a1-e446e1e70267/original": "d64687b2-6bd2-4394-8b86-f18fc12c3c05",
      "1e81ab5f-4f72-4570-93a1-e446e1e70267/updated": "cfe27f46-1c19-4263-af3a-eb58ca61cc14",
      "f044dc3e-9e30-41a0-80db-a9af65ff609d/modernized": "e9f24fe8-d9d4-413a-8e3c-d499b9934eaa",
      "f044dc3e-9e30-41a0-80db-a9af65ff609d/original": "48be0222-76af-46e6-a87a-0db868d2ef83",
      "f044dc3e-9e30-41a0-80db-a9af65ff609d/updated": "c999feb2-f174-461d-b935-233a222b357d",
      "6ee37dca-0b73-4676-aed8-2de0876a0f6b/modernized": "0def63ee-6b4f-4fc3-81a0-3b1570f695f0",
      "6ee37dca-0b73-4676-aed8-2de0876a0f6b/original": "d43fdda0-e97e-412c-9079-72f24cb648e5",
      "873dacbb-3205-4afb-8c38-772fb7a09fed/updated": "5ccb094b-f70c-4557-afe1-58b84f8546ca",
      "3ae687a1-e934-4585-8abd-a477d0cb3b75/original": "3f6f326b-758d-4c60-a36b-5fca7dff699f",
      "609192d0-3eef-4a47-85e8-59d3d2127bbd/modernized": "ac73a508-2657-46c4-b048-f7e6d168f03b",
      "609192d0-3eef-4a47-85e8-59d3d2127bbd/original": "0b774cf3-4e12-417c-898d-0248f0f40db5",
      "84ca0ff5-f17c-49ff-9bde-6c9f67a6a352/modernized": "016a7b85-b5ae-4e97-afec-aeda091ca131",
      "84ca0ff5-f17c-49ff-9bde-6c9f67a6a352/original": "e8b64bbc-7f5f-4aa7-a962-615f68bf1808",
      "9ccf1452-3687-4d3e-821a-2caf315092a1/modernized": "2f842b62-cb70-41da-924f-f926a4d4c548",
      "9ccf1452-3687-4d3e-821a-2caf315092a1/original": "285fbeb4-2c7a-4212-a25b-5051a0e37b27",
      "9ec7c639-b4eb-4e58-aa37-fdc23817f5f3/modernized": "b473ae14-e694-4ae9-b37a-53b8ac74038d",
      "9ec7c639-b4eb-4e58-aa37-fdc23817f5f3/original": "97e92495-2502-4a74-880a-801720f1401a",
      "0451a301-8654-42e3-8701-6288579e5bbb/modernized": "bd37c35d-76aa-41d5-910b-c8015afe89f7",
      "0451a301-8654-42e3-8701-6288579e5bbb/original": "50b5ed84-54ee-41ea-9a16-b02f0b14a5e8",
      "88220215-a675-4b8c-8762-0dd13d8c649a/modernized": "4b3fa9ca-9f6a-472f-a5c7-e261d2b31178",
      "88220215-a675-4b8c-8762-0dd13d8c649a/original": "c5d14e94-00af-4ea3-8059-c041ba6d7db0",
      "20c95c47-62dd-4181-b6e7-dcd8142626ca/modernized": "e902030c-1862-4fdb-b9ad-2d468d7dfa81",
      "20c95c47-62dd-4181-b6e7-dcd8142626ca/original": "07abc386-e67b-4ef2-b4ad-fa5471c612ef",
      "b7fb02eb-f804-431a-9c0c-7ead12400bf5/updated": "91ed3919-4380-4687-8e65-21907574eac8",
      "f9356ff3-a098-45b1-9ed2-022790240c01/updated": "4137a39a-5321-46c1-87e9-f018babf8bf7",
      "57ac3979-2623-4737-8593-5b3cb2d0e1a6/modernized": "6d0648c6-b768-4a88-869f-c7fcac2ea6e2",
      "57ac3979-2623-4737-8593-5b3cb2d0e1a6/original": "2e8ad800-d757-4fd5-96aa-e6cfba5447f0",
      "61583c71-4b03-4c37-9bfd-c1ee78d0907e/modernized": "4878d40d-ef95-4f5e-b6ae-3e39f87c4368",
      "61583c71-4b03-4c37-9bfd-c1ee78d0907e/original": "c6ca0a7e-dd49-48a7-8b20-24c7dc25e6cc",
      "932ed314-b6c2-48c4-b4d8-19ca31d0db49/modernized": "04e5c504-8d3b-4b9b-87e4-188af34e4eca",
      "932ed314-b6c2-48c4-b4d8-19ca31d0db49/original": "82aa7353-60b7-4861-8ae0-d783c0eef1e6",
      "4cd93994-8176-4269-aae3-63eb68fdef28/modernized": "9c9be120-2953-4dcf-9717-3238df306e78",
      "4cd93994-8176-4269-aae3-63eb68fdef28/original": "2bf55303-fcbf-4ae0-8b8d-bcf6ced906c7",
      "8e66ed6c-5a9f-4842-91c3-4d2b32b02e93/modernized": "1d0e22f1-2061-4355-81b4-4b1d2b208bee",
      "8e66ed6c-5a9f-4842-91c3-4d2b32b02e93/original": "18f9643f-57cf-4535-98bb-9ac958b4cb13",
      "92d2a0ab-55d5-4fc1-aaf6-f003b172898d/modernized": "93f67eae-4df5-436b-9c2b-d7a40866261f",
      "92d2a0ab-55d5-4fc1-aaf6-f003b172898d/original": "31bdff07-f804-4981-a070-4ee0e4adcd26",
      "a689e647-7065-4bf5-8b50-c4f3b1e73135/modernized": "64b1a92c-b018-480c-b2a1-73aba1592267",
      "a689e647-7065-4bf5-8b50-c4f3b1e73135/original": "2a247ec0-21b7-4ae9-9818-bb8019510eeb",
      "a689e647-7065-4bf5-8b50-c4f3b1e73135/updated": "9411e9d8-ba0e-4590-acba-5e1a84b7c755",
      "a64bc50d-4a4c-47ad-9e83-d72bbf5363b7/modernized": "cc75dfad-0f2c-459e-a3c3-342ce5de5423",
      "a64bc50d-4a4c-47ad-9e83-d72bbf5363b7/original": "e2d6be8a-d595-413c-ac62-b298b4c2e9b3",
      "468770bf-aae5-4c4a-a2b3-41d978f3dd72/modernized": "ac4eccf8-845d-45d0-90ca-187bc845c76f",
      "468770bf-aae5-4c4a-a2b3-41d978f3dd72/original": "37114ea5-55a3-4919-a188-bd6d9365bbca",
      "53f7cdb3-6c11-47d2-9a5d-0fcd41b5ab57/modernized": "4d3c4902-7246-42ff-9aed-c824de27a4e2",
      "53f7cdb3-6c11-47d2-9a5d-0fcd41b5ab57/original": "93c8c169-f2f8-41c6-80c5-69107cac0e1a",
      "9bd10df3-80aa-4623-b66a-61e00f112b47/modernized": "c005a229-fcbe-445a-aaaa-2b2ce7d283b2",
      "9bd10df3-80aa-4623-b66a-61e00f112b47/original": "7eaffdf4-43cc-48e1-a7f7-9af57fd87435",
      "88b23e33-bee6-4792-a282-7b7118e818dc/modernized": "14c864cf-5281-4fb6-babd-57d733900807",
      "88b23e33-bee6-4792-a282-7b7118e818dc/original": "e6febfcc-23b1-4511-9963-9eeb359bfee6",
      "67f4202e-ceff-402c-ad33-c1cb530dd247/modernized": "eeb028a9-82dd-4c72-8927-a9a31bcbd68b",
      "67f4202e-ceff-402c-ad33-c1cb530dd247/original": "6777bbe1-0c01-4366-8ed0-b393a3235621",
      "c7ef46fd-ed93-471e-971a-32b2e4d8558e/modernized": "4485beb4-6c72-4a23-91e8-bd1749e65ec9",
      "c7ef46fd-ed93-471e-971a-32b2e4d8558e/original": "64c91287-8088-4bab-9327-9b3b7c35c9af",
      "45dca7c2-3ff9-4a83-acdf-55ec1630cb25/modernized": "63bfb9e7-ad28-47a2-809f-a4433a70b471",
      "45dca7c2-3ff9-4a83-acdf-55ec1630cb25/original": "37d6e99a-b7e7-4a02-8612-e60049e85546",
      "dfda01ed-36ec-4b37-96fd-9e23b0352fa1/modernized": "285900a7-a744-4642-9d3b-5e2da1a39671",
      "dfda01ed-36ec-4b37-96fd-9e23b0352fa1/original": "eb3f7a2a-8ad9-443a-aa73-f6b13ffa8821",
      "dfda01ed-36ec-4b37-96fd-9e23b0352fa1/updated": "ca51838c-ce5d-485d-a798-ddb0fe68f0fd",
      "49084c34-f64e-4316-b238-49b7a37e5a8a/modernized": "b0c4dc8e-dab7-4e07-8216-7d93d0a0461a",
      "49084c34-f64e-4316-b238-49b7a37e5a8a/original": "fdbd2017-8d20-4045-bdfb-3d202738311c",
      "a2e8dd81-d87a-4287-b1a6-b67254eb4727/modernized": "88b8b2ca-c06f-4760-a4b9-ef3a552ed70b",
      "a2e8dd81-d87a-4287-b1a6-b67254eb4727/original": "5339484d-a726-4025-a564-f1bb695efcc0",
      "a8da908c-c9b4-4583-a2a3-ee460a90a4b9/original": "93d34353-b45a-4638-aded-1da2b97c73de",
      "fea5c7ff-bd6f-4c46-b928-c3b4fb1a04e6/updated": "c331b3ab-8a41-4a2c-81cc-add66a1b7658",
      "a0aa67e3-e96e-44ea-a90c-db739d54eba6/updated": "41fb24c9-3ecf-4c6e-8202-9642fd95f8a8",
      "f869e6e5-c5a2-4bdf-96bb-1c4dc13dad2f/updated": "5a169acd-485f-43f7-ad26-a301ae096e36",
      "2460c682-7d5d-408b-b059-e05e28a19aea/modernized": "2d3a8e74-7bf9-41d2-bc3f-69afd314a645",
      "2460c682-7d5d-408b-b059-e05e28a19aea/original": "5b76b000-0ca4-421e-a7e3-99b519cc2c85",
      "2460c682-7d5d-408b-b059-e05e28a19aea/updated": "1ca1325d-5c96-4983-9d16-1e2cd40e2354",
      "51303b80-b6c1-4d45-a740-bf3eaf0767e4/modernized": "6f482d84-ff6e-46c3-87b6-5e99919d8c53",
      "51303b80-b6c1-4d45-a740-bf3eaf0767e4/original": "a201751c-6b27-4b5a-ab48-78b62ba5056f",
      "99ecfc4d-8a51-411d-805e-f5243d4879ed/modernized": "6835d74b-0c78-4abe-90da-b4a8b0a826bd",
      "99ecfc4d-8a51-411d-805e-f5243d4879ed/original": "39576963-c46d-4df5-a7a6-1543fc54449b",
      "99ecfc4d-8a51-411d-805e-f5243d4879ed/updated": "53fce188-e018-42b8-aea6-5a916795299e",
      "53f21a86-f264-460f-b879-3cd4a7ddf615/modernized": "8323bb39-707d-487b-8f5a-7e808ca2a42f",
      "53f21a86-f264-460f-b879-3cd4a7ddf615/original": "07556919-8150-4505-a3e7-7836e8199589",
      "c3428a4c-4a2f-480b-8612-f96e104914dd/modernized": "a2a2ce96-71c5-462e-aa78-22d54ec448f2",
      "c3428a4c-4a2f-480b-8612-f96e104914dd/original": "49854f49-9ac2-423f-99f5-2676623bd90b",
      "d230b8ce-a185-42b5-bdf1-cf54130e2764/modernized": "781ae6b1-ffc0-4e53-83ce-2a0955fe2cbf",
      "d230b8ce-a185-42b5-bdf1-cf54130e2764/original": "db349e17-3875-44ad-b708-781de618f0f2",
      "d230b8ce-a185-42b5-bdf1-cf54130e2764/updated": "ddd563fa-44a8-49bd-a5fe-f4eef40ac431",
      "d106a18d-6092-4628-a1ec-822f68127743/modernized": "2f375c8c-52b4-4a05-9354-1f76da99a90a",
      "d106a18d-6092-4628-a1ec-822f68127743/original": "14c6e5de-e923-4a00-9f66-be444ef9ca17",
      "61e7cf9c-a688-4003-be35-e574a750ec10/modernized": "7f2bae1c-20c7-4ad5-8b92-077e076291ed",
      "61e7cf9c-a688-4003-be35-e574a750ec10/original": "c0a49904-4bf7-4a26-9ea2-47e680d671df",
      "00e872a0-b65e-4bd8-92d7-71ffb3a17d91/modernized": "58be602e-73aa-4615-81ca-4c3704206592",
      "00e872a0-b65e-4bd8-92d7-71ffb3a17d91/original": "e1cf859a-b60c-43d2-8d31-6559df5a6071",
      "8b8604f4-042c-46b9-bdf6-a3ad6921164a/modernized": "bca12799-b313-4492-8de4-830cabd966eb",
      "8b8604f4-042c-46b9-bdf6-a3ad6921164a/original": "80cb0212-cb73-4813-b00f-18f353df863b",
      "2e80b149-e111-4c8c-ab7a-c5e1ed3861f4/modernized": "1690fad7-b280-41d0-919a-af9017acab97",
      "2e80b149-e111-4c8c-ab7a-c5e1ed3861f4/original": "569b6502-7416-49cc-bca0-76c2031de7ad",
      "0d7bb9f8-b098-4dbd-9780-b32805b43e96/updated": "afc4b263-ae2c-448b-969d-2c8409e93705",
      "2eb862e1-cc3e-4588-a504-98db07a85474/updated": "8edb08a5-07f0-4906-b3e3-0be67bb2334b",
      "b63ebb27-7aff-4795-ba5b-fd7f2dfe933e/modernized": "5cd85183-a549-41c9-af84-43087841c1e8",
      "b63ebb27-7aff-4795-ba5b-fd7f2dfe933e/original": "80236016-efc2-4401-9fe9-93183a7e0c56",
      "acde1806-f0f7-4ed7-a430-b0c8834bc366/modernized": "125b256a-2236-4dbb-9458-c92fb1643769",
      "acde1806-f0f7-4ed7-a430-b0c8834bc366/original": "792b0d22-3c50-4009-bc59-6589b691afb2",
      "2ff4c475-b7a6-411f-a960-75edf4bb79fd/modernized": "7e2eda10-7b90-4f01-9974-c2ddf8262d0b",
      "2ff4c475-b7a6-411f-a960-75edf4bb79fd/original": "849546d3-d20b-48b3-8d6d-64877d481005",
      "c960e64d-3daf-410d-b028-cbf3d2cb1f77/modernized": "3b7da8ac-f111-48c6-807f-4c8b5e547d19",
      "c960e64d-3daf-410d-b028-cbf3d2cb1f77/original": "fac098f6-0f3b-4e44-bd47-aaae35269ddd",
      "0af1efec-461d-4936-bf91-cc0f44a60bd9/modernized": "3148f1d2-4351-4cb6-9554-d93d53515db5",
      "0af1efec-461d-4936-bf91-cc0f44a60bd9/original": "57f97d14-b52e-49e9-aaf6-cdb605a7c38b",
      "9511ab72-9a2e-4c6e-a102-1f46aebbd348/modernized": "5e2fd0c5-fb4f-4b41-ad89-65e61b6a6ffa",
      "9511ab72-9a2e-4c6e-a102-1f46aebbd348/original": "27c7f307-71a1-43bf-8709-1813ec51d560",
      "659d4885-daa3-42e1-acc4-827ec5cd0d36/updated": "c54719f8-8d6e-40e3-81b1-c6e29120a536",
      "62e5131b-33a2-425e-8d33-e912b2b9f0ca/modernized": "d2f1d0fb-01cb-4be1-bc01-0b0b44353b1b",
      "62e5131b-33a2-425e-8d33-e912b2b9f0ca/original": "d2a7f900-c864-4dd9-9d8f-3219eb5cbeb1",
      "dcc2ccc5-0fdb-4dd1-8783-5363bb0b0c27/modernized": "da19dcf5-317f-45d5-bb06-96d2d78a9326",
      "91c346f7-2909-4aca-8987-a96cc41683d1/modernized": "7a16aad9-d0cb-4516-8760-b56582523f53",
      "9acb6df3-765e-47bd-b50c-bab6b3cd7239/modernized": "c087ec82-e747-46a9-bb28-a98d9eec1aa4",
      "9acb6df3-765e-47bd-b50c-bab6b3cd7239/original": "6882c227-686b-45dd-bd2b-72bc2743d6fd",
      "3d5dd1fa-ae0c-49fd-9b28-21eb91abe1c7/updated": "44d408a6-f3c1-48c8-b5e8-9f090d306d9b",
      "bce132e2-5ff8-4b5d-b225-e7195cbdb4f3/modernized": "382ee1e0-554a-4e31-994d-2cef3f71cdb0",
      "bce132e2-5ff8-4b5d-b225-e7195cbdb4f3/original": "0ed35d57-6e08-4ac4-9f94-090fa0201f36",
      "f4781480-fa53-41b6-bdb0-fdecb16089c0/modernized": "46a100f3-de1b-4d96-8a4a-e7872478d2dc",
      "f4781480-fa53-41b6-bdb0-fdecb16089c0/original": "ef69bff4-7bef-4bfd-aaa3-87a643ebcae6",
      "e1f74ba8-b391-4c4e-a77e-f9fcdb6fd8ff/modernized": "f2777325-e8f7-4483-818d-ab013faea2ab",
      "e1f74ba8-b391-4c4e-a77e-f9fcdb6fd8ff/original": "3619ed95-9660-4e87-a866-1588d22e9468",
      "b61fceff-a434-43f4-9443-342a9137202e/modernized": "88ddb972-556c-4164-98da-b1111d8c0bc4",
      "b61fceff-a434-43f4-9443-342a9137202e/original": "3bcbc897-87b8-4446-a20f-7d232888c108",
      "02742c56-b5af-491b-a1bf-ea1e1fc65bdf/modernized": "809ce518-7cec-4593-a3b4-903a6a0d7720",
      "02742c56-b5af-491b-a1bf-ea1e1fc65bdf/original": "44296cfc-f5a2-41b7-b983-3283d77e3418",
      "bd22a3f4-51e1-45a5-9b65-2f0b21bde039/modernized": "24eb8a69-a7ce-4ed2-88e7-0ef7f5764f2c",
      "96e169c3-ab19-4e1a-bc1b-0b3f44de73be/updated": "22fc3f92-67cc-4afe-9b4b-8603ff83dc87",
      "6d4a1bc7-b97e-4ad6-b55a-ddb7cec564ec/original": "626b687f-6ebe-4285-bea8-9a309244548b",
      "30ef0a6f-1840-4e66-bb1a-563d1cca1db1/modernized": "ae28be66-db6b-4bab-bb15-62f9336aefda",
      "30ef0a6f-1840-4e66-bb1a-563d1cca1db1/original": "ffd551e1-75e2-49b3-946a-7ed7ab75bdd7",
      "a3c29af3-f14e-47da-b290-2548e09ae1d4/original": "b899c791-56a9-4cd3-a139-0da86b89c786",
      "53561891-6761-41b8-b5f8-a1ed91e5dde8/updated": "4f04f8f1-6a86-44f2-9904-eec576bed9e2",
      "a1b1457c-3678-4659-916d-c7b66e465b7e/updated": "fc0f593c-c31d-49a7-a74d-cbce6f50b3eb",
      "7fb96085-7cc6-47df-8fdd-53b100d1ffe7/modernized": "f95a5072-07b7-4fd8-af76-096cb1f34e4b",
      "7fb96085-7cc6-47df-8fdd-53b100d1ffe7/original": "ac9b7918-53e6-4750-ba1d-5844b8d3bef8",
      "25755480-7f1c-4f7f-8900-3f472001fae4/modernized": "f759ce7e-e5ad-4a39-bce1-604d62c5e3b9",
      "25755480-7f1c-4f7f-8900-3f472001fae4/original": "a41e2a06-157e-440e-80c6-433139cbd4e0",
      "69c5fc26-76e3-4302-964e-ba46d889003b/original": "79b1a477-74b1-4c20-ad52-023328ab648c",
      "5eae7905-1c99-45ba-8ecd-ffd1cba8be47/updated": "4be67585-cf5e-4349-90bc-c1d32797ebc6",
      "0e8bb936-8929-4495-90ea-8f8c8d81544d/updated": "e9ea435b-8760-4b78-8313-41cddd2bbcce",
      "4c88539f-f168-4972-89d7-be945dc62863/updated": "a26c1dfe-5ad3-4893-90ed-6bbe5f10fe9e",
      "314bb746-3449-4e69-aacd-8bae50fe92a1/updated": "1b1ccde2-da50-4242-9d7b-54933d6fc1c7",
      "110bb5b7-267e-4d70-9b4d-64b6e46729f2/updated": "1bc16af7-ec77-49b6-80dd-1da787645f1b",
      "3a4567fd-c9b3-47f9-82aa-cebd539caaaa/updated": "53742ace-59a6-4763-a91a-8b1f0d651070",
      "b0dacd28-1f1c-4f89-ba0f-fc562c3566d8/updated": "9c00406b-4f99-4b0e-919e-c7f4031bfceb",
      "bb2e6fb5-156a-4b24-b5aa-f1deefccb5b2/updated": "798ca5e3-011b-4628-89b7-cb4a803f359a",
      "3358b507-cb00-4121-8f85-2ba75b896bb9/updated": "32d48e8e-a102-4a20-9e49-6dafa9834dba",
      "fa42e9c6-b5d9-4c74-aea7-3816efb8bd2e/updated": "7381dace-6f89-440e-b999-c4940edd5249",
      "6ca63604-3364-4098-a604-190e5d0b0d9e/updated": "d16a78aa-d6ba-4e6b-80e8-02a7a7f70066",
      "78ec9b39-f599-4842-b843-b02080972349/updated": "b4c467fa-c6fc-42b3-94cf-0824fc948ba6",
      "5230bd9c-e096-4697-8664-a6eb379836f2/updated": "e25caf4c-a9fd-4002-b8fa-eb31a8e2d2d6",
      "4146cfca-8664-44a9-9969-edcf8c8c77cf/updated": "f8d412d7-afd4-4df5-9e4f-463a257b8aaf",
      "d817ab14-ce02-434e-83a4-f8a142e0affd/updated": "b8c69227-60a1-4b99-9e15-3cbac148e92d",
      "8894463d-1a61-4d04-8c5a-2ea4ce3ca8eb/updated": "2a68e519-f9b2-4fce-9fe6-390c8a923969",
      "d4582fa7-f570-443d-bc76-856277696f3d/updated": "26af3561-ebbd-4661-8830-a80a15372fe6",
      "02f425a0-aca5-4a17-9a24-4b28c9640b41/updated": "90c81415-6d00-4e28-8d31-d6072cc13850",
      "d588963b-e583-4023-abad-b7c526315451/updated": "185934cd-435f-4aa3-8bff-5a20d29c7d7a",
      "003f07e3-3930-4f58-a6dd-5fb9fa6e765a/updated": "df7862fa-a6cc-41d7-aa72-faf91f1cd271",
      "8fbadbad-0fc1-4dfa-9fb4-d96e7c00ff58/updated": "16aa93bc-779f-416d-a431-a6bf63ff53b0",
      "2ec53b58-f539-4311-8d09-bf3f28c14a8b/updated": "d08bb097-97e2-4a9f-9af3-d08b76070ed6",
      "d3a7084f-5f52-441c-9088-55f86ae5fb19/updated": "7abc4f70-4f50-47f6-88de-f6beaa27ea84",
      "6cb39a45-8ba6-4ea2-a248-872a4bd75d19/updated": "9624af1c-0070-44d7-95d5-0d68635ee2ce",
      "2dee903b-4a9a-4dae-a9d3-d7937029471a/updated": "eaef46c7-79fb-4a96-a7f1-0534bd32e7dd",
      "ee1e556f-0462-49bc-a2e3-7c3924c9fb48/updated": "3698d347-1c65-4ba0-ba2d-958d4d148f3f",
      "55d322b1-0e53-4281-9c7b-cf50547d8221/updated": "c8277b50-c708-4a8c-89a4-409af1f5876a",
      "8b902ddb-8a70-414a-a6e5-1a815dd6d2e9/updated": "dfd403dd-4778-4486-9b03-4c4dd45a9966",
      "45b75dca-02cb-46ff-adf3-b08d0f044dad/updated": "eeec9dcd-5210-445a-9286-9465a04937ca",
      "1314f777-2b9e-40b4-b148-18e64278557a/updated": "1f7e80ea-a293-44d1-bdf3-56b04c5c20a8",
      "398c7f5a-3fa4-4a29-a275-a0f33920ce08/updated": "b2e92cb0-85c5-40ec-9cb5-98506a8a7a5c",
      "9a0ac9a9-9111-4ff8-b416-4b26adc64a87/updated": "31c9ecc3-b6cd-4b51-ad21-d8bec0a56c13",
      "1a7c0e85-250c-43c9-adbd-0b98972fb9d3/updated": "12c6720f-1850-462f-bb40-958d37fd6077",
      "bf004555-1175-4cd4-8bcb-d5954e2efa4e/updated": "48d9204d-1222-432c-aca9-90623d1beafd",
      "947049d8-78f9-4f8b-9b5a-56413b3fe60a/updated": "4cc28c97-0ccf-477d-bb52-1dbced014c4b",
      "17d5addc-df02-450b-8fc8-f845292af618/updated": "74439c5d-722f-451d-93ce-072e684ba4e9",
      "c68cd139-7ed7-49aa-bb20-36434e16f981/updated": "43a0b521-7425-4c11-a494-4f8e2e7b8c7d",
      "0089dff8-b287-4b8f-9418-543fa4cc6ffb/updated": "5948486f-4622-4707-8dd5-e4aea75d16a4",
      "da278bff-6921-412d-b518-b249e5855fc1/updated": "e77c3ac5-f18e-4a44-b57a-bd20a50ef114",
      "41b1ae64-5130-418e-9fea-a004dbdb46d5/updated": "0e3b6527-4451-45cf-93d3-298b0878ab63",
      "184123b9-03ca-44aa-9242-50f339d8c711/updated": "ea00110d-b0a8-401a-b83d-ae33ac9623b3",
      "22795d6d-951c-4690-9a2b-a487acf1f784/updated": "5b93b931-7cbc-404b-a0bb-b094c845e9bd",
    ]
  }
}
