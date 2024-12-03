//
//  UserDataSource.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation
import SwiftData

protocol UserDataSourceProtocol {
    func append(user: UserEntity) throws
    func fetch() -> [UserEntity]
    func update() async throws
}

class UserDataSource: UserDataSourceProtocol {
    private let modelContext: ModelContextProtocol
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol, modelContext: ModelContextProtocol) {
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
    
    func append(user: UserEntity) throws {
        modelContext.insert(user)
        try modelContext.save()
    }
    
    func deleteAll() throws {
        try modelContext.deleteAll(model: UserEntity.self)
    }
    
    func update() async throws {
        let followingRequest = GithubRequest(path: .following)
        let users: [UserDTO] = try await networkService.perform(request: followingRequest)
        try deleteAll()
        for user in users {
            let userEntity = UserEntity(from: user)
            try append(user: userEntity)
        }
    }
}
