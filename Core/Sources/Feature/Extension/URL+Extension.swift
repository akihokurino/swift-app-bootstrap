//
//  URL+Extension.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

import Foundation

extension URL {
    var withoutQuery: URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.query = nil
        return components.url!
    }

    func queryValue(key: String) -> String? {
        return URLComponents(string: absoluteString)?.getParameterValue(for: key)
    }
}

extension URLComponents {
    func getParameterValue(for parameter: String) -> String? {
        self.queryItems?.first(where: { $0.name == parameter })?.value
    }
}
