//
//  TopWordButton.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

class Button: UIButton {

    convenience init(topWord: TopWord) {
        self.init(frame: CGRect.zero)
        setup(topWord: topWord)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    private func makeUI() {
        setTitleColor(.darkBlue, for: .normal)
    }
    
    func setup(topWord: TopWord) {
        setTitle("\(topWord.word) (\(topWord.count))", for: .normal)
    }
}
