//
//  SciFiActivitySpinner.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/6/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Custom activity spinner view for achieving the sci-fi look
//

import UIKit
import AVFoundation

class SciFiActivitySpinner: UIView
{
    fileprivate var animation: CABasicAnimation!
    fileprivate var player: AVAudioPlayer!
    
    fileprivate let ANIMATION_TO_VALUE = 2 * Double.pi
    fileprivate let ANIMATION_DURATION: CFTimeInterval = 10
    fileprivate let SOUND_FILE_PATH = Bundle.main.path(forResource: "sputnik-beep", ofType: "mp3")!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        layer.contents = #imageLiteral(resourceName: "Loading Wheel B").cgImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        
        backgroundColor = UIColor.clear
        
        isHidden = true
        
        // simple rotation animation
        animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = ANIMATION_TO_VALUE
        animation.duration = ANIMATION_DURATION
        animation.repeatCount = Float.infinity
        
        // sputnik sound for loading view
        player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: SOUND_FILE_PATH))
        player.numberOfLoops = -1
    }
    
    // Animate the layer indefintely
    func startAnimating()
    {
        layer.removeAllAnimations()
        layer.add(animation, forKey: "Spin")
        isHidden = false
        player.play()
    }
    
    // Stop animating and hide
    func stopAnimating()
    {
        layer.removeAllAnimations()
        isHidden = true
        player.stop()
    }
}
