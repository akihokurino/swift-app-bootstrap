//
//  HomeView.swift
//  Core
//
//  Created by akiho on 2025/07/02.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>

    var body: some View {
        ContentView(store: store)
            .onAppear {
                store.send(.initialize)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Home")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    store.send(.presentDetailView)
                }) { Image(systemName: "square.and.pencil") }
            })
            .modifier(NavigationModifier(store: store))
            .modifier(HUDModifier(isPresented: $store.isPresentedHUD.sending(\.isPresentedHUD)))
            .modifier(AlertModifier(entity: store.alert, onTap: {
                store.send(.isPresentedAlert(false))
            }, isPresented: $store.isPresentedAlert.sending(\.isPresentedAlert)))
    }
}

extension HomeView {
    struct ContentView: View {
        @Bindable var store: StoreOf<HomeReducer>

        var body: some View {
            PagingListView<User>(
                listRowSeparator: .hidden,
                itemView: { user in
                    AnyView(Text("id: \(user.id) name: \(user.name)"))
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
