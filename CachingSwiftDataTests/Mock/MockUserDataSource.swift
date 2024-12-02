//
//  MockUserDataSource.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/2/24.
//

import Foundation
@testable import CachingSwiftData

class MockUserDataSource: UserDataSourceProtocol {
    var mockUsers: [UserEntity] = []
    var shouldThrowError = false
    
    func append(user: UserEntity) throws {
        mockUsers.append(user)
    }
    
    func fetch() -> [UserEntity] {
        return mockUsers
    }
    
    func update() async throws {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        mockUsers = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
    }
}
