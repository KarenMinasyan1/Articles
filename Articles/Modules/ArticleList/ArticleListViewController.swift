//
//  ViewController.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class ArticleListViewController: UITableViewController {

    var viewModel: ArticleListViewModel!
    var reachedBottom = false // Becomes "true" when table view scrolls to the end
    let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.resetArticles() // tell viewModel to load first page
        configureUI()
        setupTableView()
        refreshControl?.beginRefreshing()
    }
    
    // MARK: - UI
    func configureUI() {
        navigationItem.title = NSLocalizedString("ArticleList.Navigation.Title", comment: "")
    }
    
    func stopActivities() {
        refreshControl?.endRefreshing()
        tableView.tableFooterView?.isHidden = true
        reachedBottom = false
        spinner.stopAnimating()
    }
    
    // MARK: Table view configurations
    func setupTableView() {
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseID)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getArticlesCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as? ArticleCell {
            cell.setupWith(viewModel: viewModel.getArticleCellViewModel(index: indexPath.row))
            return cell
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if reachedBottom { return }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            reachedBottom = true
            tableView.tableFooterView?.isHidden = false
            spinner.startAnimating()
            viewModel.loadMoreArticles() // tell viewModel to load next page
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.articleSelected(index: indexPath.row)
    }
    
    // MARK: - Actions
    @objc func refreshAction() {
        viewModel.resetArticles()
    }
}

// MARK: - ViewModel output
extension ArticleListViewController: ArticleListViewModelDelegate {
    func articleListViewModelDidReceiveArticles(_ viewmodel: ArticleListViewModel) {
        DispatchQueue.main.async {
            self.stopActivities()
            self.tableView.reloadData()
        }
    }
    
    func articleListViewModel(_ viewmodel: ArticleListViewModel, didReceiveError error: AppError) {
        DispatchQueue.main.async {
            self.show(error: error)
            self.stopActivities()
        }
    }
    
    func articleListViewModel(_ viewmodel: ArticleListViewModel, didSelectArticle viewModel: ArticleViewModel) {
        // Navigating to Article page
        if let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "ArticleVC") as? ArticleViewController {
            viewController.viewModel = viewModel
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

