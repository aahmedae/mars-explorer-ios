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

class ExplorationViewController: UIViewController, NumberPadViewDelegate
{
    // MARK:- Outlets
    
    @IBOutlet weak var imageIndexLabel: UILabel!
    @IBOutlet weak var cameraNameView: UIView!
    @IBOutlet weak var cameraNameLabel: UILabel!
    @IBOutlet weak var numberPadView: NumberPadView!
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
    var startingSol: Int? = nil
    var startingRover: Rover? = nil
    
    fileprivate var rover: Rover = .curiousity {
        didSet {
            roverButton.setTitle(rover.rawValue, for: .normal)
            loadData()
        }
    }
    
    fileprivate var sol: Int = 1000 {
        didSet {
            solButton.setTitle("\(sol)", for: .normal)
            loadData()
        }
    }
    
    var camera: RoverCamera = .FHAZ {
        didSet {
            if let photoUrl = self.cameraImages[camera]?.first {
                downloadPhotoAtURL(url: photoUrl, callback: { (image) in
                    self.currentImage = image
                    self.currentImageIndex = 0
                })
                cameraButton.setTitle(camera.rawValue, for: .normal)
                cameraNameLabel.text = RoverCamera.cameraFullNames[camera]!
            }
        }
    }
    
    fileprivate var currentImage: UIImage? = nil {
        didSet {
            if let image = currentImage {
                ViewAnimator.animateViewLayerImageBackground(view: self.view, newImage: image)
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
    
    fileprivate var currentImageIndex = 0 {
        didSet {
            if let images = cameraImages[camera] {
                imageIndexLabel.text = "\(currentImageIndex + 1) of \(images.count)"
            }
            else {
                imageIndexLabel.text = ""
            }
        }
    }
    
    fileprivate var cameraImages = [RoverCamera: [String]]()
    
    // tags to refer to the control buttons
    fileprivate let CONTROL_BUTTON_ID_SOL = 0
    fileprivate let CONTROL_BUTTON_ID_SOL_DECREMENT = -1
    fileprivate let CONTROL_BUTTON_ID_SOL_INCREMENT = 1
    fileprivate let CONTROL_BUTTON_ID_ROVER = 2
    fileprivate let CONTROL_BUTTON_ID_CAMERA = 3
    
    fileprivate let SEGUE_UNWIND_TO_HOME_VC = "Unwind_To_Home_VC"
    
    // MARK:- Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
        
        // set the starting properties if needed
        if let sol = startingSol {
            self.sol = sol
        }
        else if let rover = startingRover {
            self.rover = rover
        }
    }
    
    // UI Setup
    fileprivate func setupUI()
    {
        // background default image
        view.layer.contents = #imageLiteral(resourceName: "Rover_Mars_Test_Image").cgImage
        view.layer.contentsGravity = kCAGravityResizeAspectFill
        
        // control panel
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: controlPanel)
        
        // message view
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: messageView)
        messageView.isHidden = true
        
        // loading panel hidden
        scifiSpinner.stopAnimating()
        
        // number pad view
        numberPadView.isHidden = true
        numberPadView.delegate = self
        
        // image index label
        imageIndexLabel.text = ""
    }
    
    // Download data for the change in SOL and rover
    fileprivate func loadData()
    {
        controlPanel.isHidden = true
        cameraNameView.isHidden = true
        self.cameraButton.isEnabled = true
        self.nextImageButton.isEnabled = true
        self.previousImageButton.isEnabled = true
        
        scifiSpinner.startAnimating()
        messageView.isHidden = false
        messageLabel.text = "Transmitting Data..."
        
        NASADataAPI.shared.downloadRoverPhotos(rover: self.rover, sol: self.sol) { [weak self] (photoUrls, error) in
            
            if error != nil
            {
                print("Error in downloading rover photo URLs")
                DispatchQueue.main.async {
                    // hide loading views and show error message
                    self?.messageView.isHidden = false
                    self?.messageLabel.text = (error! == .timeout ? "Slow Connection: The server is taking too long to respond.": "Download Error: There was an error in downloading the data")
                    self?.scifiSpinner.stopAnimating()
                    self?.controlPanel.isHidden = false
                    self?.cameraNameView.isHidden = false
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self?.cameraImages = photoUrls!
                    
                    if let camera = photoUrls!.keys.first
                    {
                        self?.camera = photoUrls!.keys.first!
                        self?.messageView.isHidden = true
                    }
                    else
                    {
                        // no photos available for this sol
                        self?.messageLabel.text = "No photos were taken on this SOL"
                        self?.cameraButton.isEnabled = false
                        self?.nextImageButton.isEnabled = false
                        self?.previousImageButton.isEnabled = false
                    }
                    
                    self?.scifiSpinner.stopAnimating()
                    self?.controlPanel.isHidden = false
                    self?.cameraNameView.isHidden = false
                    
                    SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
                    ViewAnimator.animatePanelFlipFromBottom(panel: (self?.controlPanel)!)
                    ViewAnimator.animatePanelFlipFromTop(panel: (self?.cameraNameView)!)
                }
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
            if var index = cameras.index(of: self.camera) {
                index = (index + 1) % cameras.count
                self.camera = cameras[index]
            }
            
        case CONTROL_BUTTON_ID_ROVER:
            let rovers = [Rover.curiousity, Rover.opportunity, Rover.spirit]
            var index = rovers.index(of: self.rover)!
            index = (index + 1) % rovers.count
            self.rover = rovers[index]
            
        case CONTROL_BUTTON_ID_SOL:
            SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
            numberPadView.isHidden = false
            ViewAnimator.animatePanelFlipFromTop(panel: numberPadView)
            
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
            currentImageIndex = ((currentImageIndex + sender.tag >= 0) ? ((currentImageIndex + sender.tag) % photoUrls.count) : (photoUrls.count - 1))
            let url = photoUrls[currentImageIndex]
            
            downloadPhotoAtURL(url: url, callback: { (image) in
                self.currentImage = image
                SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
            })
        }
    }
    
    // Number pad view action button tapped to either accept or cancel entry
    func numberpadView(view: NumberPadView, actionButtonPressed: NumberPadView.NumberPadAction)
    {
        SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
        numberPadView.isHidden = true
        
        if actionButtonPressed == .ok
        {
            // ensure that the sol doesn't exceed the max sol for this rover
            if sol > manifests[rover]!.totalSols {
                sol = manifests[rover]!.totalSols
            }
            else {
                sol = numberPadView.number
            }
        }
        
        numberPadView.clear()
    }
    
    // User taps on the quit button to go back to the home screen
    @IBAction func quitButtonTapped(_ sender: UIButton)
    {
        scifiSpinner.stopAnimating()
        SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_SHUT_DOWN)
        performSegue(withIdentifier: SEGUE_UNWIND_TO_HOME_VC, sender: self)
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
