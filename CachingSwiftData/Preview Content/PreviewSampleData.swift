//
//  PreviewSampleData.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import SwiftData
import SwiftUI

/// An actor that provides an in-memory model container for previews.
actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([UserEntity.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            UserEntity.user,
            UserEntity.user,
            UserEntity.user,
            UserEntity.user,
            UserEntity.user
        ]
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}

// Default quakes for use in previews.
extension UserEntity {
    static var user: UserEntity {
        .init(id: 1, login: "Ali", avatarUrl: "https://avatars.githubusercontent.com/u/2465559?v=4")
    }
}
