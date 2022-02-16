//
//  BatteryCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit
import Then
import RxSwift

class BatteryCell: UICollectionViewCell {
    static let identifier = "BatteryCell"
    var viewModel: BatteryCellViewModel?
    private var disposeBag = DisposeBag()
    private var mainView = UIView()
    private var gradient = CAGradientLayer()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    private var circleProgressBar = UIView()
    var targetNumber = UILabel()
    var percentLabel = UILabel()
    var targetSugar = UILabel()
    private var pulsatingLayer = CAShapeLayer()
    
    private var endCount: Int = 0
    private var currentCount: Int = 0
    private var timer = Timer()
    
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
    
    private func configure() {
        targetNumber.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: 50)
            $0.textAlignment = .right
        }
        percentLabel.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: 30)
            $0.textAlignment = .center
            $0.text = "%"
        }
        targetSugar.do {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    private func layout() {
        [ mainView ].forEach() { contentView.addSubview($0) }
        [ circleProgressBar ].forEach() { mainView.addSubview($0) }
        [ targetNumber, percentLabel, targetSugar ].forEach() { circleProgressBar.addSubview($0) }
        
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
            $0.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -10).isActive = true
        }
        percentLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 35).isActive = true
            $0.bottomAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: -5).isActive = true
        }
        targetSugar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: 5).isActive = true
            $0.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        }
    }
    
    func bind(viewModel: BatteryCellViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.items
            .subscribe(onNext: { foodData in
                self.targetSugar.text = "목표: " + String(format: "%.1f", foodData.sum) + "/25.6g"
            })
            .disposed(by: disposeBag)
    }
    
    private func circleConfigure() {
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
        countAnimation()
    }
}

extension BatteryCell {
    private func animateShapeLayer() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 0.4
        animation.duration = 2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "urSoBasic")
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
    private func countAnimation() {
        DispatchQueue.main.async {
            self.endCount = 50
            self.currentCount = 0
            self.timer = Timer.scheduledTimer(timeInterval: 2/50,
                                              target: self,
                                              selector: #selector(BatteryCell.updateNumber),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    @objc func updateNumber() {
        self.targetNumber.text = String(currentCount)
        currentCount += 1
        if currentCount > endCount {
            self.timer.invalidate()
        }
    }
}
