//
//  MCTileView.swift
//  
//
//  Created by Florian PETIT on 6/6/14.
//  Copyright (c) 2014 Florian PETIT. All rights reserved.
//

import QuartzCore
import UIKit

@IBDesignable
class MCTileView: UIView {
  var backGroundRingLayer: CAShapeLayer!
  var ringLayer: CAShapeLayer!
  
  var imageLayer: CALayer!
  var image: UIImage? {
  didSet { updateLayerProperties() }
  }
  
  @IBInspectable var rating: Double = 0.6 {
  didSet { self.updateLayerProperties() }
  }
  @IBInspectable var lineWidth: Double = 10.0 {
  didSet { self.updateLayerProperties() }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if (backGroundRingLayer == nil) {
      backGroundRingLayer = CAShapeLayer()
      layer.addSublayer(backGroundRingLayer)
      
      let rect = CGRectInset(bounds, CGFloat(lineWidth) / 2.0, CGFloat(lineWidth) / 2.0)
      let path = UIBezierPath(ovalInRect: rect)
      
      backGroundRingLayer.path = path.CGPath
      backGroundRingLayer.fillColor = nil
      backGroundRingLayer.lineWidth = CGFloat(lineWidth)
      backGroundRingLayer.strokeColor = UIColor(white: 0.5, alpha: 0.3).CGColor
    }
    backGroundRingLayer.frame = layer.bounds
    
    if (ringLayer == nil) {
      ringLayer = CAShapeLayer()
      
      let innerRect = CGRectInset(bounds, CGFloat(lineWidth) / 2.0, CGFloat(lineWidth) / 2.0)
      let innerPath = UIBezierPath(ovalInRect: innerRect)
      
      ringLayer.path = innerPath.CGPath
      ringLayer.fillColor = nil
      ringLayer.lineWidth = CGFloat(lineWidth)
      ringLayer.strokeColor = UIColor.blueColor().CGColor
      ringLayer.anchorPoint = CGPointMake(0.5, 0.5)
      ringLayer.transform = CATransform3DRotate(ringLayer.transform, CGFloat(-M_PI) / 2.0 , 0, 0, 1)
      
      layer.addSublayer(ringLayer)
    }
    ringLayer.frame = layer.bounds
    
    if (imageLayer == nil) {
      let imageMaskLayer = CAShapeLayer()
      
      let insetBounds = CGRectInset(bounds, CGFloat(lineWidth) + 3.0, CGFloat(lineWidth) + 3.0)
      let innerPath = UIBezierPath(ovalInRect: insetBounds)
      
      imageMaskLayer.path = innerPath.CGPath
      imageMaskLayer.fillColor = UIColor.blackColor().CGColor
      imageMaskLayer.frame = bounds
      layer.addSublayer(imageMaskLayer)
      
      imageLayer = CALayer()
      imageLayer.mask = imageMaskLayer
      imageLayer.frame = bounds
      imageLayer.backgroundColor = UIColor.lightGrayColor().CGColor
      imageLayer.contentsGravity = kCAGravityResizeAspectFill
      layer.addSublayer(imageLayer)
    }
    
    updateLayerProperties()
  }
  
  func updateLayerProperties() {
    if (ringLayer != nil) {
      ringLayer.strokeEnd = CGFloat(rating)
      
      var strokeColor = UIColor.lightGrayColor()
      switch rating {
      case let r where r >= 0.75:
        strokeColor = UIColor(hue: 112.0/360.0, saturation: 0.39, brightness: 0.85, alpha: 1)
      case let r where r >= 0.5:
        strokeColor = UIColor(hue: 208.0/360.0, saturation: 0.51, brightness: 0.75, alpha: 1)
      case let r where r >= 0.25:
        strokeColor = UIColor(hue: 40.0/360.0, saturation: 0.39, brightness: 0.85, alpha: 1)
      default:
        strokeColor = UIColor(hue: 359.0/360.0, saturation: 0.48, brightness: 0.63, alpha: 1)
      }
      ringLayer.strokeColor = strokeColor.CGColor
    }
    
    if (imageLayer != nil) {
      if let i = image {
        imageLayer.contents = i.CGImage
      }
    }
  }
  
  override func prepareForInterfaceBuilder(){
    super.prepareForInterfaceBuilder()
    let projectPaths = NSProcessInfo.processInfo().environment["IB_PROJECT_SOURCE_DIRECTORIES"]!.componentsSeparatedByString(",")
    if projectPaths.count > 0 {
      if let projectPath = projectPaths[0] as? String {
        let imagePath = projectPath.stringByAppendingString("/Images/dubdub")
        image = UIImage(contentsOfFile: imagePath)
      }
    }
  }
}
