//
//  CachingSwiftDataApp.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftUI
import SwiftData

enum NavigationPath: Hashable {
    case list
    case detail(user: UserEntity)
}

@main
struct CachingSwiftDataApp: App {
    
    private let networkService = NetworkService()
    private let modelContainer = try! ModelContainer(for: UserEntity.self)
    @State private var navigationPaths = [NavigationPath]()
    @State private var viewModel: GithubViewModel
    
    init() {
        let repository = UserRepositoryImpl(networkService: networkService, modelContext: modelContainer.mainContext)
        viewModel = GithubViewModel(repository: repository)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPaths) {
                ContentView(navigationPath: $navigationPaths).environment(viewModel)
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .list:
                            ContentView(navigationPath: $navigationPaths).environment(viewModel)
                        case .detail(user:  let user):
                            DetailView(user: user)
                        }
                    }
            }
        }
    }
}
