//
//  CustomSegue.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/21/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Represents a custom modal segue using throughout the application
//

import UIKit

class CustomSegue: UIStoryboardSegue
{
    override func perform()
    {
        if let sourceView = self.source.view
        {
            if let destinationView = self.destination.view
            {
                destinationView.frame = UIScreen.main.bounds
                let window = UIApplication.shared.keyWindow
                window?.insertSubview(destinationView, aboveSubview: sourceView)
                
                destinationView.alpha = 0.0
                destinationView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
                UIView.animate(withDuration: 0.35, animations: { 
                    sourceView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                    sourceView.alpha = 0.0
                    destinationView.alpha = 1.0
                    destinationView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.source.present(self.destination, animated: false, completion: nil)
                })
            }
        }
    }
}
