//
//  ViewBuilder.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/8/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Contructs views and deals with all UI mangement for view controllers of this app
//

import UIKit
import AVFoundation

class ViewBuilder
{
    // MARK:- Constants
    
    fileprivate static let ROVER_MANIFEST_PANEL_ROVER_NAME_TAG = 0
    fileprivate static let ROVER_MANIFEST_PANEL_LAND_DATE_TAG = 1
    fileprivate static let ROVER_MANIFEST_PANEL_LAUNCH_DATE_TAG = 2
    fileprivate static let ROVER_MANIFEST_PANEL_STATUS_TAG = 3
    fileprivate static let ROVER_MANIFEST_PANEL_SOL_TAG = 4
    fileprivate static let ROVER_MANIFEST_PANEL_PHOTOS_TAG = 5
    
    fileprivate static let TV_STATIC_VIDEO_NAME = "TV static effect"
    
    // MARK:- Public API
    
    // Sets up the home screen background
    static func setupHomeScreenBackground(view: UIView)
    {
        view.layer.contents = #imageLiteral(resourceName: "Background").cgImage
        view.layer.contentsGravity = kCAGravityResizeAspectFill
    }
    
    // Sets up the given view to have a translucent black background and a gradient border appropriate for this app
    static func setupTranslucentBlackViewWithGradientBorder(view: UIView)
    {
        view.layer.borderColor = UIColor(rgb: 0x32C1DF).cgColor
        view.layer.borderWidth = 2.0
        view.backgroundColor = UIConstants.PANEL_BACKGROUND_COLOR
        
        /*
        // gradient color
        let gradient = CAGradientLayer()
        gradient.masksToBounds = true
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.colors = UIConstants.GRADIENT_COLORS_BORDER
        
        // apply gradient to outline of the view
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: view.frame).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        view.layer.addSublayer(gradient)
        */
    }
    
    // Sets up the loading message view that contains a label for setting the message
    static func setupMessageView(messageView: UIView)
    {
        messageView.backgroundColor = UIColor.clear
        messageView.layer.contents = #imageLiteral(resourceName: "Loading Message Panel").cgImage
        messageView.layer.contentsGravity = kCAGravityResizeAspect
    }
    
    // Sets up the given view to show a TV static video
    static func setupTVStaticVideoView(view: UIView)
    {
        let path = Bundle.main.path(forResource: TV_STATIC_VIDEO_NAME, ofType: "mp4")!
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        player.actionAtItemEnd = .none
        player.volume = 0.6
        player.pause()
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(layer)
    }
    
    // Sets the rover selection panel's state to select the given rover. Nil sets all to unselected state.
    static func setRoverSelectionPanelState(selectedRover: Rover?, buttons: [UIButton], curiosityButtonID: Int, opportunityButtonID: Int, spiritButtonID: Int)
    {
        // deselect all first
        for button in buttons
        {
            switch button.tag
            {
            case curiosityButtonID:
                button.setImage(#imageLiteral(resourceName: "Rover Icon A "), for: .normal)
                
            case opportunityButtonID:
                button.setImage(#imageLiteral(resourceName: "Rover Icon B"), for: .normal)
                
            case spiritButtonID:
                button.setImage(#imageLiteral(resourceName: "Rover Icon C"), for: .normal)
                
            default:
                return
            }
        }
        
        // select the one if provided with a selected rover
        if let rover = selectedRover
        {
            let roverButtonIDs = [Rover.curiousity: curiosityButtonID, Rover.opportunity: opportunityButtonID, Rover.spirit: spiritButtonID]
            buttons.first(where: { $0.tag == roverButtonIDs[rover]! })!.setImage(#imageLiteral(resourceName: "Rover Icon Selected"), for: .normal)
        }
    }
    
    // Play or pause the video for the static view using the AVLayer
    static func setTVStaticVideoStatus(shouldPause: Bool, view: UIView)
    {
        if let layer = view.layer.sublayers?.first as? AVPlayerLayer
        {
            if shouldPause {
                layer.player?.pause()
            }
            else {
                layer.player?.play()
            }
        }
    }
    
    // Fills the rover manifest panel with info based on the rover manifest data
    static func fillRoverManifestPanelWithInfo(panel:UIView, rover: Rover, manifest: RoverManifest)
    {
        // the rover image
        let image = UIImage(named: UIConstants.ROVER_IMAGE_NAMES[rover]!)!
        let imageview = (panel.subviews.first { $0 is UIImageView }) as! UIImageView
        imageview.image = image
        
        // rover name label
        let nameLabel = panel.subviews.first { $0 is UILabel } as! UILabel
        nameLabel.text = manifest.name
        
        // get the stack view that holds the info labels
        let stackview = panel.subviews.first { $0 is UIStackView } as! UIStackView
        
        // manifest info labels
        for view in stackview.arrangedSubviews
        {
            if let label = view as? UILabel
            {
                switch label.tag
                {
                    
                case ROVER_MANIFEST_PANEL_SOL_TAG:
                    label.text = "Time On Mars: \(manifest.totalSols) Sols"
                    
                case ROVER_MANIFEST_PANEL_LAND_DATE_TAG:
                    label.text = "Landing Date: \(manifest.landingDate)"
                    
                case ROVER_MANIFEST_PANEL_LAUNCH_DATE_TAG:
                    label.text = "Launch Date: \(manifest.launchDate)"
                    
                case ROVER_MANIFEST_PANEL_STATUS_TAG:
                    label.text = "Status: \(manifest.status)"
                    
                case ROVER_MANIFEST_PANEL_PHOTOS_TAG:
                    label.text = "Total Photos Taken: \(manifest.totalPhotos)"
                    
                default:
                    break
                }
            }
        }
    }
}
