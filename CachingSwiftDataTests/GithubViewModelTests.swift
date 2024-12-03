//
//  GithubViewModelTests.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/2/24.
//

import XCTest
@testable import CachingSwiftData

final class GithubViewModelTests: XCTestCase {
    
    var viewModel: GithubViewModel!
    var mockDataSource: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockUserRepository()
        viewModel = GithubViewModel(dataSource: mockDataSource)
    }
    
    override func tearDown() {
        mockDataSource = nil
        viewModel = nil
        super.tearDown()
    }
    
    // Test: ViewModel should transition to .completed when data is already available
    func testLoadWithExistingData() async {
        // Arrange: Add mock users to the data source
        mockDataSource.mockUsers = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.load()
        
        XCTAssertEqual(viewModel.viewState, .completed)
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.login, "testUser")
    }
    
    func testLoadWithNetworkFailure() async {
        mockDataSource.shouldThrowError = true
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.load()
        
        // Assert: Verify that view state is failure
        XCTAssertEqual(viewModel.viewState, .failure(error: NSError(domain: "MockError", code: 1, userInfo: nil)))
    }
    
    func testRefresh() async {
        mockDataSource.mockUsers = [UserEntity(id: 1, login: "testUser", avatarUrl: "https://example.com/avatar.png")]
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.viewState, .completed)
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.login, "testUser")
    }
}
