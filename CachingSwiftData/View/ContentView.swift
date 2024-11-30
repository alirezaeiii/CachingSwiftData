//
//  ContentView.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftUI
import SwiftData

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
    @State var navigationPath = [NavigationPath]()
    let networkService = NetworkService()
    let dataSource = UserDataSource(networkService: networkService)
    let viewModel = GithubViewModel(dataSource: dataSource)
    return ContentView(viewModel: viewModel, navigationPath: $navigationPath)
}
