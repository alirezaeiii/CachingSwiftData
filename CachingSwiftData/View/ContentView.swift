//
//  ContentView.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: GithubViewModel
    @Binding var navigationPath: [NavigationPath]
    
    var body: some View {
        AsyncContentView(viewState: viewModel.viewState) {
            List {
                ForEach(viewModel.users) { user in
                    UserRow(user: user, navigationPath: $navigationPath)
                }
            }.navigationTitle("Following")
                .navigationBarTitleDisplayMode(.inline)
        } onRetry: {
            viewModel.refresh()
        }
    }
    
    private struct Constants {
        static let gridItemSize: Double = 180
    }
}

#Preview {
    let networkService = NetworkService()
    let viewModel = GithubViewModel(networkService: networkService)
    @State var navigationPath = [NavigationPath]()
    return ContentView(viewModel: viewModel, navigationPath: $navigationPath)
}
