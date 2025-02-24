//
//  SummaryToggle.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import SwiftUI

struct SummaryToggle: View {
    let showPlayer: Bool
    
    var body: some View {
        ZStack {
            background
                .overlay(border)
            content
        }
        .frame(width: 110, height: 55)
    }
    
    private var background: some View {
        Color(.Background.toggle).clipShape(Capsule())
    }
    
    private var border: some View {
        Capsule()
            .stroke(lineWidth: 1)
            .foregroundStyle(Color.Border.toggle)
    }
    
    private var content: some View {
        ZStack(alignment: showPlayer ? .trailing : .leading) {
            thumb
            images
        }
    }
    
    private var thumb: some View {
        Circle()
            .fill(Color.Primary.blue)
            .padding(4)
    }
    
    private var images: some View {
        HStack(spacing: 0) {
            Group {
                reader
                player
            }
            .scaledToFit()
            .padding(19)
            .fontWeight(.heavy)
        }
    }
    
    private var player: some View {
        Image(systemName: "headphones")
            .resizable()
            .foregroundStyle(showPlayer
                             ? Color.Foreground.toggleItemSelected
                             : Color.Foreground.toggleItem)
    }
    
    private var reader: some View {
        Image(systemName: "text.alignleft")
            .resizable()
            .foregroundStyle(showPlayer
                             ? Color.Foreground.toggleItem
                             : Color.Foreground.toggleItemSelected)
    }
}
