//
//  ModelContextProtocol.swift
//  CachingSwiftData
//
//  Created by Ali on 12/2/24.
//

import Foundation
import SwiftData

protocol ModelContextProtocol {
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T]
    func insert<T>(_ model: T) where T : PersistentModel
    func deleteAll<T>(model: T.Type) throws where T: PersistentModel
    func save() throws
}

extension ModelContext: ModelContextProtocol {
    func deleteAll<T: PersistentModel>(model: T.Type) throws {
        try self.delete(model: T.self)
    }
}
