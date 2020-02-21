//
//  ArticleCellViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class ArticleCellViewModel: ViewModel {
    var article: Article
    
    init(article: Article, provider: ArticleAPI) {
        self.article = article
        super.init(provider: provider)
    }
}
