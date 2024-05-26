//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import SwiftUI

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
