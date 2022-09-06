//
//  CalendarCollectionView.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/23.
//

import UIKit
import RxSwift

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private var dayLabel = UILabel()
    private var selectedView = UIView()
    private var currentLineView = UIView()
    
    private let animatingPercentLineLayer = CAShapeLayer()
    private let nonAnimatingPercentLineLayer = CAShapeLayer()
    private let smallPercentLineBackgroundLayer = CAShapeLayer()
    private let circularPath = UIBezierPath(arcCenter: .zero,
                                            radius: 15,
                                            startAngle: -CGFloat.pi / 2,
                                            endAngle: 2 * CGFloat.pi,
                                            clockwise: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isUserInteractionEnabled = true
        dayLabel.attributedText = nil
        animatingPercentLineLayer.removeFromSuperlayer()
        nonAnimatingPercentLineLayer.removeFromSuperlayer()
        nonAnimatingPercentLineLayer.strokeColor = UIColor.smallCircleBackgroundColorGray.cgColor
        smallPercentLineBackgroundLayer.removeFromSuperlayer()
        selectedView.isHidden = true
        currentLineView.isHidden = true
    }
    
    private func configure() {
        self.backgroundColor = .homeBackgroundColor
        
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
        dayLabel.textColor = .white
        
        animatingPercentLineLayer.fillColor = UIColor.clear.cgColor
        animatingPercentLineLayer.lineCap = .round
        animatingPercentLineLayer.position = CGPoint(x: 28, y: 40)
        
        nonAnimatingPercentLineLayer.fillColor = UIColor.clear.cgColor
        nonAnimatingPercentLineLayer.lineCap = .round
        nonAnimatingPercentLineLayer.position = CGPoint(x: 28, y: 40)
        
        smallPercentLineBackgroundLayer.path = circularPath.cgPath
        smallPercentLineBackgroundLayer.fillColor = UIColor.clear.cgColor
        smallPercentLineBackgroundLayer.strokeColor = UIColor.smallCircleBackgroundColorGray.cgColor
        smallPercentLineBackgroundLayer.lineCap = .round
        smallPercentLineBackgroundLayer.position = CGPoint(x: 28, y: 40)
        smallPercentLineBackgroundLayer.lineWidth = 4
        
        selectedView.viewRadius(cornerRadius: 11)
        selectedView.backgroundColor = UIColor.currentDayCellLineViewColor
        
        currentLineView.layer.borderColor = UIColor.currentDayCellLineViewColor.cgColor
        currentLineView.backgroundColor = .clear
        currentLineView.layer.borderWidth = 3
        currentLineView.viewRadius(cornerRadius: 15)
    }
    
    private func layout() {
        [ currentLineView, selectedView, dayLabel ].forEach() { contentView.addSubview($0) }
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        selectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
        selectedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3).isActive = true
        selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        selectedView.isHidden = true
        
        currentLineView.translatesAutoresizingMaskIntoConstraints = false
        currentLineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        currentLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        currentLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        currentLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        currentLineView.isHidden = true
    }
    
    func configureCell(data: CalendarCellViewModelEntity) {
        dayLabel.text = "\(data.day)"
        
        if data.isHidden {
            dayLabel.alpha = 0.2
            self.isUserInteractionEnabled = false
        } else {
            dayLabel.alpha = 1.0
            layer.insertSublayer(smallPercentLineBackgroundLayer, at: 0)
        }
        
        if data.isToday {
            currentLineView.isHidden = false
        }
        if data.isSelected {
            selectedView.isHidden = false
        }
    }
    
    func configureLayerWithAnimation(_ data: CalendarCellViewModelEntity) {
        let circleAngleValue = Double.calculateCircleLineAngle(percent: data.percentValue)
        if data.percentValue != 0 {
            layer.insertSublayer(animatingPercentLineLayer, at: 0)
            animatingPercentLineLayer.lineWidth = 4
            animatingPercentLineLayer.strokeColor = data.layerColor
            animatingPercentLineLayer.path = circularPath.cgPath
            animatingPercentLineLayer.strokeStart = 0.0
            animatingPercentLineLayer.strokeEnd = 0.0
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = circleAngleValue
        if circleAngleValue < 0.4 {
            animation.duration = 1
        } else {
            animation.duration = 2
        }
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animatingPercentLineLayer.add(animation, forKey: "urSoBasic")
    }
    
    func configureLayer(_ data: CalendarCellViewModelEntity) {
        let circleAngleValue = Double.calculateCircleLineAngle(percent: data.percentValue)
        let endAngle = (-CGFloat.pi / 2) + ((450 * circleAngleValue * .pi)/180)
        lazy var newCircleAngle = UIBezierPath(arcCenter: .zero,
                                               radius: 15,
                                               startAngle: -CGFloat.pi / 2,
                                               endAngle: endAngle,
                                               clockwise: true)
        let color = data.layerColor
        if data.percentValue != 0 {
            self.layer.addSublayer(nonAnimatingPercentLineLayer)
            nonAnimatingPercentLineLayer.path = newCircleAngle.cgPath
            nonAnimatingPercentLineLayer.lineWidth = 4
            nonAnimatingPercentLineLayer.strokeColor = color
            nonAnimatingPercentLineLayer.strokeEnd = 1
        }
    }
}
