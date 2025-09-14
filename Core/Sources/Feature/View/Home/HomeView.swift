//
//  HomeView.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct HomeReducer {
    @Dependency(\.gqlClient) var gqlClient

    @Reducer
    enum Destination {
        case detail(DetailReducer)
    }

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var isInitialized = false
        var alert: AlertEntity?
        var isPresentedHUD = false
        var isPresentedAlert = false

        @Shared(.inMemory("sharedUserInfo")) var userInfo: UserInfo?
        var users: WithCursor<User>?
        var isPresentedNextLoading = false
        var isPresentedPullToRefresh = false
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case initialize
        case setAlert(AlertEntity)
        case isPresentedHUD(Bool)
        case isPresentedAlert(Bool)

        case setUsers(WithCursor<User>)
        case presentDetailView
        case isPresentedNextLoading(Bool)
        case isPresentedPullToRefresh(Bool)
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
                case .detail(let action):
                    switch action {
                    default:
                        return .none
                    }
                }
            case .initialize:
                guard !state.isInitialized else {
                    return .none
                }
                state.isInitialized = true
                state.isPresentedHUD = true

                return .run { send in
                    do {
                        let users = try (await gqlClient.query(API.GetUserListQuery())).users.map { $0.fragments.userFragment }
                        await send(.setUsers(WithCursor.new(limit: 10).next(users, cursor: nil, hasNext: false)))
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
            //
            // ----------------------------------------------------------------
            case .setUsers(let val):
                state.users = val
                return .none
            case .presentDetailView:
                state.destination = .detail(DetailReducer.State())
                return .none
            case .isPresentedNextLoading(let val):
                state.isPresentedNextLoading = val
                return .none
            case .isPresentedPullToRefresh(let val):
                state.isPresentedPullToRefresh = val
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension HomeReducer.Destination.State: Equatable {}

struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>

    var body: some View {
        ContentView(store: store)
            .onAppear {
                store.send(.initialize)
            }
            .modifier(NavigationModifier(store: store))
            .modifier(HUDModifier(isPresented: $store.isPresentedHUD.sending(\.isPresentedHUD)))
            .modifier(AlertModifier(entity: store.alert, onTap: {
                store.send(.isPresentedAlert(false))
            }, isPresented: $store.isPresentedAlert.sending(\.isPresentedAlert)))
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    store.send(.presentDetailView)
                }) { Image(systemName: "square.and.pencil") }
            })
    }
}

extension HomeView {
    struct ContentView: View {
        @Bindable var store: StoreOf<HomeReducer>

        var body: some View {
            PagingListView<User>(
                listRowSeparator: .hidden,
                itemView: { user in
                    AnyView(Text("id: \(user.id)"))
                },
                onTap: { _ in
                },
                onNext: {},
                onRefresh: {},
                data: store.users,
                isLoading: $store.isPresentedNextLoading.sending(\.isPresentedNextLoading),
                isRefreshing: $store.isPresentedPullToRefresh.sending(\.isPresentedPullToRefresh)
            )
            .listStyle(PlainListStyle())
            .listRowSpacing(12)
            .padding(.top, 20)
            .padding(.horizontal, 16)
        }
    }
}

extension HomeView {
    struct NavigationModifier: ViewModifier {
        @Bindable var store: StoreOf<HomeReducer>

        func body(content: Content) -> some View {
            content
                .navigationDestination(
                    item: $store.scope(state: \.destination?.detail, action: \.destination.detail)
                ) { store in
                    DetailView(store: store)
                }
        }
    }
}
