//
//  Article.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

struct Article: Codable {
    let apiUrl: String?
    let fields: Field?
    let id: String?
    let isHosted: Bool?
    let pillarId: String?
    let pillarName: String?
    let sectionId: String?
    let sectionName: String?
    let type: String?
    let webPublicationDate: Date?
    let webTitle: String?
    let webUrl : String?
}

struct Field: Codable {
    let bodyText: String?
    let thumbnail: String?
    let headline: String?
}

extension Article {
    func convertToArticleDetails() -> ArticleDetails? {
        let tags = Set<String>(webTitle?.words ?? [])
        let imageURL = URL(string: fields?.thumbnail ?? "")
        let bodyText = NSMutableAttributedString(string: fields?.bodyText ?? "")
        let topWords = fields?.bodyText?.wordCount().filter { $0.value >= Constants.topWordLimit }.map { ($0, $1) }.sorted(by: { $0.1 > $1.1 })
        
        return ArticleDetails(title: webTitle, tags: tags, bodyText: bodyText, topWords: topWords, categoryText: fields?.headline, date: webPublicationDate, imageURL: imageURL)
    }
}
