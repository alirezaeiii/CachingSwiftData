//
//  MockModelContext.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/2/24.
//

import Foundation
import SwiftData
@testable import CachingSwiftData

class MockModelContext: ModelContextProtocol {
    var storage: [UserEntity] = []

    func fetch<T>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]  {
        return storage as! [T]
    }

    func insert<T>(_ entity: T)  {
        storage.append(entity as! UserEntity)
    }

    func save() throws {
        // No-op for mock
    }

    func deleteAll<T>(model: T.Type) throws {
        storage.removeAll()
    }
}
