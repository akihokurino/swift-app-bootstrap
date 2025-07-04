//
//  SettingView.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import SwiftUI

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
    }
}

extension SettingView {
    struct ContentView: View {
        @Bindable var store: StoreOf<SettingReducer>

        var body: some View {
            Text("username: \(store.userInfo?.me.name ?? "N/A")")
        }
    }
}
