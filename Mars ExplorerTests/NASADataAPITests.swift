//
//  NASADataAPITests.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/7/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Tests for testing out the NASA Data API class
//

import XCTest

@testable import Mars_Explorer

class NASADataAPITests: XCTestCase
{
    // Test out the rover manifest downloads
    func testRoverManifestDownloads()
    {
        let promise = XCTestExpectation(description: "Rover manifest dictionary validated")
        
        NASADataAPI.shared.downloadRoverManifests { (manifests, error) in
            if error != nil
            {
                print("Error in downloading manifests!: \(error!)")
            }
            else
            {
                for (rover, manifest) in manifests!
                {
                    // check for rover name mathes and to ensure that the manifest dictionary is set correctly
                    switch rover
                    {
                    case .curiousity:
                        XCTAssert(manifest.name.lowercased() == "curiosity")
                        
                    case .opportunity:
                        XCTAssert(manifest.name.lowercased() == "opportunity")
                        
                    case .spirit:
                        XCTAssert(manifest.name.lowercased() == "spirit")
                    }
                    
                    // check field values to ensure they have data
                    if (manifest.name.characters.count == 0 || manifest.status.characters.count == 0 || manifest.landingDate.characters.count == 0 || manifest.launchDate.characters.count == 0) {
                        XCTFail("Data corruption for rover: \(rover)")
                    }
                    else if (manifest.totalPhotos == 0 || manifest.totalSols == 0) {
                        XCTFail("Data corruption for rover: \(rover)")
                    }
                    else {
                        promise.fulfill()
                    }
                }
            }
        }
    }
}
