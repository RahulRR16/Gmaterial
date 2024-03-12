//
//  Extensions.swift

import Foundation
import UIKit

extension UIViewController{
    
    func showAlertView(title: String, message: String, actions: [UIAlertAction]?) {
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alertActions = actions {
            for alertAction in alertActions {
                alertControler.addAction(alertAction)
            }
        }else {
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertControler.addAction(alertAction)
        }
        
        self.present(alertControler, animated: true, completion: nil)
    }
}
