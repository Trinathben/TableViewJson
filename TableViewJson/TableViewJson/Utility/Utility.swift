//
//  Utility.swift
//  TableViewJson
//
//  Created by Trinath Vikkurthi on 3/21/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showNetworkError() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Alert!", message: "Internet connection appears to be offline.", preferredStyle: .alert)
        // Add an action to the alert
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // Handle OK button tap
        }
        alertController.addAction(okAction)
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
}
