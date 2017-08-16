//
//  SOLDialView.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/9/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Custom View for controlling the SOL
//

import UIKit


// The min value on the scale
var minValue = 0

// The max value represented on the scale (inclusive)
var maxValue = 1000

// The major divisions to draw (eg; draw a major division every 5 units)
var majorDivisionFactor = 5

fileprivate let LINE_WIDTH: CGFloat = 2.0
fileprivate let MINOR_DIVISION_HEIGHT_PERCENTAGE: CGFloat = 0.8
fileprivate let SPACING_PERCENTAGE: CGFloat = 0.01

class SOLDialView: UIView
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        // add gesture recognizer
        let gr = UIPanGestureRecognizer(target: self, action: #selector(SOLDialView.panned(_:)))
        addGestureRecognizer(gr)
    }
    
    override func draw(_ rect: CGRect)
    {
        let width = frame.size.width
        let height = frame.size.height
        
        UIColor.white.setStroke()
        UIColor.white.setFill()
        
        for i in 0 ... (maxValue - minValue)
        {
            let x = ((CGFloat(i) * width * SPACING_PERCENTAGE) + (CGFloat(i) * LINE_WIDTH))
            let path = UIBezierPath(rect: CGRect(x: x, y: 0, width: LINE_WIDTH, height: height))
            path.stroke()
            path.fill()
        }
    }
    
    // User pans determine the value selected
    func panned(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        print("Panned!")
    }
}
