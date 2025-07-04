//
//  DI.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

import ComposableArchitecture
import Foundation

struct Config {
    let apiBaseUrl = "https://\(Bundle.main.object(forInfoDictionaryKey: "API HOST") as! String)/default/api/graphql"
}

extension Config: DependencyKey {
    static let liveValue = Config()
}

extension GraphClient: DependencyKey {
    static let liveValue = GraphClient(config: Config.liveValue)
}

extension DependencyValues {
    var gqlClient: GraphClient {
        get { self[GraphClient.self] }
        set { self[GraphClient.self] = newValue }
    }
}
