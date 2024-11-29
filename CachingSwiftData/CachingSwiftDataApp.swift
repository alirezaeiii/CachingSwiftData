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
    private let dataSource = ItemDataSource(modelContainer: try! ModelContainer(for: UserEntity.self))
    @State private var navigationPaths = [NavigationPath]()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPaths) {
                ContentView(viewModel: .init(networkService: networkService, dataSource: dataSource), navigationPath: $navigationPaths)
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .list:
                            ContentView(viewModel: .init(networkService: networkService, dataSource: dataSource), navigationPath: $navigationPaths)
                        case .detail(user:  let user):
                            DetailView(user: user)
                        }
                    }
            }
        }
    }
}
