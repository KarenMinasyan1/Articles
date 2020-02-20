//
//  ArticleListCell.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleListCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    static let reuseID = "ArticleListCellReuseID"
    
    func setupWith(article: Article) {
        articleTitleLabel.text = article.webTitle
        if let url = URL(string: article.fields?.thumbnail ?? "") {
            articleImageView.kf.setImage(with: url)
        }
    }
    
}
