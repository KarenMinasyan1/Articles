//
//  TagCell.swift
//  Articles
//
//  Created by Karen Minasyan on 2/22/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    static let reuseID = "TagCell"
    
    private let font = UIFont.systemFont(ofSize: 17)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
        tagLabel.textColor = .darkGray
        layer.cornerRadius = 10
        clipsToBounds = true
        tagLabel.font = font
    }
    
    func setup(viewModel: TagCellViewModel) {
        tagLabel.text = viewModel.getTagText()
    }
}
