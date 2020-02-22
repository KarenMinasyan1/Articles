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
        backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tagLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        layer.cornerRadius = 10
        clipsToBounds = true
        tagLabel.font = font
    }
    
    func setup(viewModel: TagCellViewModel) {
        tagLabel.text = viewModel.getTagText()
    }
}
