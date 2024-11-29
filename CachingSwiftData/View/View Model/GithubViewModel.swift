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
    
    init(networkService: NetworkService, dataSource: ItemDataSource) {
        self.networkService = networkService
        self.dataSource = dataSource
        refresh()
    }
    
    func refresh() {
        self.viewState = .loading
        Task { @MainActor in
            let userEntities = await dataSource.fetch()
            if(userEntities.isEmpty) {
                do {
                    try await update()
                } catch {
                    self.viewState = .failure(error: error)
                }
            } else {
                self.users = await dataSource.fetch()
                self.viewState = .completed
                do {
                    try await update()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @MainActor
    private func update() async throws {
        let followingRequest = GithubRequest(path: .following)
        let users: [UserDTO] = try await networkService.perform(request: followingRequest)
        await dataSource.delete()
        for user in users {
            let userEntity = UserEntity(from: user)
            await dataSource.append(user: userEntity)
        }
        self.users = await dataSource.fetch()
        self.viewState = .completed
    }
}
