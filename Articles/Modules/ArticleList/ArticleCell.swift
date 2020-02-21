//
//  ArticleListCell.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    static let reuseID = "ArticleCellReuseID"
    
    func setupWith(viewModel: ArticleCellViewModel) {
        articleTitleLabel.text = viewModel.article.webTitle
        if let url = URL(string: viewModel.article.fields?.thumbnail ?? "") {
            articleImageView.kf.setImage(with: url)
        }
    }
}
