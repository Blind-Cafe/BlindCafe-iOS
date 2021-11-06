//
//  ProgressBar.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/06.
//

import UIKit

class ProgressBar: UIView {
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    
    override func draw(_ rect: CGRect) {
        //let width = rect.width
        //let height = rect.height
        
        //let lineWidth = 0.1 * min(width, height)
        let lineWidth: CGFloat = 10
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.lightGray.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.mainGreen.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.pale.cgColor, UIColor.mainGreen.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.zPosition = 0
        gradientLayer.mask = foregroundLayer
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)
    }
    
    private func createCircularLayer(rect: CGRect, strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    
    //private func createTextLayer
}
