//
//  ArticleListViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

// MARK: - ArticleList ViewModel delegate
protocol ArticleListViewModelDelegate: AnyObject {
    func articleListViewModel(_ viewmodel: ArticleListViewModel, DidReceiveNewRows rows: Range<Int>)
    func articleListViewModel(_ viewmodel: ArticleListViewModel, didReceiveError error: AppError)
    func articleListViewModel(_ viewmodel: ArticleListViewModel, didSelectArticle viewModel: ArticleViewModel)
}

// MARK: - ArticleList viewModel input protocol
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
    private var page = 1 // Articles page
    
    // The method downloads the specified page of articles
    private func loadArticles() {
        provider.getArticleList(page: page, pageSize: Constants.pageSize) { [weak self] (articles, error) in
            guard let `self` = self else { return }
            if let error = error {
                self.delegate?.articleListViewModel(self, didReceiveError: error)
            } else if let articles = articles {
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
        let rows = (articles.count - Constants.pageSize) ..< articles.count
        delegate?.articleListViewModel(self, DidReceiveNewRows: rows)
    }
}

// MARK: - ArticleList viewModel input
extension ArticleListViewModel: ArticleListViewModelInput {
    func articleSelected(index: Int) {
        let viewModel = ArticleViewModel(articleID: articles[index].id ?? "", provider: provider)
        delegate?.articleListViewModel(self, didSelectArticle: viewModel)
    }
    
    func loadMoreArticles() {
        page += 1 // next page
        loadArticles()
    }
    
    func resetArticles() {
        page = 1
        loadArticles()
    }
    
    // The method creates and returns an ArticleCell viewModel
    func getArticleCellViewModel(index: Int) -> ArticleCellViewModel {
        ArticleCellViewModel(article: articles[index], provider: provider)
    }
    
    func getArticlesCount() -> Int {
        articles.count
    }
}
