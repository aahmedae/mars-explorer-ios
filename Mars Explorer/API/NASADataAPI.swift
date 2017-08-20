//
//  NASADataAPI.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/7/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Fetches and parses data from NASA's open APIs
//

import Foundation

class NASADataAPI
{
    // MARK:- Properties
    
    // Singleton
    static var shared = NASADataAPI()
    private init() {}
    
    // MARK:- API Constants
    
    fileprivate let API_KEY = "SzUH8VZJaVBDkFdT7K1NXrbXR2oZQlKFdEYFzDm3"
    
    fileprivate let ENDPOINT_ROVER_MANIFEST_CURIOUSITY = "https://api.nasa.gov/mars-photos/api/v1/manifests/curiosity"
    fileprivate let ENDPOINT_ROVER_MANIFEST_OPPORTUNITY = "https://api.nasa.gov/mars-photos/api/v1/manifests/opportunity"
    fileprivate let ENDPOINT_ROVER_MANIFEST_SPIRIT = "https://api.nasa.gov/mars-photos/api/v1/manifests/spirit"
    
    fileprivate let ENDPOINT_ROVER_PHOTOS_CURIOUSITY = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
    fileprivate let ENDPOINT_ROVER_PHOTOS_OPPORTUNITY = "https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos"
    fileprivate let ENDPOINT_ROVER_PHOTOS_SPIRIT = "https://api.nasa.gov/mars-photos/api/v1/rovers/spirit/photos"
    
    // MARK:- Public API
    
    // Download manifests for all 3 rovers
    func downloadRoverManifests(callback: @escaping ([Rover: RoverManifest]?, WebRequest.WebRequestError?) -> Void)
    {
        // prepare the data and endpoints for all 3 rovers
        let rovers = [Rover.curiousity, Rover.opportunity, Rover.spirit]
        let endpoints = [Rover.curiousity: ENDPOINT_ROVER_MANIFEST_CURIOUSITY, Rover.opportunity: ENDPOINT_ROVER_MANIFEST_OPPORTUNITY, Rover.spirit: ENDPOINT_ROVER_MANIFEST_SPIRIT]
        var manifests = [Rover: RoverManifest]()
        
        // loop through all rovers and make API calls to get the manifests of the rovers
        for rover in rovers
        {
            let endpoint = endpoints[rover]!
            WebRequest.shared.request(urlString: endpoint, method: .GET, parameters: ["api_key": API_KEY]) { (json, error) in
                let roverInClosure = rover
                if error != nil
                {
                    print("Error in NASADataAPI: \(error!)")
                    callback(nil, error!)
                }
                else
                {
                    // add the manifest to the dictionary and check if all 3 manifests are done
                    if let json = json
                    {
                        let root = json["photo_manifest"]
                        let manifest = self.parseRoverManifest(manifest: root)
                        manifests[roverInClosure] = manifest
                        
                        if manifests.count == 3 {
                            callback(manifests, nil)
                        }
                    }
                    else
                    {
                        print("Error in fetching json for curiousity")
                        callback(nil, .serverError)
                    }
                }
            }
        }
    }
    
    // Download photo data for the given rover on the given sol
    func downloadRoverPhotos(rover: Rover, sol: Int, callback: @escaping ([RoverCamera: [String]]?, WebRequest.WebRequestError?) -> Void)
    {
        let endpoints: [Rover: String] = [.curiousity: ENDPOINT_ROVER_PHOTOS_CURIOUSITY, .opportunity: ENDPOINT_ROVER_PHOTOS_OPPORTUNITY, .spirit: ENDPOINT_ROVER_PHOTOS_SPIRIT]
        let parameters: [String: Any] = ["api_key": API_KEY, "sol": sol]
        var photos = [RoverCamera: [String]]()
        
        WebRequest.shared.request(urlString: endpoints[rover]!, method: .GET, parameters: parameters) { (json, error) in
            if error != nil
            {
                print("Error in NASADataAPI: \(error!)")
                callback(nil, .serverError)
            }
            else
            {
                // parse into structured model, where photos are organized by camera
                if let json = json
                {
                    let photosJsonArray = json["photos"].arrayValue
                    for photoJson in photosJsonArray
                    {
                        let camera = RoverCamera(rawValue: photoJson["camera"]["name"].stringValue)!
                        let photoUrl = photoJson["img_src"].stringValue
                        
                        if photos[camera] == nil {
                            photos[camera] = [String]()
                        }
                        
                        photos[camera]!.append(photoUrl)
                    }
                    
                    callback(photos, nil)
                }
                else
                {
                    callback(nil, .serverError)
                }
            }
        }
    }
    
    // MARK:- Private Functions
    
    // Parse the JSON object into a rover manifest
    fileprivate func parseRoverManifest(manifest: JSON) -> RoverManifest
    {
        let name = manifest["name"].stringValue
        let landingDate = manifest["landing_date"].stringValue
        let launchDate = manifest["launch_date"].stringValue
        let status = manifest["status"].stringValue
        let maxSol = manifest["max_sol"].intValue
        let totalPhotos = manifest["total_photos"].intValue
        
        return RoverManifest(name: name, landingDate: landingDate, launchDate: launchDate, status: status, totalSols: maxSol, totalPhotos: totalPhotos)
    }
}
