//
//  NumberPadView.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/16/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  A 4x3 grid of buttons similar to the phone keypad
//

import UIKit

// Number pad view protocol for button events
protocol NumberPadViewDelegate
{
    // User taps on one of the action buttons (OK or Cancel)
    func numberpadView(view: NumberPadView, actionButtonPressed: NumberPadView.NumberPadAction)
}

class NumberPadView: UIView
{
    enum NumberPadAction {
        case ok
        case cancel
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    
    private(set) var number = 0 {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    
    var delegate: NumberPadViewDelegate? = nil
    
    fileprivate let BUTTON_PRESS_SOUND_FILE_PATH = Bundle.main.path(forResource: "number_pad", ofType: "wav")!
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(view)
        view.backgroundColor = UIColor.clear
        
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: self)
    }
    
    // Clears the number pad and sets it to zero
    func clear()
    {
        self.number = 0
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton)
    {
        let text = numberLabel.text! + "\(sender.tag)"
        if let number = Int(text) {
            self.number = number
        }
        SoundEffectPlayer.shared.playSoundEffectOnce(filename: BUTTON_PRESS_SOUND_FILE_PATH)
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton)
    {
        delegate?.numberpadView(view: self, actionButtonPressed: (sender.tag == 0 ? .ok : .cancel))
    }
}
