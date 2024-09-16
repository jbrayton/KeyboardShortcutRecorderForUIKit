//
//  KEYClearButton.swift
//  unread
//
//  Created by John Brayton on 3/24/21.
//  Copyright © 2021 Golden Hill Software. All rights reserved.
//

import Foundation
import UIKit

public class KEYClearButton : UIButton {
    
    public var enabledColor: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var disabledColor: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override public var isEnabled: Bool {
    	didSet {
    		self.setNeedsDisplay()
    	}
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        let color = self.isEnabled ? self.enabledColor : self.disabledColor
        guard let color else {
            return
        }
        
        let targetDimension: CGFloat = 16.0
        let multiplier: CGFloat = targetDimension/1024.0
        let horizontalOffset = ((self.bounds.width - targetDimension)/2.0)+2.0
        let verticalOffset = (self.bounds.height - targetDimension)/2.0

        let combinedShape = UIBezierPath()
        combinedShape.move(to: CGPoint(x: horizontalOffset+(multiplier*512), y: verticalOffset+(multiplier*0)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*1024), y: verticalOffset+(multiplier*512)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*794.77), y: verticalOffset+(multiplier*0)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*1024), y: verticalOffset+(multiplier*229.23)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*512), y: verticalOffset+(multiplier*1024)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*1024), y: verticalOffset+(multiplier*794.77)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*794.77), y: verticalOffset+(multiplier*1024)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*0), y: verticalOffset+(multiplier*512)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*229.23), y: verticalOffset+(multiplier*1024)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*0), y: verticalOffset+(multiplier*794.77)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*512), y: verticalOffset+(multiplier*0)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*0), y: verticalOffset+(multiplier*229.23)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*229.23), y: verticalOffset+(multiplier*0)))
        combinedShape.close()
        combinedShape.move(to: CGPoint(x: horizontalOffset+(multiplier*713.13), y: verticalOffset+(multiplier*310.42)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*667.88), y: verticalOffset+(multiplier*310.42)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*700.64), y: verticalOffset+(multiplier*297.93)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*680.37), y: verticalOffset+(multiplier*297.93)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*667.88), y: verticalOffset+(multiplier*310.42)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*512), y: verticalOffset+(multiplier*466.3)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*356.12), y: verticalOffset+(multiplier*310.42)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*311.24), y: verticalOffset+(multiplier*310.05)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*343.75), y: verticalOffset+(multiplier*298.05)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*323.77), y: verticalOffset+(multiplier*297.93)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*310.87), y: verticalOffset+(multiplier*310.42)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*310.87), y: verticalOffset+(multiplier*355.68)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*298.37), y: verticalOffset+(multiplier*322.92)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*298.37), y: verticalOffset+(multiplier*343.18)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*310.87), y: verticalOffset+(multiplier*355.68)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*466.75), y: verticalOffset+(multiplier*511.56)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*310.87), y: verticalOffset+(multiplier*667.43)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*310.5), y: verticalOffset+(multiplier*712.31)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*298.5), y: verticalOffset+(multiplier*679.81)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*298.37), y: verticalOffset+(multiplier*699.79)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*310.87), y: verticalOffset+(multiplier*712.69)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*356.12), y: verticalOffset+(multiplier*712.69)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*323.36), y: verticalOffset+(multiplier*725.18)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*343.63), y: verticalOffset+(multiplier*725.18)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*356.12), y: verticalOffset+(multiplier*712.69)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*512), y: verticalOffset+(multiplier*556.81)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*667.88), y: verticalOffset+(multiplier*712.69)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*712.76), y: verticalOffset+(multiplier*713.06)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*680.25), y: verticalOffset+(multiplier*725.06)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*700.23), y: verticalOffset+(multiplier*725.18)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*713.13), y: verticalOffset+(multiplier*712.69)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*713.13), y: verticalOffset+(multiplier*667.43)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*725.63), y: verticalOffset+(multiplier*700.19)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*725.63), y: verticalOffset+(multiplier*679.93)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*713.13), y: verticalOffset+(multiplier*667.43)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*557.25), y: verticalOffset+(multiplier*511.56)))
        combinedShape.addLine(to: CGPoint(x: horizontalOffset+(multiplier*713.13), y: verticalOffset+(multiplier*355.68)))
        combinedShape.addCurve(to: CGPoint(x: horizontalOffset+(multiplier*713.5), y: verticalOffset+(multiplier*310.8)), controlPoint1: CGPoint(x: horizontalOffset+(multiplier*725.5), y: verticalOffset+(multiplier*343.31)), controlPoint2: CGPoint(x: horizontalOffset+(multiplier*725.63), y: verticalOffset+(multiplier*323.32)))
        combinedShape.close()
        combinedShape.usesEvenOddFillRule = true

        color.setFill()
        combinedShape.fill()
    }
    
    
}
