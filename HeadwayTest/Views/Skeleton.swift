//
//  Skeleton.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import SwiftUI

struct Skeleton: View {
    @State var startPoint: UnitPoint = .topLeading
    @State var endPoint: UnitPoint = .bottomTrailing
    var cornerRadius: CGFloat = 0
    
    var gradient: [Color] = [
        .clear,
        .Primary.white,
        .clear
    ]
    
    private var gradientFill: LinearGradient {
        LinearGradient(gradient: Gradient(colors: gradient),
                       startPoint: startPoint,
                       endPoint: endPoint)
    }
    
    var body: some View {
        ZStack {
            Color.Foreground.skeleton
            gradientFill
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                startPoint = .center
            }
        }
    }
}

#Preview {
    Skeleton()
}
