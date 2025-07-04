//
//  GraphTypes.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

typealias Me = API.MeFragment
extension Me: @unchecked Sendable, Identifiable {}
typealias User = API.UserFragment
extension User: @unchecked Sendable, Identifiable {}

extension API.GetMeQuery.Data: @unchecked Sendable {}
extension API.GetUserListQuery.Data: @unchecked Sendable {}
