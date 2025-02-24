//
//  SummaryReaderFeature.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import ComposableArchitecture

enum ScrollDirection {
    case up, down
}

@Reducer
struct SummaryReaderFeature {
    @Dependency(\.summaryDataSource)
    private var dataSource
    
    @ObservableState
    struct State: Equatable {
        static let initial = Self()
        
        var title: String = ""
        var text: String = ""
        var pageControlTitle: String = ""
        
        var showBottomControls = false
        var showPrevButton = false
        var showNextButton = false
    }
    
    enum Action {
        case view(View)
        case input(Input)
        case output(Output)
        
        enum View {
            case forwardTapped
            case backwardTapped
            case newKeyPointSelected
        }
        
        enum Input {
            case dataSourceUpdated
        }
        
        enum Output {
            case dataSourceUpdated
            case scrollDirectionChanged(ScrollDirection)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action): handle(view: action, state: &state)
            case .input(let action): handle(input: action, state: &state)
            case .output: .none
            }
        }
    }
    
    private func handle(view action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .backwardTapped:
            dataSource.moveToPrev()
            return .send(.view(.newKeyPointSelected))
            
        case .forwardTapped:
            dataSource.moveToNext()
            return .send(.view(.newKeyPointSelected))
            
        case .newKeyPointSelected:
            update(state: &state)
            return .send(.output(.dataSourceUpdated))
        }
    }
    
    private func handle(input action: Action.Input, state: inout State) -> Effect<Action> {
        switch action {
        case .dataSourceUpdated:
            update(state: &state)
            return .none
        }
    }
    
    private func update(state: inout State) {
        guard let currentKeyPoint = dataSource.currentKeyPoint else { return }
        state.title = currentKeyPoint.title
        state.text = currentKeyPoint.text
        
        state.showBottomControls = dataSource.keyPointsCount > 1
        state.showNextButton = !dataSource.isLastKeyPoint
        state.showPrevButton = !dataSource.isFirstKeyPoint
        
        guard let currentKeyPointNumber = dataSource.currentKeyPointNumber else { return }
        state.pageControlTitle = String(
            format: Localized.currentKeyPoint,
            currentKeyPointNumber,
            dataSource.keyPointsCount
        )
    }
}

extension SummaryReaderFeature {
    enum Localized {
        static let currentKeyPoint = String(localized: "CurrentPlayItemOfTotalShort")
    }
}
