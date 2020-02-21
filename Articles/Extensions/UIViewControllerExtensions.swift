//
//  UIViewControllerExtensions.swift
//  Articles
//
//  Created by Karen Minasyan on 2/21/20.
//  Copyright © 2020 KarenMinasyan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Method for showing alerts in view controllers with message and title
    func showAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(oKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Method for showing error alerts in view controllers
    func show(error: ArticleAPIError) {
        switch error {
        case .requestError(let message):
            showAlert(message: message, title: "Error")
        }
    }
}
