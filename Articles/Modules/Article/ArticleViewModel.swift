//
//  ArticleViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

protocol ArticleViewModelDelegate: AnyObject {
    func articleViewModelDidReceive(details: ArticleDetails)
    func articleViewModelDidUpdate(bodyText: NSAttributedString)
    func articleViewModelDidReceive(error: ArticleAPIError)
}

protocol ArticleViewModelInput {
    func loadArticle()
    func topWordSelected(row: Int)
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
                if let details = article.convertToArticleDetails() {
                    self?.articleDetails = details
                    self?.delegate?.articleViewModelDidReceive(details: details)
                }
            }
        }
    }
    
    func topWordSelected(row: Int) {
        guard let key = articleDetails?.topWords?[row].word else { return }
        guard let attributedString = article?.fields?.bodyText?.getHighlightedAttributedString(with: key) else { return }
        delegate?.articleViewModelDidUpdate(bodyText: attributedString)
    }
}
