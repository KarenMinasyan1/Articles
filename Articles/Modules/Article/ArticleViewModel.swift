//
//  ArticleViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

protocol ArticleViewModelDelegate: AnyObject {
    func articleViewModelDidUpdate(details: ArticleDetails)
    func articleViewModelDidReceive(error: ArticleAPIError)
}

protocol ArticleViewModelInput {
    func loadArticle()
    func topWordSelected(text: String)
}

class ArticleViewModel: ViewModel {
    private let articleID: String
    private var article: Article?
    private var articleDetails: ArticleDetails?
    weak var delegate: ArticleViewModelDelegate?
    
    init(articleID: String, provider: ArticleAPI) {
        self.articleID = articleID
        super.init(provider: provider)
    }
}

extension ArticleViewModel: ArticleViewModelInput {
    func loadArticle() {
        provider.getArticle(id: articleID) { [weak self] (result, error) in
            if let error = error {
                self?.delegate?.articleViewModelDidReceive(error: error)
            } else if let article = result?.response?.content {
                self?.article = article
                self?.articleDetails = article.convertToArticleDetails()
                print("success")
            }
        }
    }
    
    func topWordSelected(text: String) {
        
    }
}
