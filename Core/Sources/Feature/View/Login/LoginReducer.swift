//
//  LoginReducer.swift
//  Core
//
//  Created by akiho on 2025/07/05.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LoginReducer {
    @Reducer
    enum Destination {}

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var isInitialized = false
        var alert: AlertEntity?
        var isPresentedHUD = false
        var isPresentedAlert = false

        var email: String = ""
        var password: String = ""
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case initialize
        case setAlert(AlertEntity)
        case isPresentedHUD(Bool)
        case isPresentedAlert(Bool)

        case setEmail(String)
        case setPassword(String)
        case login
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            // ----------------------------------------------------------------
            // common
            // ----------------------------------------------------------------
            case .destination(let action):
                guard let action = action.presented else {
                    return .none
                }
                switch action {
                default:
                    return .none
                }
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
            //
            // ----------------------------------------------------------------
            case .setEmail(let val):
                state.email = val
                return .none
            case .setPassword(let val):
                state.password = val
                return .none
            case .login:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension LoginReducer.Destination.State: Equatable {}
