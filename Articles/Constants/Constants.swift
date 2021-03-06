//
//  Constants.swift
//  Articles
//
//  Created by Karen Minasyan on 2/20/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let baseURL = "https://content.guardianapis.com"
    static let apiKey = "fa66fe25-f55e-4c25-b3f4-5288725654e2" // API key is required to access the API.
    static let topWordLimit = 10 // If words count in an article exceeded the limit the word goes to TopWords.
    static let pageSize = 20 // Articles per page.
    
    struct UI {
        static let textHighlightColor = UIColor(named: "textHighlightColor") ?? UIColor.yellow
    }
}
