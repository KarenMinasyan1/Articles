//
//  TagsCollectionView.swift
//  Articles
//
//  Created by Karen Minasyan on 2/22/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

protocol TagsCollectionViewDelegate: AnyObject {
    func tagsCollectionView(_ collectionView: TagsCollectionView, didSelectTag text:String, row: Int)
}

class TagsCollectionView: UICollectionView {

    var viewModel: TagsCollectionViewModel?
    weak var tagsDelegate: TagsCollectionViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - Setup
    func initialize() {
        collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: TagCell.reuseID)
    }
    
    func setup(viewModel: TagsCollectionViewModel) {
        self.viewModel = viewModel
        delegate = self
        dataSource = self
    }
}

// MARK: - Collection view data source
extension TagsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getTagsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as? TagCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.setup(viewModel: viewModel.getTagCellViewModel(index: indexPath.row))
        return cell
    }
}

// MARK: - Collection view delegate
extension TagsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagText = viewModel?.getTagText(index: indexPath.row) ?? ""
        print("Tag selected: \(tagText)")
        // Notify the delegate when a tag is selected
        tagsDelegate?.tagsCollectionView(self, didSelectTag: tagText, row: indexPath.row)
    }
}

// MARK: - Collection view flow layout
extension TagsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = viewModel?.getTagText(index: indexPath.row) ?? ""
        // Calculates and returns the bounding rect for the "name" using the given options.
        let textSize = name.boundingRect(with: collectionView.frame.size, options: [], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], context: nil).size
        // If text width is greater than collection view width returns collectionView width otherwise text width
        let width = (textSize.width  > collectionView.frame.size.width) ? collectionView.frame.size.width : textSize.width
        let height = CGFloat(30)
        
        return CGSize(width: width, height: height)
    }
}
