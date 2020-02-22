//
//  ArticleViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

protocol ArticleViewModelDelegate: AnyObject {
    func articleViewModelDidReceiveArticle(_ viewModel: ArticleViewModel)
    func articleViewModel(_ viewModel: ArticleViewModel, didSelectTopWord word: String)
    func articleViewModel(_ viewModel: ArticleViewModel, didReceiveError error: ArticleAPIError)
}

protocol ArticleViewModelInput {
    func loadArticle()
    func selectTopWord(row: Int)
    func getTagsCollectionViewModel() -> TagsCollectionViewModel
    func getTitle() -> String?
    func getBodyText() -> String?
    func getTopWords() -> [TopWord]
    func getHeadline() -> String?
    func getDate() -> Date?
    func getImageURL() -> URL?
}

class ArticleViewModel: ViewModel {
    private let articleID: String
    private var article: Article?
    weak var delegate: ArticleViewModelDelegate?
    
    private var tags: [String]?
    private var topWords: [TopWord]?
    
    init(articleID: String, provider: ArticleAPI) {
        self.articleID = articleID
        super.init(provider: provider)
    }
    
    private func setup(article: Article) {
        tags = article.webTitle?.wordsSet.sorted()
        topWords = article.fields?.bodyText?.wordCountDictionaty().filter { $0.value >= Constants.topWordLimit }.map { ($0, $1) }.sorted(by: { $0.1 > $1.1 })
        delegate?.articleViewModelDidReceiveArticle(self)
    }
}

// MARK: - Acticle viewModel input
extension ArticleViewModel: ArticleViewModelInput {
    func loadArticle() {
        provider.getArticle(id: articleID) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.delegate?.articleViewModel(self, didReceiveError: error)
            } else if let article = result?.response?.content {
                self.article = article
                self.setup(article: article)
            }
        }
    }
    
    func selectTopWord(row: Int) {
        if let word = topWords?[row].word {
            delegate?.articleViewModel(self, didSelectTopWord: word)
        }
    }
    
    func getTagsCollectionViewModel() -> TagsCollectionViewModel {
        TagsCollectionViewModel(tags: tags ?? [], provider: provider)
    }
    
    func getTitle() -> String? {
        article?.webTitle
    }
    
    func getBodyText() -> String? {
        article?.fields?.bodyText
    }
    
    func getTopWords() -> [TopWord] {
        topWords ?? []
    }
    
    func getHeadline() -> String? {
        article?.fields?.headline
    }
    
    func getDate() -> Date? {
        article?.webPublicationDate
    }
    
    func getImageURL() -> URL? {
        URL(string: article?.fields?.thumbnail ?? "")
    }
}
