//
//  Endpoint.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

import Foundation

protocol Endpoint {
    typealias Host = String
    typealias Path = String
    var scheme: Scheme { get }
    var host: Host { get }
    var path: Path { get }
}

enum GithubEndpoint: Endpoint {
    
    case github(path: GithubEndpoint.Paths)
    
    var scheme: Scheme {
        return .https
    }
    
    var host: Host {
        switch self {
        case .github: "api.github.com"
        }
    }
    
    var path: Path {
        switch self {
        case .github(path: let path):
            return path.path
        }
    }
}

extension GithubEndpoint {
    
    enum Paths {
        case following
        
        var users: String {
            return "users"
        }
        
        var myUser: String {
            return "alirezaeiii"
        }
        
        var path: String {
            switch self {
            case .following: return "/\(users)/\(myUser)/following"
            }
        }
    }
}
