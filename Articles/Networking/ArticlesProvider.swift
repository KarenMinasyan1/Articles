//
//  NetworkingManager.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

protocol ArticleAPI {
    func getArticleList(page: Int, completion: @escaping (ArticleListResponse?, ArticleAPIError?) -> ())
    func getArticle(id: String, completion: @escaping (ArticleResponse?, ArticleAPIError?) -> ())
}

// https://content.guardianapis.com/search?show-fields=thumbnail&api-key=fa66fe25-f55e-4c25-b3f4-5288725654e2

class ArticlesProvider: ArticleAPI {
    
    func getArticleList(page: Int, completion: @escaping (ArticleListResponse?, ArticleAPIError?) -> ()) {
        let params = ["page": String(page), "show-fields": "thumbnail", "api-key": Constants.apiKey]
        Networking.makeNetworkRequest(url: Constants.baseURL, path: "/search", params: params, responseType: ArticleListResponse.self, completion: completion)
    }
    
    func getArticle(id: String, completion: @escaping (ArticleResponse?, ArticleAPIError?) -> ()) {
        let params = ["show-fields": "thumbnail,bodyText,headline", "api-key": Constants.apiKey]
        Networking.makeNetworkRequest(url: Constants.baseURL, path: "/\(id)", params: params, responseType: ArticleResponse.self, completion: completion)
    }
}
