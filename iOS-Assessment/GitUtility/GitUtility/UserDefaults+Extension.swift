//
//  UserDefaults+Extension.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 05/11/2022.
//

import Foundation
import GitModels

extension UserDefaults {
    public enum UserDefaultKeys: String {
        case newsData
        case favData
    }
    
    public var offlineNews: GitDataResponse? {
        get{
            get(key: UserDefaultKeys.newsData.rawValue, type: GitDataResponse.self)
        }
        set {
            set(key: UserDefaultKeys.newsData.rawValue, newValue: newValue, type: GitDataResponse.self)
        }
    }
    
    public var faves:[Item]? {
        get{
            get(key: UserDefaultKeys.favData.rawValue, type: [Item].self)
        }
        set {
            set(key: UserDefaultKeys.favData.rawValue, newValue: newValue, type: [Item].self)
        }
    }
    
    
    private func get<T: Codable>(key: String, type: T.Type) -> T? {
           if let savedData = object(forKey: key) as? Data {
               do {
                   return try JSONDecoder().decode(T.self, from: savedData)
               } catch {
                   print(error)
                   return nil
               }
           }
           return nil
       }
       private func set<T: Codable>(key: String, newValue: T?, type: T.Type) {
           if newValue == nil {
               removeObject(forKey: key)
               return
           }
           do {
               let encoded: Data = try JSONEncoder().encode(newValue)
               set(encoded, forKey: key)
           } catch {
               print(error)
           }
       }
    
}


extension Array where Element: Hashable {
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
