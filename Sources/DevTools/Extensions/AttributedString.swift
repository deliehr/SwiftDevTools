//
//  File.swift
//  
//
//  Created by Dominik Liehr on 28.05.24.
//

import SwiftUI

#if os(iOS)

@available(iOS 15, OSX 12, *)
extension AttributedString {
    static func build(with text: String, boldText: String, font: Font?, uiFont: UIFont?) -> AttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let boldRange = (attributedString.string as NSString).range(of: boldText)

        if let font {
            attributedString.addAttribute(.font, value: font, range: boldRange)
        }

        if let uiFont {
            attributedString.addAttribute(.font, value: uiFont, range: boldRange)
        }

        return AttributedString(attributedString)
    }
}

#endif
