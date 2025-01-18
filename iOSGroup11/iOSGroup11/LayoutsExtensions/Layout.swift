//
//  Layout.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-11.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 130)
            .padding()
            .background(.gray.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 2)
            )
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SmallerButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(height: 35)
            .background(.white.opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.8), lineWidth: 2)
            )
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SmallerButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View{
        Button(action: action){
            Text(title)
        }
        .buttonStyle(SmallerButtonStyle())
    }
}

struct CommonButton: View{
    var title: String
    var action: () -> Void
    
    var body: some View{
        Button(action: action){
            Text(title)
                .bold()
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct GeneralButtonGreen: ViewModifier{
    func body(content: Content) -> some View{
        content
            .frame(width: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .background(.green.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green.opacity(0.9), lineWidth: 2)
            )
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View{
    func buttonCommonGreen() -> some View {
        self.modifier(GeneralButtonGreen())
    }
}

struct GeneralButton: ViewModifier{
    func body(content: Content) -> some View{
        content
            .padding()
            .background(.white.opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green.opacity(0.9), lineWidth: 2)
            )
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
    }
}

extension View{
    func buttonCommonStyle() -> some View {
        self.modifier(GeneralButton())
    }
}
