//
//  RootView.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct RootReducer {
    @Dependency(\.gqlClient) var gqlClient

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
        var tabSelection: Tab = .home
        var appMode: AppMode = .loading
        var login: LoginReducer.State?
        var home: HomeReducer.State?
        var setting: SettingReducer.State?
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case initialize
        case setAlert(AlertEntity)
        case isPresentedHUD(Bool)
        case isPresentedAlert(Bool)

        case setMe(Me)
        case setTabSelection(Tab)
        case login(LoginReducer.Action)
        case home(HomeReducer.Action)
        case setting(SettingReducer.Action)
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
                state.appMode = .login
                state.login = LoginReducer.State()
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
            case .setMe(let val):
                state.$userInfo.withLock {
                    $0 = UserInfo(me: val)
                }
                return .none
            case .setTabSelection(let val):
                state.tabSelection = val
                return .none
            case .login(let action):
                switch action {
                case .login:
                    state.login = nil
                    state.home = HomeReducer.State()
                    state.setting = SettingReducer.State()
                    state.appMode = .running
                    return .run { send in
                        do {
                            let me = try (await gqlClient.query(API.GetMeQuery())).me.fragments.meFragment
                            await send(.setMe(me))
                        } catch {
                            await send(.setAlert(AlertEntity.from(error: error)))
                        }
                        await send(.isPresentedHUD(false))
                    }
                default:
                    return .none
                }
            case .home(let action):
                switch action {
                default:
                    return .none
                }
            case .setting(let action):
                switch action {
                default:
                    return .none
                }
            }
        }
        .ifLet(\.login, action: \.login) {
            LoginReducer()
        }
        .ifLet(\.home, action: \.home) {
            HomeReducer()
        }
        .ifLet(\.setting, action: \.setting) {
            SettingReducer()
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension RootReducer.Destination.State: Equatable {}

extension RootReducer {
    enum Tab: Equatable {
        case home
        case setting
    }

    enum AppMode: Equatable {
        case loading
        case login
        case running
    }
}

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
