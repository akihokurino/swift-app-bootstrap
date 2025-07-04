//
//  Util.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

import Foundation
import UIKit

@MainActor
func windowWidth() -> CGFloat {
    let scenes = UIApplication.shared.connectedScenes
    if let windowScene = scenes.first as? UIWindowScene, let window = windowScene.windows.first {
        return window.frame.width
    }
    return UIScreen.main.bounds.size.width
}

@MainActor
func windowHeight() -> CGFloat {
    let scenes = UIApplication.shared.connectedScenes
    if let windowScene = scenes.first as? UIWindowScene, let window = windowScene.windows.first {
        return window.frame.height
    }
    return UIScreen.main.bounds.size.height
}
