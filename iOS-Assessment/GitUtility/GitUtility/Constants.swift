//
//  Constants.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 06/11/2022.
//

import UIKit

public struct API {
    public static let baseUrl = "https://api.github.com"
    public static let path = "/search/users?"
    public static let param = "q=lagos&page="
    public static let cache = NSCache<NSString, UIImage>()
}




public struct Controller  {
    public static let monitor = "Monitor"
    public static let title = "News Feed"
}


public struct View {
    public static let headerColor = "header"
    public static let headerText = "Top news"
}
