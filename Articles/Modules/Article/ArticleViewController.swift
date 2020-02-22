//
//  ArticleViewController.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var topWordsView: UIView!
    @IBOutlet weak var topWordsStackView: ButtonsStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tagsViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ArticleViewModel!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        viewModel.delegate = self
        topWordsStackView.delegate = self
        viewModel.loadArticle()
        animatingView(true)
    }
    
    // MARK: - UI
    func configureUI() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
    
    func updateUI() {
        titleLabel.text = viewModel.getTitle()
        bodyTextLabel.attributedText = NSAttributedString(string: viewModel.getBodyText() ?? "")
        categoryLabel.text = viewModel.getHeadline()
        imageView.kf.setImage(with: viewModel.getImageURL(), placeholder: UIImage(named: "article_placeholder"))
        dateLabel.text = viewModel.getDate()?.toString()
        
        tagsCollectionView.setup(viewModel: viewModel.getTagsCollectionViewModel())
        tagsCollectionView.reloadData()
        tagsViewHeightConstraint.constant = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        let topWords = viewModel.getTopWords()
        if topWords.isEmpty {
            topWordsView.isHidden = true
        } else {
            topWordsStackView.setup(with: topWords)
        }
    }
    
    func animatingView(_ animating: Bool) {
        activityView.isHidden = !animating
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

// MARK: - Article viewModel delegate
extension ArticleViewController: ArticleViewModelDelegate {
    func articleViewModelDidReceiveArticle(_ viewModel: ArticleViewModel) {
        DispatchQueue.main.async {
            self.animatingView(false)
            self.updateUI()
        }
    }
    
    func articleViewModel(_ viewModel: ArticleViewModel, didSelectTopWord word: String) {
        bodyTextLabel.attributedText = viewModel.getBodyText()?.getHighlightedAttributedString(with: word)
    }
    
    func articleViewModel(_ viewmodel: ArticleViewModel, didReceiveError error: ArticleAPIError) {
        show(error: error)
    }
}

// MARK: - Buttons stack view delegate
extension ArticleViewController: ButtonsStackViewDelegate {
    func buttonsStackView(_ stackView: ButtonsStackView, didSelect row: Int) {
        viewModel.selectTopWord(row: row)
    }
}
