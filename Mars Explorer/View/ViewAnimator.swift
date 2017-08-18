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
    // MARK:- Animation Settings
    
    fileprivate static let GENERAL_ANIMATION_DURATION: TimeInterval = 0.35
    
    // MARK:- Public API
    
    // Animtes the rover selection panel in with a simple flip
    static func animateRoverSelectionPanelEntry(panel: UIView)
    {
        UIView.transition(with: panel, duration: GENERAL_ANIMATION_DURATION, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    
    // Animates the rover selection panel upwards to make room for the rover manifest panel with a flick
    static func animateRoverSelectionPanelUp(panel: UIView, centerYConstraint: NSLayoutConstraint)
    {
        // flip animation
        UIView.transition(with: panel, duration: GENERAL_ANIMATION_DURATION, options: .transitionFlipFromTop, animations: nil, completion: nil)
        
        // move up animation
        let constraint = centerYConstraint.constraintWithMultiplier(0.44)
        UIView.animate(withDuration: GENERAL_ANIMATION_DURATION) {
            panel.superview?.removeConstraint(centerYConstraint)
            panel.superview?.addConstraint(constraint)
            panel.superview?.layoutIfNeeded()
        }
    }
    
    // Animates the panel with a flip animation from the bitton to top
    static func animatePanelFlipFromBottom(panel: UIView)
    {
        UIView.transition(with: panel, duration: GENERAL_ANIMATION_DURATION, options: .transitionFlipFromBottom, animations: nil, completion: nil)
    }
    
    // Animates the panel with a flip animation from the side
    static func animatePanelFlipFromTop(panel: UIView)
    {
        UIView.transition(with: panel, duration: GENERAL_ANIMATION_DURATION, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    
    // Animates the view's layer to switch to the given image and animates with a fade between the image change
    static func animateViewLayerImageBackground(view: UIView, newImage: UIImage)
    {
        if view.layer.contents != nil
        {
            let animation = CABasicAnimation(keyPath: "contents")
            
            animation.fromValue = view.layer.contents
            animation.toValue = newImage.cgImage
            animation.duration = 0.6
            
            view.layer.add(animation, forKey: "contents")
        }
        
        view.layer.contents = newImage.cgImage
    }
}
