//
//  GithubViewModel.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

@Observable
class GithubViewModel {
    @ObservationIgnored
    private let repository: UserRepository
    
    var viewState: ViewState = .loading
    var users: [UserEntity] = []
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    @MainActor
    func load() async {
        self.viewState = .loading
        let userEntities = repository.fetch()
        if(userEntities.isEmpty) {
            do {
                try await update()
            } catch {
                self.viewState = .failure(error: error)
            }
        } else {
            self.users = userEntities
            self.viewState = .completed
            await refresh()
        }
    }
    
    func refresh() async {
        do {
            try await update()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func update() async throws {
        try await repository.update()
        self.users = repository.fetch()
        self.viewState = .completed
    }
}
