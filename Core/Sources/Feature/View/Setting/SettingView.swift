//
//  SettingView.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct SettingReducer {
    @Reducer
    enum Destination {}

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var isInitialized = false
        var alert: AlertEntity?
        var isPresentedHUD = false
        var isPresentedAlert = false

        @Shared(.inMemory("sharedUserInfo")) var userInfo: UserInfo?
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case initialize
        case setAlert(AlertEntity)
        case isPresentedHUD(Bool)
        case isPresentedAlert(Bool)
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
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension SettingReducer.Destination.State: Equatable {}

struct SettingView: View {
    @Bindable var store: StoreOf<SettingReducer>

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
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension SettingView {
    struct ContentView: View {
        @Bindable var store: StoreOf<SettingReducer>

        var body: some View {
            Text("login user id: \(store.userInfo?.me.id ?? "")")
        }
    }
}

extension SettingView {
    struct NavigationModifier: ViewModifier {
        @Bindable var store: StoreOf<SettingReducer>

        func body(content: Content) -> some View {
            content
        }
    }
}
