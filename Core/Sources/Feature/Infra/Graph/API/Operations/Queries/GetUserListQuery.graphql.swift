// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension API {
  class GetUserListQuery: GraphQLQuery {
    static let operationName: String = "GetUserList"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetUserList { users { __typename ...UserFragment } }"#,
        fragments: [UserFragment.self]
      ))

    public init() {}

    struct Data: API.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { API.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("users", [User].self),
      ] }

      var users: [User] { __data["users"] }

      /// User
      ///
      /// Parent Type: `User`
      struct User: API.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(UserFragment.self),
        ] }

        var id: API.ID { __data["id"] }

        struct Fragments: FragmentContainer {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          var userFragment: UserFragment { _toFragment() }
        }
      }
    }
  }

}