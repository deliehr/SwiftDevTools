//
//  UIScreen.swift
//  mijo
//
//  Created by Dominik Liehr on 18.06.24.
//

import Foundation
import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
