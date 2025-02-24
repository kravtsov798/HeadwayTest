//
//  SummaryReader.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import ComposableArchitecture
import SwiftUI

struct SummaryReader: View {
    var store: StoreOf<SummaryReaderFeature>
    
    @State private var scrollProxy: ScrollViewProxy?
    private let topId = "Top"
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                VStack(spacing: 15) {
                    title.id(topId)
                    text
                    bottomControls
                        .padding(.top, 25)
                        .padding(.bottom, 60)
                }
                .padding(15)
            }
            .onAppear {
                scrollProxy = reader
            }
            .simultaneousGesture(
                DragGesture().onChanged {
                    let isScrollDown = 0 > $0.translation.height
                    store.send(.output(.scrollDirectionChanged(isScrollDown ? .down : .up)))
                }
            )
        }
    }
    
    private var title: some View {
        Text(store.title)
            .frame(maxWidth: .infinity ,alignment: .leading)
            .font(.system(.title2, design: .serif, weight: .bold))
            .foregroundColor(.Font.primary)
    }
    
    private var text: some View {
        Text(store.text)
            .fontDesign(.serif)
            .multilineTextAlignment(.leading)
            .foregroundColor(.Font.primary)
    }
    
    private var bottomControls: some View {
        HStack(spacing: 35) {
            backwardButton
            pageControlTitle
            forwardButton
        }
    }
    
    private var pageControlTitle: some View {
        Text(store.pageControlTitle)
            .font(.callout)
            .foregroundStyle(Color.Font.primary)
    }
    
    private var backwardButton: some View {
        DirectionButton(direction: .backward, size: 44) {
            scrollProxy?.scrollTo(topId)
            store.send(.view(.backwardTapped))
        }
        .opacity(store.showPrevButton ? 1 : 0)
    }
    
    private var forwardButton: some View {
        DirectionButton(direction: .forward, size: 44) {
            scrollProxy?.scrollTo(topId)
            store.send(.view(.forwardTapped))
        }
        .opacity(store.showNextButton ? 1 : 0)
    }
}

#Preview {
    SummaryReader(store: Store(initialState: SummaryReaderFeature.State()) {
        SummaryReaderFeature()
    })
}
