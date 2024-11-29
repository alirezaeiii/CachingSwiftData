//
//  URLFactory.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

protocol URLFactory {
    static func createURL(from endpoint: Endpoint) -> URL?
}

struct DefaultURLFactory: URLFactory {
    
    static func createURL(from endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        return urlComponents.url
    }
}
