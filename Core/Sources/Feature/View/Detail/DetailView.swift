//
//  DetailView.swift
//  Core
//
//  Created by akiho on 2025/07/04.
//

import ComposableArchitecture
import SwiftUI

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
    }
}

extension DetailView {
    struct ContentView: View {
        @Bindable var store: StoreOf<DetailReducer>

        var body: some View {
            Button("Detail") {
                store.send(.dismiss)
            }
        }
    }
}
