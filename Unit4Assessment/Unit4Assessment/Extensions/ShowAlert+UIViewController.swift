//
//  ShowAlert+UIViewController.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(title:String, message: String, completion: ((UIAlertAction) -> Void)? = nil){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertVC.addAction(okButton)
        present(alertVC, animated: true, completion: nil)
    }
}
