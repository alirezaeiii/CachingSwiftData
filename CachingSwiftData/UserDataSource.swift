//
//  ItemDataSource.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation
import SwiftData

class UserDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private let networkService: NetworkService
    
    @MainActor
    init(networkService: NetworkService) {
        self.modelContainer = try! ModelContainer(for: UserEntity.self)
        self.modelContext = modelContainer.mainContext
        self.networkService = networkService
    }
    
    func fetch() -> [UserEntity] {
        do {
            return try modelContext.fetch(FetchDescriptor<UserEntity>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func append(user: UserEntity) {
        modelContext.insert(user)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func deleteAll() {
        do {
            try modelContext.delete(model: UserEntity.self)
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func update() async throws {
        let followingRequest = GithubRequest(path: .following)
        let users: [UserDTO] = try await networkService.perform(request: followingRequest)
        deleteAll()
        for user in users {
            let userEntity = UserEntity(from: user)
            append(user: userEntity)
        }
    }
}
