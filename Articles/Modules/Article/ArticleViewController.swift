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
        // tagList
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var topWordsView: UIView!
    @IBOutlet weak var topWordsStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel: ArticleViewModel!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        viewModel.delegate = self
        viewModel.loadArticle()
        // start animating
    }
    
    // MARK: - UI
    func configureUI() {
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
    
    func update(details: ArticleDetails) {
        titleLabel.text = details.title
        bodyTextLabel.attributedText = details.bodyText
        categoryLabel.text = details.categoryText
        imageView.kf.setImage(with: details.imageURL)
        dateLabel.text = details.date?.toString()
        
        if let topWords = details.topWords {
            if topWords.isEmpty {
                topWordsView.isHidden = true
            } else {
                update(topWords: topWords)
            }
        }
    }
    
    func update(topWords: [TopWord]) {
        for i in 0 ..< topWords.count {
            let button = TopWordButton()
            button.setup(topWord: topWords[i])
            button.tag = i
            button.addTarget(self, action: #selector(topWordButtonTap(sender:)), for: .touchUpInside)
            topWordsStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    @objc func topWordButtonTap(sender: UIButton) {
        viewModel.topWordSelected(row: sender.tag)
    }
}

extension ArticleViewController: ArticleViewModelDelegate {
    func articleViewModelDidReceive(details: ArticleDetails) {
        DispatchQueue.main.async {
            self.update(details: details)
        }
    }
    
    func articleViewModelDidUpdate(bodyText: NSAttributedString) {
        bodyTextLabel.attributedText = bodyText
    }
    
    func articleViewModelDidReceive(error: ArticleAPIError) {
        show(error: error)
    }
}
