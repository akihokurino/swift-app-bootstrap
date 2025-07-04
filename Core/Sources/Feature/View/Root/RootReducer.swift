//
//  RootReducer.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import Foundation

@Reducer
struct RootReducer {
    @Dependency(\.gqlClient) var gqlClient

    @Reducer
    enum Destination {}

    @ObservableState
    struct State: Equatable {
        var isInitialized = false
        var alert: AlertEntity?
        var isPresentedHUD = false
        var isPresentedAlert = false

        @Shared(.inMemory("sharedUserInfo")) var userInfo: UserInfo?
        var tabSelection: Tab = .home

        var home: HomeReducer.State? = HomeReducer.State()
        var setting: SettingReducer.State? = SettingReducer.State()
        @Presents var destination: Destination.State?
    }

    enum Action {
        case initialize
        case setAlert(AlertEntity)
        case isPresentedHUD(Bool)
        case isPresentedAlert(Bool)

        case setMe(Me)
        case setTabSelection(Tab)

        case home(HomeReducer.Action)
        case setting(SettingReducer.Action)
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
                state.isPresentedHUD = true

                return .run { send in
                    do {
                        let me = try (await gqlClient.query(API.GetMeQuery())).me.fragments.meFragment
                        await send(.setMe(me))
                    } catch {
                        await send(.setAlert(AlertEntity.from(error: error)))
                    }
                    await send(.isPresentedHUD(false))
                }
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
            case .setMe(let val):
                state.$userInfo.withLock {
                    $0 = UserInfo(me: val)
                }
                return .none
            case .setTabSelection(let val):
                state.tabSelection = val
                return .none
            // ----------------------------------------------------------------
            // embed + destination
            // ----------------------------------------------------------------
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
}
