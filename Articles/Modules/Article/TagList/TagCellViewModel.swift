//
//  TagCellViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/22/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

class TagCellViewModel: ViewModel {
    private var tagText: String
    
    init(tagText: String, provider: ArticleAPI) {
        self.tagText = tagText
        super.init(provider: provider)
    }
    
    func getTagText() -> String {
        tagText
    }
}
