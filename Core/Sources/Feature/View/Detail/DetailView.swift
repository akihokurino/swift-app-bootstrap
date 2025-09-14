//
//  DetailView.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct DetailReducer {
    @Dependency(\.dismiss) var dismiss

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

        case dismiss
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
            case .dismiss:
                return .run { _ in
                    await dismiss()
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension DetailReducer.Destination.State: Equatable {}

struct DetailView: View {
    @Bindable var store: StoreOf<DetailReducer>

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
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Group {
                Button(action: {
                    store.send(.dismiss)
                }) {
                    Image(systemName: "chevron.backward")
                }
            })
    }
}

extension DetailView {
    struct ContentView: View {
        @Bindable var store: StoreOf<DetailReducer>

        var body: some View {}
    }
}

extension DetailView {
    struct NavigationModifier: ViewModifier {
        @Bindable var store: StoreOf<DetailReducer>

        func body(content: Content) -> some View {
            content
        }
    }
}
