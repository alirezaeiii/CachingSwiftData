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
    var userDataSource: UserDataSource!
    
    override func setUp() {
        super.setUp()
        mockModelContext = MockModelContext()
        mockNetworkService = MockNetworkService()
        userDataSource = UserDataSource(networkService: mockNetworkService, modelContext: mockModelContext)
    }
    
    override func tearDown() {
        mockModelContext = nil
        mockNetworkService = nil
        userDataSource = nil
        super.tearDown()
    }
    
    func testFetchUsers() throws {
        mockModelContext.storage = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
        
        let users = userDataSource.fetch()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.login, "testUser")
        XCTAssertEqual(users.first?.avatarUrl, "https://example.com/avatar.png")
    }
    
    func testFetchEmptyUsers() throws {
        mockModelContext.storage = []
        
        let users = userDataSource.fetch()
        
        XCTAssertTrue(users.isEmpty)
    }
    
    func testAppend() throws {
        let userEntity = UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")
        
        try userDataSource.append(user: userEntity)
        let users = userDataSource.fetch()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.login, "testUser")
        XCTAssertEqual(users.first?.avatarUrl, "https://example.com/avatar.png")
    }
    
    func testDeleteAll() throws {
        mockModelContext.storage = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
        
        try userDataSource.deleteAll()
        let users = userDataSource.fetch()
        
        XCTAssertTrue(users.isEmpty)
    }
    
    func testUpdateUsers() async throws {
        let mockUserDTO = UserDTO(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")
        let mockData = try JSONEncoder().encode([mockUserDTO])
        mockNetworkService.mockData = mockData
        
        try await userDataSource.update()
        let users = userDataSource.fetch()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.login, "testUser")
        XCTAssertEqual(users.first?.avatarUrl, "https://example.com/avatar.png")
    }
    
    func testUpdateNetworkFailure() async {
        mockNetworkService.mockError = NSError(domain: "TestError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
        do {
            try await userDataSource.update()
        } catch {
            XCTAssertEqual(error.localizedDescription, "Bad Request")
        }
    }
    
    func testUpdateDecodingError() async {
        mockNetworkService.mockData = Data("Invalid JSON".utf8) // Invalid JSON
        do {
            try await userDataSource.update()
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
