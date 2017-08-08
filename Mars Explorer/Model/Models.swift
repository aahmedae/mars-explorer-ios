//
//  Models.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/7/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Holds classess to model the data from NASA
//

import Foundation

// The 3 types of rovers
enum Rover {
    case curiousity
    case opportunity
    case spirit
}

// The rover mission manifest
struct RoverManifest
{
    var name: String
    var landingDate: String
    var launchDate: String
    var status: String
    var totalSols: Int
    var totalPhotos: Int
}

