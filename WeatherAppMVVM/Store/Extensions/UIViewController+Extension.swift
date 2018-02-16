//
//  UIViewController+Extension.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, buttons: [String], actions: ((Int) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (i, text) in buttons.enumerated() {
            let action = UIAlertAction(title: text, style: .default, handler: { _ in
                actions?(i)
            })
            alert.addAction(action)
        }
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
