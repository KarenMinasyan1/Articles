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
    var dataSource = [Article]()
    var reachedBottom = false
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = ArticleListViewModel(provider: ArticlesProvider())
        viewModel.delegate = self
        viewModel.resetArticles()
        refreshControl?.beginRefreshing()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ArticleListCell", bundle: nil), forCellReuseIdentifier: ArticleListCell.reuseID)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        let spinner = UIActivityIndicatorView(style: .medium)
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListCell.reuseID, for: indexPath) as! ArticleListCell
        cell.setupWith(article: dataSource[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if reachedBottom { return }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            reachedBottom = true
            tableView.tableFooterView?.isHidden = false
            viewModel.loadMoreArticles()
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.articleSelected(index: indexPath.row)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    // MARK: - Actions
    @objc func refreshAction() {
        viewModel.resetArticles()
    }
}

// MARK: - ViewModel output
extension ArticleListViewController: ArticleListViewModelDelegate {
    func articleListViewModelDidReceive(articles: [Article]) {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.tableFooterView?.isHidden = true
            self.reachedBottom = false
            
            self.dataSource = articles
            self.tableView.reloadData()
        }
    }
    
    func articleListViewModelDidReceive(error: ArticleAPIError) {
        // show alertView
    }
    
    func articleListViewModelDidCreate(viewModel: ArticleViewModel) {
        // navigate to Article page
    }
}

