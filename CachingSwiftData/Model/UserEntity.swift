//
//  UserEntity.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation
import SwiftData

@Model
class UserEntity {
    @Attribute(.unique) var id: Int
    var login: String
    var avatarUrl: String
    
    init(id: Int, login: String, avatarUrl: String) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
    }
}

extension UserEntity {
    
    convenience init(from user: UserDTO) {
        self.init(id: user.id, login: user.login, avatarUrl: user.avatarUrl)
    }
}

// Ensure that the model's conformance to Identifiable is public.
extension UserEntity: Identifiable {}
