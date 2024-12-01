//
//  UserDataSource.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation
import SwiftData

protocol UserDataSourceProtocol {
    func fetch() -> [UserEntity]
    func update() async throws -> [UserEntity]
}

class UserDataSource: UserDataSourceProtocol {
    private let modelContext: ModelContext
    private let networkService: NetworkService
    
    init(networkService: NetworkService, modelContext: ModelContext) {
        self.modelContext = modelContext
        self.networkService = networkService
    }
    
    func fetch() -> [UserEntity] {
        do {
            return try modelContext.fetch(FetchDescriptor<UserEntity>())
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func append(user: UserEntity) throws {
        modelContext.insert(user)
        try modelContext.save()
        
    }
    
    private func deleteAll() throws {
        try modelContext.delete(model: UserEntity.self)
    }
    
    func update() async throws -> [UserEntity] {
        let followingRequest = GithubRequest(path: .following)
        let users: [UserDTO] = try await networkService.perform(request: followingRequest)
        try deleteAll()
        for user in users {
            let userEntity = UserEntity(from: user)
            try append(user: userEntity)
        }
        return fetch()
    }
}
