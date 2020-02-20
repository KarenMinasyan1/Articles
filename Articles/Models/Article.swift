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
}
