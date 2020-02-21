//
//  ArticleViewController.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    var viewModel: ArticleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadArticle()
    }

}
