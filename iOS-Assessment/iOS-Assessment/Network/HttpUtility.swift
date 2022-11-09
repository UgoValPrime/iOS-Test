//
//  HttpUtility.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 06/11/2022.
//

//import UIKit
//
//enum UserError: Error{
//    case NoDataAvailable
//    case CannotProcessData
//    case InvalidURL
//}
//
//protocol UtilityService {
//    func performDataTask<T: Decodable>(url: URL, resultType: T.Type, completion: @escaping (Result<T, UserError>) -> Void)
//}
//
//struct HTTPUtility: UtilityService {
//    
//    func performDataTask<T: Decodable>(
//        url: URL,
//        resultType: T.Type,
//        completion: @escaping (Result<T, UserError>) -> Void) {
//            guard url != URL(string: "") else {
//                completion(.failure(.InvalidURL))
//                return
//            }
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                guard data != nil else {
//                    completion(.failure(.NoDataAvailable))
//                    return
//                }
//                
//                guard let response = response
//                        as? HTTPURLResponse, (200..<210).contains(response.statusCode) else {
//                    completion(.failure(.CannotProcessData))
//                    return
//                }
//                
//                guard let data = data else {
//                    completion(.failure(.NoDataAvailable))
//                    return
//                }
//                
//                let decoder = JSONDecoder()
//                
//                do {
//                    let jsonData = try decoder.decode(T.self, from: data)
//                    _ = completion(.success(jsonData))
//                } catch {
//                    _ = completion(.failure(.CannotProcessData))
//                }
//            }.resume()
//        }
//}
