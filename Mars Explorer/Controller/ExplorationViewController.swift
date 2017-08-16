//
//  ExplorationViewController.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/9/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  View Controller responsible for providing the user with the experience of exploring Mars
//

import UIKit

class ExplorationViewController: UIViewController
{
    // MARK:- Outlets
    
    @IBOutlet weak var nextImageButton: UIButton!
    @IBOutlet weak var previousImageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var scifiSpinner: SciFiActivitySpinner!
    @IBOutlet weak var controlPanel: UIView!
    @IBOutlet weak var solButton: UIButton!
    @IBOutlet weak var solDecrementButton: UIButton!
    @IBOutlet weak var solIncrementButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var roverButton: UIButton!
    
    // MARK:- Properties and constants
    
    // The rover, sol, and manifests to be set by the calling VC
    var manifests: [Rover: RoverManifest]!
    
    var rover: Rover = .curiousity {
        didSet {
            roverButton.setTitle(rover.rawValue, for: .normal)
            loadData()
        }
    }
    
    var sol: Int = 1000 {
        didSet {
            solButton.setTitle("\(sol)", for: .normal)
            loadData()
        }
    }
    
    var camera: RoverCamera = .FHAZ {
        didSet {
            /*
            let images = currentImages[camera]
            if let image = images?.first {
                currentImage = image
                currentImageIndex = 0
            }
            */
            
            if let photoUrl = self.cameraImages[camera]?.first {
                downloadPhotoAtURL(url: photoUrl, callback: { (image) in
                    self.currentImage = image
                    self.currentImageIndex = 0
                })
                cameraButton.setTitle(camera.rawValue, for: .normal)
            }
        }
    }
    
    fileprivate var currentImage: UIImage? = nil {
        didSet {
            if let image = currentImage {
                view.layer.contents = image.cgImage
                view.layer.contentsGravity = kCAGravityResizeAspectFill
            }
        }
    }
    
    fileprivate var controlsEnabled = true {
        didSet {
            self.cameraButton.isEnabled = controlsEnabled
            self.solButton.isEnabled = controlsEnabled
            self.solIncrementButton.isEnabled = controlsEnabled
            self.solDecrementButton.isEnabled = controlsEnabled
            self.roverButton.isEnabled = controlsEnabled
            self.previousImageButton.isEnabled = controlsEnabled
            self.nextImageButton.isEnabled = controlsEnabled
        }
    }
    
    fileprivate var cameraImages = [RoverCamera: [String]]()
    fileprivate var currentImageIndex = 0
    //fileprivate var currentImages = [RoverCamera: [UIImage]]()
    
    // tags to refer to the control buttons
    fileprivate let CONTROL_BUTTON_ID_SOL = 0
    fileprivate let CONTROL_BUTTON_ID_SOL_DECREMENT = -1
    fileprivate let CONTROL_BUTTON_ID_SOL_INCREMENT = 1
    fileprivate let CONTROL_BUTTON_ID_ROVER = 2
    fileprivate let CONTROL_BUTTON_ID_CAMERA = 3
    
    // MARK:- Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // UI Setup
    fileprivate func setupUI()
    {
        // background test image
        currentImage = #imageLiteral(resourceName: "Rover_Mars_Test_Image")
        
        // control panel
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: controlPanel)
        
        // message view
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: messageView)
        messageView.isHidden = true
        
        // loading panel hidden
        scifiSpinner.stopAnimating()
    }
    
    // Download data for the change in SOL and rover
    fileprivate func loadData()
    {
        //currentImages = [RoverCamera: [UIImage]]()
        controlPanel.isHidden = true
        
        scifiSpinner.startAnimating()
        messageView.isHidden = false
        messageLabel.text = "Transmitting Data..."
        
        NASADataAPI.shared.downloadRoverPhotos(rover: self.rover, sol: self.sol) { [weak self] (photoUrls, error) in
            
            if error != nil
            {
                print("Error in downloading rover photo URLs")
            }
            else
            {
                DispatchQueue.main.async
                {
                    self?.cameraImages = photoUrls!
                    self?.camera = photoUrls!.keys.first!
                    
                    self?.scifiSpinner.stopAnimating()
                    self?.messageView.isHidden = true
                    self?.controlPanel.isHidden = false
                    
                    SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
                    ViewAnimator.animatePanelFlipUp(panel: (self?.controlPanel)!)
                }
                
                /*
                
                let totalKeys = photoUrls!.keys.count
                var cameraImagesDownloaded = 0
                
                // download all the photos for this rover filtered by camera
                for (camera, photos) in photoUrls!
                {
                    WebRequest.shared.downloadFilesAtUrls(urls: photos, tempDirectoryFolderName: camera.rawValue, callback: { [weak self] (urls, error) in
                        if error != nil {
                            print("Error in downloading photo list")
                        }
                        else
                        {
                            let cameraInClosure = camera
                            cameraImagesDownloaded += 1
                            
                            for url in urls!
                            {
                                if let image = UIImage(contentsOfFile: url.absoluteString)
                                {
                                    if self?.currentImages[cameraInClosure] == nil {
                                        self?.currentImages[cameraInClosure] = [UIImage]()
                                    }
                                    self?.currentImages[cameraInClosure]!.append(image)
                                }
                            }
                            
                            print("\(urls!.count) Images downloaded for camera: \(cameraInClosure.rawValue)")
                            
                            if cameraImagesDownloaded == totalKeys
                            {
                                DispatchQueue.main.async {
                                    self?.controlPanel.isHidden = false
                                    SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
                                    ViewAnimator.animatePanelFlipUp(panel: (self?.controlPanel)!)
                                    self?.scifiSpinner.stopAnimating()
                                    self?.messageView.isHidden = true
                                }
                            }
                        }
                    })
                }
                */
            }
        }
    }
    
    // MARK:- Events
    
    // User taps one of the buttons in the control panel
    @IBAction func controlButtonTapped(_ sender: UIButton)
    {
        switch sender.tag
        {
        case CONTROL_BUTTON_ID_CAMERA:
            let cameras = Array(cameraImages.keys)
            var index = cameras.index(of: self.camera)!
            index = (index + 1) % cameras.count
            self.camera = cameras[index]
            
        case CONTROL_BUTTON_ID_ROVER:
            let rovers = [Rover.curiousity, Rover.opportunity, Rover.spirit]
            var index = rovers.index(of: self.rover)!
            index = (index + 1) % rovers.count
            self.rover = rovers[index]
            
        case CONTROL_BUTTON_ID_SOL_INCREMENT:
            sol += 1
            
        case CONTROL_BUTTON_ID_SOL_DECREMENT:
            sol -= 1
            
        default:
            return
        }
        
        SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
    }
    
    // User taps on one of the buttons to navigate to the previous or next image
    @IBAction func imageNavigationButtonTapped(_ sender: UIButton)
    {
        if let photoUrls = cameraImages[camera]
        {
            currentImageIndex = (currentImageIndex + sender.tag) % photoUrls.count
            print("Current Image Index: \(currentImageIndex)")
            let url = photoUrls[currentImageIndex]
            
            downloadPhotoAtURL(url: url, callback: { (image) in
                self.currentImage = image
                SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
            })
        }
    }
    
    // MARK:- Private Functions
    
    // Downloads the photo at the url and calls the callback when download is done with the image on the main queue
    fileprivate func downloadPhotoAtURL(url: String, callback: @escaping (UIImage?) -> Void)
    {
        let queue = DispatchQueue(label: "Photo Download", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        messageView.isHidden = false
        messageLabel.text = "Transmitting Data..."
        controlsEnabled = false
        
        queue.async
        {
            if let url = URL(string: url)
            {
                if let data = try? Data(contentsOf: url)
                {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        self.messageView.isHidden = true
                        self.controlsEnabled = true
                        callback(image)
                    }
                    
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.messageView.isHidden = true
                self.controlsEnabled = true
                callback(nil)
            }
        }
    }
}
