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
    private var gradientLayer: CAGradientLayer!
    
    public var progress: CGFloat = 0 {
        didSet {
            didProgressUpdate()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth: CGFloat = 12
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.black2.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.mainGreen.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradientLayer.colors = [UIColor.pale.cgColor, UIColor.lightsage.cgColor, UIColor.mainGreen.cgColor]
        gradientLayer.frame = rect
        gradientLayer.mask = foregroundLayer
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
    }
    
    private func createCircularLayer(rect: CGRect, strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    private func didProgressUpdate() {
        foregroundLayer?.strokeEnd = progress
    }
    
    func removeForegroundLayer() {
        gradientLayer.removeFromSuperlayer()
    }
    
    func addForegroundLayer() {
        layer.addSublayer(gradientLayer)
    }
}
