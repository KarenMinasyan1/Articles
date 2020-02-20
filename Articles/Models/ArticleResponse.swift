//
//  ArticleResponse.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

struct ArticleResponse: Codable {
    let response: ArticleResponseModel?
}

struct ArticleResponseModel: Codable {
    let content: Article?
    let status: String?
    let total: Int?
    let userTier: String?
}
