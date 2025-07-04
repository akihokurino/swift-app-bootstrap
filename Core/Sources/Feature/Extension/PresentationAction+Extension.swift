//
//  PresentationAction+Extension.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import Foundation

extension PresentationAction {
    var presented: Action? {
        switch self {
        case .dismiss:
            return nil
        case .presented(let action):
            return action
        }
    }
}
