//
//  TrailingIconStyle.swift
//  DevTools
//
//  Created by Dominik Liehr on 08.09.25.
//

import SwiftUI

@available(iOS 14, OSX 11, *)
public struct TrailingIconStyle: LabelStyle {
    public func makeBody(configuration: LabelStyleConfiguration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

@available(iOS 14, OSX 11, *)
public extension LabelStyle where Self == TrailingIconStyle {
    static var trailingIcon: TrailingIconStyle {
        TrailingIconStyle()
    }
}
