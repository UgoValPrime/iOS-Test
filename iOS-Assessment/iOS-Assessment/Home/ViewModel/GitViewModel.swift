//
//  GitViewModel.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 06/11/2022.
//

import Foundation
import Network

protocol GitDelegate: AnyObject{
    func didReceiveData(_ data: GitDataResponse?)
    func didRecieveFollowersData(_ data: [FollowResponeData])
    func didRecieveFollowingData(_ data: [FollowResponeData])
}

final class GitViewModel {
    
    weak var delegate: GitDelegate?
    let userDefaults  = UserDefaults.standard
    var newsResource: GitProtocol?
    let monitor = NWPathMonitor()
    var noNetwork = false
    var details : Item?
    var pageNumber : Int?
    var following: Int?
    var follower: Int?
    
    init(newsResource: GitProtocol = GitResource()) {
        self.newsResource = newsResource
    }
    
    func monitorNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                if let pageNumber = self.pageNumber {
                    self.receiveData(pageNumber)
                }
               
                self.noNetwork = true
            } else {
                self.delegate?.didReceiveData(self.userDefaults.offlineNews)
            }
            print(path.isExpensive)
        }
    }
    
    func receiveData(_ pageNumber: Int) {
        newsResource?.getNewsData(PageNumber: pageNumber) { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.delegate?.didReceiveData(listOf)
                self?.userDefaults.offlineNews  = listOf
            case .failure(let error):
                self?.delegate?.didReceiveData(self?.userDefaults.offlineNews)
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
    }
    
    func follwersData(_ url: String) {
        newsResource?.getFollowersCount(url:url) { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.delegate?.didRecieveFollowersData(listOf)
              
                self?.following = listOf.count

            case .failure(let error):
                self?.following = 0
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
    }
    
    func followingData(_ url: String) {
        newsResource?.getFollowingCount(url: url) { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.delegate?.didRecieveFollowingData(listOf)
                self?.following = listOf.count
            case .failure(let error):
                self?.following = 0
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
    }
}
