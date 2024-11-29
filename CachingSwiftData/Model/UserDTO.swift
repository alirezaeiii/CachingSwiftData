//
//  UserDTO.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

struct UserDTO : Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
}