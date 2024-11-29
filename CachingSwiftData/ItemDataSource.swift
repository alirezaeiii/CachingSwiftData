//
//  ItemDataSource.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation
import SwiftData

@ModelActor
actor ItemDataSource {
    
    func fetch() -> [UserEntity] {
        do {
            return try modelContext.fetch(FetchDescriptor<UserEntity>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func append(user: UserEntity) {
        modelContext.insert(user)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func delete() {
        do {
            try modelContext.delete(model: UserEntity.self)
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
