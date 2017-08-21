//
//  CustomUnwindSegue.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/21/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Segue with custom logic for unwinding. Used throughout the application
//

import UIKit

class CustomUnwindSegue: UIStoryboardSegue
{
    override func perform()
    {
        if let sourceView = self.source.view
        {
            if let destinationView = self.destination.view
            {
                let window = UIApplication.shared.keyWindow
                window?.insertSubview(destinationView, aboveSubview: sourceView)
                
                destinationView.transform = CGAffineTransform.identity
                
                UIView.animate(withDuration: 0.35, animations: { 
                    sourceView.alpha = 0.0
                    sourceView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    destinationView.alpha = 1.0
                }, completion: { (_) in
                    self.source.dismiss(animated: false, completion: nil)
                })
            }
        }
    }
}
