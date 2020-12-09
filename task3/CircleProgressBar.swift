//
//  CircleProgressBar.swift
//  task1
//
//  Created by Viktor on 27.11.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class CircleProgressBar: UIView {


    private var backgroundLayout = CAShapeLayer()
    private var foregroundLayout = CAShapeLayer()
    private var textLayout = CATextLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircle()

    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder : aCoder)
        createCircle()
    }
    
    var progressLvl: Int = 0 {
        didSet {
            foregroundLayout.strokeEnd = CGFloat(progressLvl) / 100
            textLayout.string = "\(progressLvl)%"
            switch progressLvl {
                   case 0...33:
                       foregroundLayout.strokeColor = UIColor.red.cgColor
                   case 33...66:
                       foregroundLayout.strokeColor = UIColor.yellow.cgColor
                   case 66...100:
                       foregroundLayout.strokeColor = UIColor.green.cgColor

                   default:
                       foregroundLayout.strokeColor = backgroundColor1.cgColor
                   }
        }
    }
    
    private var backgroundColor1: UIColor = UIColor.gray
    
    private func createCircle () {
        let circle = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 50, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        
        backgroundLayout.path = circle.cgPath
        
        backgroundLayout.fillColor = UIColor.clear.cgColor
        backgroundLayout.strokeColor = backgroundColor1.cgColor
        backgroundLayout.lineWidth = 15
        backgroundLayout.strokeEnd = 1
        
        layer.addSublayer(backgroundLayout)
        
        
        foregroundLayout.path = circle.cgPath
        
        foregroundLayout.fillColor = UIColor.clear.cgColor
        foregroundLayout.lineWidth = 15
        
        layer.addSublayer(foregroundLayout)
        
        textLayout.backgroundColor = UIColor.black.cgColor
        textLayout.foregroundColor = UIColor.white.cgColor
        textLayout.frame = CGRect(x: (frame.size.width - 40)/2, y: (frame.size.height - 20)/2, width: 40, height: 20)
        textLayout.alignmentMode = .center
        textLayout.fontSize = 18.0
        
        layer.addSublayer(textLayout)
        
    }
        
    func animate(toValue: CGFloat) {
        
       let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 5
        circularProgressAnimation.fromValue = 0.0
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        foregroundLayout.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
}
