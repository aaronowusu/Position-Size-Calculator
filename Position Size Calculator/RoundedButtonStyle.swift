//
//  RoundedButtonStyle.swift
//  Position Size Calculator
//
//  Created by Aaron  Owusu on 04/07/2021.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle{
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(width: CGFloat? = nil, height: CGFloat? = 60){
         self.width = width
         self.height = height
         }
    func makeBody(configuration: Configuration) -> some View {
        RoundedButton(configuration: configuration)
            .frame(width: width, height: height)
    }
}

struct RoundedButton: View {
    let configuration: ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    
    var backgroundColor: Color {
        if !isEnabled{
            return Color.white
        }
        if configuration.isPressed{
            return Color.blue
        }
        return Color.white
    }
    
    var borderColor: Color {
        if !isEnabled{
            return Color.white
        }
        if configuration.isPressed{
            return Color.blue
        }
        return Color.white
    }
    
    var labelColor: Color {
        if !isEnabled{
            return Color.gray
        }
        if configuration.isPressed{
            return Color.blue
        }
        return Color.white
    }

    var body: some View{
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(borderColor)
        configuration.label
            .foregroundColor(labelColor)
            .font(.body)
        
        
    }
    
}
