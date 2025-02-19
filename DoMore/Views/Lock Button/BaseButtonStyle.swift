//
//  BaseButtonStyle.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/13/25.
//

import SwiftUI

public struct BaseButtonStyle: ButtonStyle {

    public init() { }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.default, value: configuration.isPressed)
    }

}

