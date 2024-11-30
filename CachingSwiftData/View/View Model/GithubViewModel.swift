//
//  GithubViewModel.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

class GithubViewModel: ObservableObject {
    private let dataSource: UserDataSource
    
    @Published var viewState: ViewState = .loading
    @Published var users: [UserEntity] = []
    
    init(dataSource: UserDataSource) {
        self.dataSource = dataSource
        refresh()
    }
    
    func refresh() {
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
                do {
                    try await update()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func update() async throws {
        try await dataSource.update()
        self.users = dataSource.fetch()
        self.viewState = .completed
    }
}
