//
//  TagsCollectionViewModel.swift
//  Articles
//
//  Created by Karen Minasyan on 2/22/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class TagsCollectionViewModel: ViewModel {
    var tags: [String]
    
    init(tags: [String], provider: ArticleAPI) {
        self.tags = tags
        super.init(provider: provider)
    }
    
    func getTagsCount() -> Int {
        tags.count
    }
    
    func getTagCellViewModel(index: Int) -> TagCellViewModel {
        TagCellViewModel(tagText: tags[index], provider: provider)
    }
    
    func getTagText(index: Int) -> String {
        tags[index]
    }
}
