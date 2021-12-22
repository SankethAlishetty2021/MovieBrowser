//
//  UIViewController+Extension.swift
//  MovieBrowser
//
//  Created by Sanketh on 20/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(title: String, message: String) {
        let alretController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alretController.addAction(okAction)
        present(alretController, animated: true)
    }
}
