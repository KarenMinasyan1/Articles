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
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var topWordsView: UIView!
    @IBOutlet weak var topWordsStackView: UIStackView!
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
        imageView.kf.setImage(with: details.imageURL)
        dateLabel.text = details.date?.toString()
        tagsCollectionView.reloadData()
        tagsViewHeightConstraint.constant = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
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
            let button = TopWordButton(topWord: topWords[i])
            button.tag = i
            button.addTarget(self, action: #selector(topWordButtonTap(sender:)), for: .touchUpInside)
            topWordsStackView.addArrangedSubview(button)
        }
    }
    
    func animatingView(_ animating: Bool) {
        activityView.isHidden = !animating
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    @objc func topWordButtonTap(sender: UIButton) {
        viewModel.topWordSelected(row: sender.tag)
    }
}

extension ArticleViewController: ArticleViewModelDelegate {
    func articleViewModelDidReceive(details: ArticleDetails) {
        DispatchQueue.main.async {
            self.animatingView(false)
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
