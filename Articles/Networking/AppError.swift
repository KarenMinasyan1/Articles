//
//  ArticleAPIError.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

enum AppError: Error {
    case articleList
    case article
    case wrongURL
    case unknown
    
    var message: String {
        switch self {
        case .articleList: return NSLocalizedString("Error.ArticleList", comment: "")
        case .article: return NSLocalizedString("Error.Article", comment: "")
        case .wrongURL: return NSLocalizedString("Error.WrongURLComponents", comment: "")
        case .unknown: return NSLocalizedString("Error.Unknown", comment: "")
        }
    }
}
