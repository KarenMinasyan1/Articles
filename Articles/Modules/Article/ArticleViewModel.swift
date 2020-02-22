//
//  ArticleViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

protocol ArticleViewModelDelegate: AnyObject {
    func articleViewModel(_ viewmodel: ArticleViewModel, didReceive details: ArticleDetails)
    func articleViewModel(_ viewmodel: ArticleViewModel, didUpdate bodyText: NSAttributedString)
    func articleViewModel(_ viewmodel: ArticleViewModel, didReceive error: ArticleAPIError)
}

protocol ArticleViewModelInput {
    func loadArticle()
    func topWordSelected(row: Int)
    func getTagsCount() -> Int
    func getTagCellViewModel(index: Int) -> TagCellViewModel
    func getTagText(index: Int) -> String
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
            guard let `self` = self else { return }
            if let error = error {
                self.delegate?.articleViewModel(self, didReceive: error)
            } else if let article = result?.response?.content {
                self.article = article
                if let details = article.convertToArticleDetails() {
                    self.articleDetails = details
                    self.delegate?.articleViewModel(self, didReceive: details)
                }
            }
        }
    }
    
    func topWordSelected(row: Int) {
        guard let key = articleDetails?.topWords?[row].word else { return }
        guard let attributedString = article?.fields?.bodyText?.getHighlightedAttributedString(with: key) else { return }
        delegate?.articleViewModel(self, didUpdate: attributedString)
    }
    
    func getTagsCount() -> Int {
        articleDetails?.tags.count ?? 0
    }
    
    func getTagCellViewModel(index: Int) -> TagCellViewModel {
        TagCellViewModel(tagText: getTagText(index: index), provider: provider)
    }
    
    func getTagText(index: Int) -> String {
        articleDetails?.tags.sorted()[index] ?? ""
    }
}
