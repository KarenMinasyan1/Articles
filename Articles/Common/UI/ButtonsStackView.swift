//
//  ButtonsStackView.swift
//  Articles
//
//  Created by Karen Minasyan on 2/22/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

protocol ButtonsStackViewDelegate: AnyObject {
    func buttonsStackView(_ stackView: ButtonsStackView, didSelect row: Int)
}

class ButtonsStackView: UIStackView {
    weak var delegate: ButtonsStackViewDelegate?
    
    // The method creates buttons from strings and adds them to the stack view
    func setup(with texts: [String]) {
        for i in 0 ..< texts.count {
            let button = Button()
            button.setTitle(texts[i], for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            addArrangedSubview(button)
        }
    }
    
    // Notify delegate if any button pressed
    @objc func buttonAction(sender: UIButton) {
        delegate?.buttonsStackView(self, didSelect: sender.tag)
    }
}

extension ButtonsStackView {
    func setup(with topWords: [TopWord]) {
        setup(with: topWords.map { "\($0.word) (\($0.count))" })
    }
}
