//
//  ArticleAPIError.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

enum ArticleAPIError: Error {
    case requestError(message: String)
}
