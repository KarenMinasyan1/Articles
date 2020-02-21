//
//  Extension+String.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

extension String {
    // The method returns an NSAttributedString with highlited keys
    func getHighlightedAttributedString(with key: String, color: UIColor = .yellow) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        do {
            // Putting \b before and after the search pattern will turn it into a whole word search (that is, the pattern “\bcat\b” will match only the word “cat,” but not “catch”)
            let regex = try NSRegularExpression(pattern: "\\b\(key)\\b", options: [.caseInsensitive])
            let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))
            
            for match in results {
                attributed.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: match.range)
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        
        return attributed
    }
    
    // The method returns a dictionary with key: word and value: count
    func wordCount() -> [String: Int] {
        let words = self.words
        var wordDictionary = [String: Int]()
        for word in words {
            if let count = wordDictionary[word] {
                wordDictionary[word] = count + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary
    }
    
    // "words" returns an array with all words in the string
    // One letter strings (A, é, ϴ, a) are ignored
    var words: [String] {
        split { !$0.isLetter }.map { String($0.lowercased()) }.filter { $0.count > 1 }
    }
}

