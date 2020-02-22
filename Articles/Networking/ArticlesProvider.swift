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

class ArticlesProvider: ArticleAPI {
    
    /// The method returns a list of articles with extra field thumbnail
    /// - Parameters:
    ///   - page: articles page
    func getArticleList(page: Int, completion: @escaping (ArticleListResponse?, ArticleAPIError?) -> ()) {
        let params = ["page": String(page), "show-fields": "thumbnail", "api-key": Constants.apiKey]
        Networking.makeNetworkRequest(url: Constants.baseURL, path: "/search", params: params, responseType: ArticleListResponse.self, completion: completion)
    }
    
    /// The method returns a single article with extra fields (thumbnail, bodyText, headline)
    /// - Parameters:
    ///   - id: The article id
    func getArticle(id: String, completion: @escaping (ArticleResponse?, ArticleAPIError?) -> ()) {
        let params = ["show-fields": "thumbnail,bodyText,headline", "api-key": Constants.apiKey]
        Networking.makeNetworkRequest(url: Constants.baseURL, path: "/\(id)", params: params, responseType: ArticleResponse.self, completion: completion)
    }
}
