//
//  HttpUtility.swift
//  GitNetwork
//
//  Created by Ugo Val on 08/11/2022.
//

import Foundation

import UIKit

public enum UserError: Error{
    case NoDataAvailable
    case CannotProcessData
    case InvalidURL
}

public protocol UtilityService {
    func performDataTask<T: Decodable>(url: URL, resultType: T.Type, completion: @escaping (Result<T, UserError>) -> Void)
}

public struct HTTPUtility: UtilityService {
    
    public func performDataTask<T: Decodable>(
        url: URL,
        resultType: T.Type,
        completion: @escaping (Result<T, UserError>) -> Void) {
            guard url != URL(string: "") else {
                completion(.failure(.InvalidURL))
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard data != nil else {
                    completion(.failure(.NoDataAvailable))
                    return
                }
                
                guard let response = response
                        as? HTTPURLResponse, (200..<210).contains(response.statusCode) else {
                    completion(.failure(.CannotProcessData))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.NoDataAvailable))
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let jsonData = try decoder.decode(T.self, from: data)
                    _ = completion(.success(jsonData))
                } catch {
                    _ = completion(.failure(.CannotProcessData))
                }
            }.resume()
        }
    public init () {}
}
