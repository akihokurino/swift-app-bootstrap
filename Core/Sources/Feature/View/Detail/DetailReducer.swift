//
//  DetailReducer.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DetailReducer {
    @Dependency(\.dismiss) var dismiss

    @Reducer
    enum Destination {}

    @ObservableState
    struct State: Equatable {
        var isInitialized = false
        var alert: AlertEntity?
        var isPresentedHUD = false
        var isPresentedAlert = false

        @Shared(.inMemory("sharedUserInfo")) var userInfo: UserInfo?

        @Presents var destination: Destination.State?
    }

    enum Action {
        case initialize
        case setAlert(AlertEntity)
        case isPresentedHUD(Bool)
        case isPresentedAlert(Bool)

        case dismiss

        case destination(PresentationAction<Destination.Action>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            // ----------------------------------------------------------------
            // common
            // ----------------------------------------------------------------
            case .initialize:
                guard !state.isInitialized else {
                    return .none
                }
                state.isInitialized = true
                return .none
            case .setAlert(let entity):
                state.alert = entity
                state.isPresentedAlert = true
                return .none
            case .isPresentedHUD(let val):
                state.isPresentedHUD = val
                return .none
            case .isPresentedAlert(let val):
                state.isPresentedAlert = val
                return .none
            // ----------------------------------------------------------------
            // action
            // ----------------------------------------------------------------
            case .dismiss:
                return .run { _ in
                    await dismiss()
                }
            // ----------------------------------------------------------------
            // embed + destination
            // ----------------------------------------------------------------
            case .destination(let action):
                guard let action = action.presented else {
                    return .none
                }
                switch action {
                default:
                    return .none
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension DetailReducer.Destination.State: Equatable {}
