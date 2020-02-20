//
//  ArticleListResponse.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

class ArticleListResponse: Codable {
    let response : ArticleListResponseModel?
}

struct ArticleListResponseModel: Codable {
    let currentPage: Int?
    let orderBy: String?
    let pageSize: Int?
    let pages: Int?
    let results: [Article]?
    let startIndex: Int?
    let status: String?
    let total: Int?
    let userTier: String?
}
