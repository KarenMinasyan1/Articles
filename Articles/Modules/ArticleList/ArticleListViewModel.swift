//
//  ArticleListViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

protocol ArticleListViewModelDelegate: AnyObject {
    func articleListViewModelDidReceive(articles: [Article])
    func articleListViewModelDidReceive(error: ArticleAPIError)
    func articleListViewModelDidCreate(viewModel: ArticleViewModel)
}

protocol ArticleListViewModelInput {
    func articleSelected(index: Int)
    func loadMoreArticles()
    func resetArticles()
}

class ArticleListViewModel: ViewModel {
    weak var delegate: ArticleListViewModelDelegate?
    var articles = [Article]()
    private var page = 1
    
    private func loadArticles() {
        provider.getArticleList(page: page) { [weak self] (result, error) in
            if let error = error {
                self?.delegate?.articleListViewModelDidReceive(error: error)
            } else if let articles = result?.response?.results {
                self?.setArticles(value: articles)
            }
        }
    }
    
    private func setArticles(value: [Article]) {
        if page == 1 {
            articles = value
        } else {
            articles += value
        }
        delegate?.articleListViewModelDidReceive(articles: articles)
    }
}

extension ArticleListViewModel: ArticleListViewModelInput {
    func articleSelected(index: Int) {
        let viewModel = ArticleViewModel(article: articles[index], provider: provider)
        delegate?.articleListViewModelDidCreate(viewModel: viewModel)
    }
    
    func loadMoreArticles() {
        page += 1
        loadArticles()
    }
    
    func resetArticles() {
        page = 1
        loadArticles()
    }
}
