//
//  ArticleListViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

protocol ArticleListViewModelDelegate: AnyObject {
    func articleListViewModelDidReceiveArticles(_ viewmodel: ArticleListViewModel)
    func articleListViewModel(_ viewmodel: ArticleListViewModel, didReceiveError error: ArticleAPIError)
    func articleListViewModel(_ viewmodel: ArticleListViewModel, didSelectArticle viewModel: ArticleViewModel)
}

protocol ArticleListViewModelInput {
    func articleSelected(index: Int)
    func loadMoreArticles()
    func resetArticles()
    func getArticleCellViewModel(index: Int) -> ArticleCellViewModel
    func getArticlesCount() -> Int
}

class ArticleListViewModel: ViewModel {
    weak var delegate: ArticleListViewModelDelegate?
    private var articles = [Article]()
    private var page = 1
    
    private func loadArticles() {
        provider.getArticleList(page: page) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.delegate?.articleListViewModel(self, didReceiveError: error)
            } else if let articles = result?.response?.results {
                self.setArticles(value: articles)
            }
        }
    }
    
    private func setArticles(value: [Article]) {
        if page == 1 {
            articles = value
        } else {
            articles += value
        }
        delegate?.articleListViewModelDidReceiveArticles(self)
    }
}

// MARK: - ArticleList viewModel input
extension ArticleListViewModel: ArticleListViewModelInput {
    func articleSelected(index: Int) {
        let viewModel = ArticleViewModel(articleID: articles[index].id ?? "", provider: provider)
        delegate?.articleListViewModel(self, didSelectArticle: viewModel)
    }
    
    func loadMoreArticles() {
        page += 1
        loadArticles()
    }
    
    func resetArticles() {
        page = 1
        loadArticles()
    }
    
    func getArticleCellViewModel(index: Int) -> ArticleCellViewModel {
        ArticleCellViewModel(article: articles[index], provider: provider)
    }
    
    func getArticlesCount() -> Int {
        articles.count
    }
}
