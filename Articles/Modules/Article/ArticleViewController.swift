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
    
    func getHighlightedString(with text: String, key: String, color: UIColor = Constants.UI.textHighlightColor) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        do {
            // Putting \b before and after the search pattern will turn it into a whole word search (that is, the pattern “\bcat\b” will match only the word “cat,” but not “catch”)
            let regex = try NSRegularExpression(pattern: "\\b\(key)\\b", options: [.caseInsensitive])
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            
            for match in results {
                attributed.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: match.range)
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        
        return attributed
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
        guard let bodyText = viewModel.getBodyText() else { return }
        bodyTextLabel.attributedText = getHighlightedString(with: bodyText, key: word)
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
