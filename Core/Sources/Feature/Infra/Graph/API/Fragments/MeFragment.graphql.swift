// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension API {
  struct MeFragment: API.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment MeFragment on Me { __typename id }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { API.Objects.Me }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
    ] }

    var id: API.ID { __data["id"] }
  }

}