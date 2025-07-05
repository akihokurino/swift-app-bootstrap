//
//  RootView.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    @Bindable var store: StoreOf<RootReducer>

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

extension RootView {
    struct ContentView: View {
        @Bindable var store: StoreOf<RootReducer>

        var body: some View {
            Group {
                switch store.appMode {
                case .loading:
                    Group {}
                case .login:
                    NavigationStack {
                        if let embeded = store.scope(state: \.login, action: \.login) {
                            LoginView(store: embeded)
                        }
                    }
                case .running:
                    TabView(selection: $store.tabSelection.sending(\.setTabSelection)) {
                        NavigationStack {
                            if let embeded = store.scope(state: \.home, action: \.home) {
                                HomeView(store: embeded)
                            }
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                    .resizable()
                                    .frame(width: 24, height: 24, alignment: .center)
                                Text("Home")
                            }
                        }.tag(RootReducer.Tab.home)

                        NavigationStack {
                            if let embeded = store.scope(state: \.setting, action: \.setting) {
                                SettingView(store: embeded)
                            }
                        }
                        .tabItem {
                            VStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24, alignment: .center)
                                Text("Setting")
                            }
                        }.tag(RootReducer.Tab.setting)
                    }
                }
            }
        }
    }
}
