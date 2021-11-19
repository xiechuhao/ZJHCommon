//
//  CALayer-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
import Foundation
#endif

// =============================================================================
// MARK: - ClassMethods
// =============================================================================

extension CALayer {
    /// Create a `CALayer` and set the background color.
    convenience public init(bgColor: UIColor?) {
        self.init()
        self.backgroundColor = bgColor?.cgColor
    }
}
