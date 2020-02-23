//
//  NetworkingManager.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

protocol ArticleAPI {
    func getArticleList(page: Int, pageSize: Int, completion: @escaping ([Article]?, AppError?) -> ())
    func getArticle(id: String, completion: @escaping (Article?, AppError?) -> ())
}

class ArticlesProvider: ArticleAPI {
    
    /// The method returns a list of articles with extra field thumbnail
    /// - Parameters:
    ///   - page: articles page
    ///   - pageSize: articles count per page
    func getArticleList(page: Int, pageSize: Int, completion: @escaping ([Article]?, AppError?) -> ()) {
        let params = ["page": String(page), "show-fields": "thumbnail", "page-size": "\(pageSize)", "api-key": Constants.apiKey]
        Networking.getRequest(url: Constants.baseURL, path: "/search", params: params, responseType: ArticleListResponse.self, completion: { articleListResponse, error in
            if error != nil {
                completion(nil, AppError.articleList)
            } else {
                completion(articleListResponse?.response?.results, nil)
            }
        })
    }
    
    /// The method returns a single article with extra fields (thumbnail, bodyText, headline)
    /// - Parameters:
    ///   - id: The article id
    func getArticle(id: String, completion: @escaping (Article?, AppError?) -> ()) {
        let params = ["show-fields": "thumbnail,bodyText,headline", "api-key": Constants.apiKey]
        Networking.getRequest(url: Constants.baseURL, path: "/\(id)", params: params, responseType: ArticleResponse.self, completion: { articleResponse, error in
            if error != nil {
                completion(nil, AppError.article)
            } else {
                completion(articleResponse?.response?.content, nil)
            }
        })
    }
}
