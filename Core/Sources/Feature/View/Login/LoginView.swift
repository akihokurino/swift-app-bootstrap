//
//  LoginView.swift
//  Core
//
//  Created by akiho on 2025/07/05.
//

import ComposableArchitecture
import SwiftUI

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
