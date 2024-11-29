//
//  GithubViewModel.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

class GithubViewModel: ObservableObject {
    private let dataSource: ItemDataSource
    private let networkService: NetworkService
    
    @Published var viewState: ViewState = .loading
    @Published var users: [UserEntity] = []
    
    init(networkService: NetworkService, dataSource: ItemDataSource = ItemDataSource.shared) {
        self.dataSource = dataSource
        self.networkService = networkService
        refresh()
    }
    
    func refresh() {
        self.viewState = .loading
        let userEntities = dataSource.fetch()
        Task { @MainActor in
            if(userEntities.isEmpty) {
                do {
                    try await fetch()
                } catch {
                    self.viewState = .failure(error: error)
                }
            } else {
                self.users = dataSource.fetch()
                self.viewState = .completed
                do {
                    try await fetch()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func fetch() async throws {
        let followingRequest = GithubRequest(path: .following)
        let users: [UserDTO] = try await networkService.perform(request: followingRequest)
        dataSource.delete()
        for user in users {
            let userEntity = UserEntity(from: user)
            dataSource.append(user: userEntity)
        }
        self.users = dataSource.fetch()
        self.viewState = .completed
    }
}
