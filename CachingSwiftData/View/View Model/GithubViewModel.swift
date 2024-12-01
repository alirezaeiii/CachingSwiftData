//
//  GithubViewModel.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

class GithubViewModel: ObservableObject {
    private let dataSource: UserDataSourceProtocol
    
    @Published var viewState: ViewState = .loading
    @Published var users: [UserEntity] = []
    
    init(dataSource: UserDataSourceProtocol) {
        self.dataSource = dataSource
        load()
    }
    
    func load() {
        self.viewState = .loading
        let userEntities = dataSource.fetch()
        Task { @MainActor in
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
        let updatedUsers = try await dataSource.update()
        self.users = updatedUsers
        self.viewState = .completed
    }
}
