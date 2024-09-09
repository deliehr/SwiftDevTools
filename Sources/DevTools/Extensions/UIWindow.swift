//
//  UIWindow.swift
//  mijo
//
//  Created by Dominik Liehr on 18.06.24.
//

#if os(iOS)

import Foundation
import UIKit

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

#endif
