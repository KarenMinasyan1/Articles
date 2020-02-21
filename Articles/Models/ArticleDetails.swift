//
//  ArticleDetails.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

typealias TopWord = (word: String, count: Int)

struct ArticleDetails {
    var title: String?
    var tags: Set<String>
    var bodyText: NSMutableAttributedString?
    var topWords: [TopWord]?
    var categoryText: String?
    var date: Date?
    var imageURL: URL?
}
