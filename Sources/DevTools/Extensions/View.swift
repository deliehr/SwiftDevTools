//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import SwiftUI

@available(OSX 10.15, *)
public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
