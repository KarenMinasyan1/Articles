//
//  StringExtensions.swift
//  Articles
//
//  Created by Karen Minasyan on 2/23/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation

extension String {
    // The method returns an array of words in the string
    func words() -> [String] {
        let range = startIndex ..< endIndex
        var words = [String]()
        enumerateSubstrings(in: range, options: NSString.EnumerationOptions.byWords) { (substring, _, _, _) in
            if let substring = substring {
                words.append(substring)
            }
        }
        return words
    }
}
