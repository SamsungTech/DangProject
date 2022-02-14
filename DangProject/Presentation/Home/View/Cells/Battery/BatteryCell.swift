//
//  BatteryCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit
import Then

class BatteryCell: UICollectionViewCell {
    static let identifier = "BatteryCell"
    var mainView = UIView()
    var backgroundImage = UIImageView()
    var battery = UIImageView()
    var gradient = CAGradientLayer()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var circleProgressBar = UIView()
    var targetNumber = UILabel()
    var targetSugar = UILabel()
    var pulsatingLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        circleConfigure()
        configure()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setCollectionViewRadius(cell: self, radius: 30)
        setCollectionCellShadow(cell: self)
        mainView.do {
            $0.viewRadius(cornerRadius: 30)
            $0.setGradient(color1: .systemYellow, color2: .yellow)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        targetNumber.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: 50)
            $0.text = "50%"
        }
        targetSugar.do {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.text = "목표 22/100g"
        }
    }
    
    func layout() {
        [ mainView ].forEach() { contentView.addSubview($0) }
        [ circleProgressBar ].forEach() { mainView.addSubview($0) }
        [ targetNumber, targetSugar ].forEach() { circleProgressBar.addSubview($0) }
        
        mainView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
        circleProgressBar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 200).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        targetNumber.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 180).isActive = true
            $0.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        }
        targetSugar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: 5).isActive = true
            $0.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        }
    }
    
    func circleConfigure() {
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 110,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        let view = UIView()
        view.do {
            $0.viewRadius(cornerRadius: 50)
        }
        trackLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.init(red: 255/255,
                                          green: 244/255,
                                          blue: 109/255,
                                          alpha: 1).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.position = CGPoint(x: 100, y: 130)
        }
        pulsatingLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.position = CGPoint(x: 100, y: 130)
        }
        shapeLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.white.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.strokeEnd = 0
            $0.position = CGPoint(x: 100, y: 130)
        }
        [ pulsatingLayer, trackLayer, shapeLayer ].forEach() { circleProgressBar.layer.addSublayer($0) }
        animatePulsatingLayer()
        animateShapeLayer()
    }
}

extension BatteryCell {
    private func animateShapeLayer() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0.4
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.115
        animation.duration = 1
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "plusing")
        
    }
}
