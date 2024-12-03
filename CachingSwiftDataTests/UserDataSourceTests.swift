//
//  CachingSwiftDataTests.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/2/24.
//

import XCTest
@testable import CachingSwiftData

final class UserDataSourceTests: XCTestCase {
    var mockModelContext: MockModelContext!
    var mockNetworkService: MockNetworkService!
    var repository: UserRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        mockModelContext = MockModelContext()
        mockNetworkService = MockNetworkService()
        repository = UserRepositoryImpl(networkService: mockNetworkService, modelContext: mockModelContext)
    }
    
    override func tearDown() {
        mockModelContext = nil
        mockNetworkService = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchUsers() throws {
        mockModelContext.storage = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
        
        let users = repository.fetch()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.login, "testUser")
        XCTAssertEqual(users.first?.avatarUrl, "https://example.com/avatar.png")
    }
    
    func testFetchEmptyUsers() throws {
        mockModelContext.storage = []
        
        let users = repository.fetch()
        
        XCTAssertTrue(users.isEmpty)
    }
    
    func testAppend() throws {
        let userEntity = UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")
        
        try repository.append(user: userEntity)
        let users = repository.fetch()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.login, "testUser")
        XCTAssertEqual(users.first?.avatarUrl, "https://example.com/avatar.png")
    }
    
    func testDeleteAll() throws {
        mockModelContext.storage = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
        
        try repository.deleteAll()
        let users = repository.fetch()
        
        XCTAssertTrue(users.isEmpty)
    }
    
    func testUpdateUsers() async throws {
        let mockUserDTO = UserDTO(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")
        let mockData = try JSONEncoder().encode([mockUserDTO])
        mockNetworkService.mockData = mockData
        
        try await repository.update()
        let users = repository.fetch()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.login, "testUser")
        XCTAssertEqual(users.first?.avatarUrl, "https://example.com/avatar.png")
    }
    
    func testUpdateNetworkFailure() async {
        mockNetworkService.mockError = NSError(domain: "TestError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
        do {
            try await repository.update()
        } catch {
            XCTAssertEqual(error.localizedDescription, "Bad Request")
        }
    }
    
    func testUpdateDecodingError() async {
        mockNetworkService.mockData = Data("Invalid JSON".utf8) // Invalid JSON
        do {
            try await repository.update()
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
