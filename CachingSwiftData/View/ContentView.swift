//
//  ContentView.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(GithubViewModel.self) private var viewModel
    @Binding var navigationPath: [NavigationPath]
    
    var body: some View {
        AsyncContentView(viewState: viewModel.viewState) {
            List {
                ForEach(viewModel.users) { user in
                    UserRow(user: user, navigationPath: $navigationPath)
                }
            }.navigationTitle("Following")
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    await viewModel.refresh()
                }
        } onRetry: {
            Task {
                await viewModel.load()
            }
        }.task {
            await viewModel.load()
        }
    }
    
    private struct Constants {
        static let gridItemSize: Double = 180
    }
}

#Preview {
    @State var navigationPath = [NavigationPath]()
    let networkService = NetworkService()
    let modelContainer = try! ModelContainer(for: UserEntity.self)
    let modelContext = modelContainer.mainContext
    let repository = UserRepositoryImpl(networkService: networkService, modelContext: modelContext)
    let viewModel = GithubViewModel(repository: repository)
    return ContentView(navigationPath: $navigationPath).environment(viewModel)
}
