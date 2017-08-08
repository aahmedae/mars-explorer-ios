//
//  ViewAnimator.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/8/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Animates all views in the app
//

import UIKit

class ViewAnimator
{
    // MARK:- Public API
    
    // Animtes the rover selection panel in with a simple flip
    static func animateRoverSelectionPanelEntry(panel: UIView)
    {
        UIView.transition(with: panel, duration: 0.35, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    
    // Animates the rover selection panel upwards to make room for the rover manifest panel with a flick
    static func animateRoverSelectionPanelUp(panel: UIView, centerYConstraint: NSLayoutConstraint)
    {
        // flip animation
        UIView.transition(with: panel, duration: 0.35, options: .transitionFlipFromTop, animations: nil, completion: nil)
        
        // move up animation
        let constraint = centerYConstraint.constraintWithMultiplier(0.44)
        UIView.animate(withDuration: 0.35) { 
            panel.superview?.removeConstraint(centerYConstraint)
            panel.superview?.addConstraint(constraint)
            panel.superview?.layoutIfNeeded()
        }
    }
    
    // Animates the rover manifest panel with a flip animation
    static func animateRoverManifestPanel(panel: UIView)
    {
        UIView.transition(with: panel, duration: 0.35, options: .transitionFlipFromBottom, animations: nil, completion: nil)
    }
}
