//
//  GitResource.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 06/11/2022.
//

import UIKit
import GitNetwork

protocol GitProtocol{
    func getNewsData(PageNumber: Int, completion: @escaping(Result<GitDataResponse, UserError>) -> Void)
    func getFollowersCount(url: String, completion: @escaping(Result<[FollowResponeData],UserError>) -> Void)
    func getFollowingCount(url: String, completion: @escaping(Result<[FollowResponeData],UserError>) -> Void)
}

struct GitResource: GitProtocol {
  
    private var httpUtility: UtilityService
    private var urlString: String = "\(API.baseUrl)\(API.path)\(API.param)"
    
    static let cache = NSCache<NSString, UIImage>()
    
    init(httpUtility: UtilityService = HTTPUtility()){
        self.httpUtility = httpUtility
    }
    
    func getFollowersCount(url: String, completion: @escaping (Result<[FollowResponeData], UserError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.InvalidURL))
            return
        }
        httpUtility.performDataTask(url: url, resultType: [FollowResponeData].self) { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFollowingCount(url: String, completion: @escaping (Result<[FollowResponeData], UserError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.InvalidURL))
            return
        }
        httpUtility.performDataTask(url: url, resultType: [FollowResponeData].self) { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNewsData(PageNumber: Int, completion: @escaping(Result<GitDataResponse, UserError>) -> Void){
        guard let url = URL(string: urlString + String(PageNumber)) else {
            completion(.failure(.InvalidURL))
            return
        }
        httpUtility.performDataTask(url: url, resultType: GitDataResponse.self) { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
