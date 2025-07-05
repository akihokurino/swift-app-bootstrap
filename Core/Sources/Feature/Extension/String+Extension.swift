//
//  String+Extension.swift
//  Core
//
//  Created by akiho on 2025/07/05.
//

import Foundation
import UIKit

extension String {
    var url: URL? {
        return URL(string: self)
    }

    var isRealEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
