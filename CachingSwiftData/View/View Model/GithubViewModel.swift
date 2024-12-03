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
    private let dataSource: UserRepository
    
    var viewState: ViewState = .loading
    var users: [UserEntity] = []
    
    init(dataSource: UserRepository) {
        self.dataSource = dataSource
    }
    
    @MainActor
    func load() async {
        self.viewState = .loading
        let userEntities = dataSource.fetch()
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
        try await dataSource.update()
        self.users = dataSource.fetch()
        self.viewState = .completed
    }
}
