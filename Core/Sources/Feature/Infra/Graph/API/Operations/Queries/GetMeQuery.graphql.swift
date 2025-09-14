// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension API {
  class GetMeQuery: GraphQLQuery {
    static let operationName: String = "GetMe"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetMe { me { __typename ...MeFragment } }"#,
        fragments: [MeFragment.self]
      ))

    public init() {}

    struct Data: API.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { API.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("me", Me.self),
      ] }

      var me: Me { __data["me"] }

      /// Me
      ///
      /// Parent Type: `Me`
      struct Me: API.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { API.Objects.Me }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(MeFragment.self),
        ] }

        var id: API.ID { __data["id"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var meFragment: MeFragment { _toFragment() }
        }
      }
    }
  }

}