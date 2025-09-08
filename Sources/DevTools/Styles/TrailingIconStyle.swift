//
//  TrailingIconStyle.swift
//  DevTools
//
//  Created by Dominik Liehr on 08.09.25.
//

import SwiftUI

@available(iOS 14, OSX 11, *)
struct TrailingIconStyle: LabelStyle {
    func makeBody(configuration: LabelStyleConfiguration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

@available(iOS 14, OSX 11, *)
extension LabelStyle where Self == TrailingIconStyle {
    static var trailingIcon: TrailingIconStyle {
        TrailingIconStyle()
    }
}
