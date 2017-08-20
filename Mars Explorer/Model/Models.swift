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
enum Rover: String
{
    case curiousity = "Curiosity"
    case opportunity = "Opportunity"
    case spirit = "Spirit"
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

// The list of photos for a rover on a given sol
struct RoverSolPhotos
{
    var rover: Rover
    var sol: Int
    var photos: [RoverCamera: [String]]
}

// The rover cameras
enum RoverCamera: String
{
    case FHAZ = "FHAZ"
    case RHAZ = "RHAZ"
    case MAST = "MAST"
    case CHEMCAM = "CHEMCAM"
    case MAHLI = "MAHLI"
    case MARDI = "MARDI"
    case NAVCAM = "NAVCAM"
    case PANCAM = "PANCAM"
    case MINITES = "MINITES"
    case ENTRY = "ENTRY"
    
    // The list of cameras each rover has
    static let roverCameraList: [Rover: [RoverCamera]] = [.curiousity: [.NAVCAM, .MARDI, .MAHLI, .CHEMCAM, .MAST, .RHAZ, .FHAZ],
                                                          .opportunity: [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES],
                                                          .spirit: [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES]]
    
    // The full names for the cameras
    static let cameraFullNames: [RoverCamera: String] = [.FHAZ: "Front Hazard Avoidance Camera", .RHAZ: "Rear Hazard Avoidance Camera",
                                                         .NAVCAM: "Navigation Camera", .MAST: "Mast Camera",
                                                         .CHEMCAM: "Chemistry and Camera Complex", .MAHLI: "Mars Hand Lens Imager",
                                                         .MARDI: "Mars Descent Imager", .PANCAM: "Panoramic Camera",
                                                         .MINITES: "Miniature Thermal Emission Spectrometer (Mini-TES)",
                                                         .ENTRY: "Entry, Descent, and Landing Camera"]
}

// The current camera view. This is the image of a rover, on a particular sol, with a specific camera camera
struct RoverCameraView
{
    var rover: Rover
    var camera: RoverCamera
    var sol: Int
    
    let rovers: [Rover] = [.curiousity, .opportunity, .spirit]
    
    // Cycle to next camera
    mutating func cycleToNextCamera()
    {
        let cameras = RoverCamera.roverCameraList[self.rover]!
        var index = cameras.index(of: self.camera)!
        index = (index + 1) % cameras.count
        self.camera = cameras[index]
    }
    
    // Cycle to next rover
    mutating func cycleToNextRover()
    {
        var index = rovers.index(of: self.rover)!
        index = (index + 1) % rovers.count
        self.rover = rovers[index]
    }
}

