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
    @IBOutlet weak var tagsCollectionView: UICollectionView!
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
        setupCollectionView()
        viewModel.delegate = self
        topWordsStackView.delegate = self
        viewModel.loadArticle()
        animatingView(true)
    }
    
    // MARK: - Setup Collection View
    func setupCollectionView() {
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        tagsCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: TagCell.reuseID)
    }
    
    // MARK: - UI
    func configureUI() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
    
    func update(details: ArticleDetails) {
        titleLabel.text = details.title
        bodyTextLabel.attributedText = details.bodyText
        categoryLabel.text = details.categoryText
        imageView.kf.setImage(with: details.imageURL, placeholder: UIImage(named: "article_placeholder"))
        dateLabel.text = details.date?.toString()
        tagsCollectionView.reloadData()
        tagsViewHeightConstraint.constant = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        if let topWords = details.topWords {
            if topWords.isEmpty {
                topWordsView.isHidden = true
            } else {
                topWordsStackView.setup(with: topWords)
            }
        }
    }
    
    func animatingView(_ animating: Bool) {
        activityView.isHidden = !animating
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

extension ArticleViewController: ArticleViewModelDelegate {
    func articleViewModel(_ viewmodel: ArticleViewModel, didReceive details: ArticleDetails) {
        DispatchQueue.main.async {
            self.animatingView(false)
            self.update(details: details)
        }
    }
    
    func articleViewModel(_ viewmodel: ArticleViewModel, didUpdate bodyText: NSAttributedString) {
        bodyTextLabel.attributedText = bodyText
    }
    
    func articleViewModel(_ viewmodel: ArticleViewModel, didReceive error: ArticleAPIError) {
        show(error: error)
    }
}

// MARK: - Collection view data source
extension ArticleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getTagsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        cell.setup(viewModel: viewModel.getTagCellViewModel(index: indexPath.row))
        return cell
    }
}

// MARK: - Collection view delegate
extension ArticleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagText = viewModel.getTagText(index: indexPath.row)
        print("Tag selected: \(tagText)")
    }
}

// MARK: - Collection view flow layout
extension ArticleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = viewModel.getTagText(index: indexPath.row)

        let textSize = name.boundingRect(with: collectionView.frame.size, options: [], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], context: nil).size
        
        let width = (textSize.width  > collectionView.frame.size.width) ? collectionView.frame.size.width : textSize.width
        let height = CGFloat(30)
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Buttons stack view delegate
extension ArticleViewController: ButtonsStackViewDelegate {
    func buttonsStackView(_ stackView: ButtonsStackView, didSelect row: Int) {
        viewModel.topWordSelected(row: row)
    }
}
