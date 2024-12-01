//
//  RequestProtocol.swift
//  CachingSwiftData
//
//  Created by Ali on 11/29/24.
//

import Foundation

protocol RequestProtocol {
    var httpMethod: HTTPMethod { get }
    var url: URL? { get }
    func request() throws -> URLRequest
}
