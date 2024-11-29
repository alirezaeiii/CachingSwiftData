//
//  ItemDataSource.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation
import SwiftData

final class ItemDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = ItemDataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: UserEntity.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func append(user: UserEntity) {
        modelContext.insert(user)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetch() -> [UserEntity] {
        do {
            return try modelContext.fetch(FetchDescriptor<UserEntity>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func delete() {
        do {
            return try modelContext.delete(model: UserEntity.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
