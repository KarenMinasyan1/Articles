//
//  ViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

class ViewModel {
    var provider: ArticleAPI
    
    init(provider: ArticleAPI) {
        self.provider = provider
    }
}
