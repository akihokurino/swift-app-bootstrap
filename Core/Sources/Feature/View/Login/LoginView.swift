//
//  LoginView.swift
//  Core
//
//  Created by akiho on 2025/07/05.
//

import ComposableArchitecture
import Foundation
import SwiftUI

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

struct LoginView: View {
    @Bindable var store: StoreOf<LoginReducer>

    var body: some View {
        ContentView(store: store)
            .onAppear {
                store.send(.initialize)
            }
            .modifier(HUDModifier(isPresented: $store.isPresentedHUD.sending(\.isPresentedHUD)))
            .modifier(AlertModifier(entity: store.alert, onTap: {
                store.send(.isPresentedAlert(false))
            }, isPresented: $store.isPresentedAlert.sending(\.isPresentedAlert)))
            .modifier(NavigationModifier(store: store))
    }
}

extension LoginView {
    struct ContentView: View {
        @Bindable var store: StoreOf<LoginReducer>
        @FocusState private var isTextFieldFocused: Bool

        var body: some View {
            VStack {
                TextFieldView(value: $store.email.sending(\.setEmail), focus: _isTextFieldFocused, placeholder: "Email", keyboardType: .default)
                    .padding(.horizontal, 36)
                    .onAppear {
                        isTextFieldFocused = true
                    }
                Spacer16()

                TextFieldView(value: $store.password.sending(\.setPassword), placeholder: "Password", keyboardType: .default, isPassword: true)
                    .padding(.horizontal, 36)
                Spacer16()

                ActionButtonView(text: "Login", buttonType: .primary) {
                    store.send(.login)
                }.padding(.horizontal, 36)
            }
        }
    }
}

extension LoginView {
    struct NavigationModifier: ViewModifier {
        @Bindable var store: StoreOf<LoginReducer>

        func body(content: Content) -> some View {
            content
        }
    }
}
