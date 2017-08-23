//
//  UIConstants.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/7/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//

import UIKit

class UIConstants
{
    // translucent background color of panels
    static let PANEL_BACKGROUND_COLOR = UIColor(rgb: 0x100F0F).withAlphaComponent(0.7)
    
    // Gradient colors for the border of views
    static let GRADIENT_COLORS_BORDER = [UIColor(rgb: 0x32C1DF).cgColor, UIColor(rgb: 0x39CCD6).cgColor, UIColor(rgb: 0x34D3D0).cgColor]
    
    // Rover Images
    static let ROVER_IMAGE_NAMES = [Rover.curiousity: "curiosity_rover", Rover.opportunity: "opportunity_rover", Rover.spirit: "spirit_rover"]
    
    // UI sound effect path
    static let UI_SOUND_EFFECT_PATH = Bundle.main.path(forResource: "ui_select", ofType: "mp3")!
    
    // Shut down sound effect path
    static let UI_SOUND_SHUT_DOWN = Bundle.main.path(forResource: "shut_down", ofType: "wav")!
    
    // Background ambience
    static let BACKGROUND_AMBIENCE_PATH = Bundle.main.path(forResource: "space_ambience", ofType: "wav")!
}
