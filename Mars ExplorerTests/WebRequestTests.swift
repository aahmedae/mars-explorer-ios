//
//  WebRequestTests.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/7/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Test out the WebRequest class
//

import XCTest

@testable import Mars_Explorer

class WebRequestTests: XCTestCase
{
    fileprivate let API_KEY = "SzUH8VZJaVBDkFdT7K1NXrbXR2oZQlKFdEYFzDm3"
    
    fileprivate let ENDPOINT_ROVER_MANIFEST_CURIOUSITY = "https://api.nasa.gov/mars-photos/api/v1/manifests/curiosity"
    fileprivate let ENDPOINT_ROVER_MANIFEST_OPPORTUNITY = "https://api.nasa.gov/mars-photos/api/v1/manifests/opportunity"
    fileprivate let ENDPOINT_ROVER_MANIFEST_SPIRIT = "https://api.nasa.gov/mars-photos/api/v1/manifests/spirit"
    
    // Test out the rover manifest endpoints
    func testRoverEndpoint()
    {
        let promise = XCTestExpectation(description: "Rover Endpoint JSON available")
        
        WebRequest.shared.request(urlString: ENDPOINT_ROVER_MANIFEST_CURIOUSITY, method: .GET, parameters: ["api_key": API_KEY]) { (json, error) in
            if error != nil
            {
                XCTFail("Error in WebRequest: \(error!)")
            }
            else if let json = json
            {
                // parse the JSON and ensure the structure is valid
                let manifest = json["photo_manifest"]
                let name = manifest["name"].stringValue
                let landingDate = manifest["landing_date"].stringValue
                let launchDate = manifest["launch_date"].stringValue
                let status = manifest["status"].stringValue
                let maxSol = manifest["max_sol"].intValue
                let totalPhotos = manifest["total_photos"].intValue
                
                // validate JSON structure and returned data
                if (name.characters.count > 0 && landingDate.characters.count > 0 && launchDate.characters.count > 0 && status.characters.count > 0) {
                    if (maxSol > 0 && totalPhotos > 0) {
                        promise.fulfill()
                        return
                    }
                }
                
                XCTFail("Invalid JSON Response")
            }
            else
            {
                XCTFail("Unknown Error in WebRequest")
            }
        }
    }
    
    // Test out file downloads
    func testFileDownloads()
    {
        let urlList = ["http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FRB_486265257EDR_F0481570FHAZ00323M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/rcam/RLB_486265291EDR_F0481570RHAZ00323M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/rcam/RRB_486265291EDR_F0481570RHAZ00323M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486272784EDR_F0481570NCAM00415M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486271176EDR_F0481570NCAM00322M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486270860EDR_F0481570NCAM00323M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486265192EDR_S0481570NCAM00546M_.JPG",
                       "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486265119EDR_S0481570NCAM00546M_.JPG"]
        
        let promise = XCTestExpectation(description: "Files downloaded")
        
        WebRequest.shared.downloadFilesAtUrls(urls: urlList, tempDirectoryFolderName: "test-images") { (urls, error) in
            if error != nil {
                XCTFail("Error: \(error)")
            }
            else
            {
                XCTAssert(urls != nil && urls!.count == urlList.count)
                promise.fulfill()
            }
        }
    }
}
