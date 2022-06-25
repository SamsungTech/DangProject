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
    
    private let smallPercentLineLayer = CAShapeLayer()
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
        dayLabel.attributedText = nil
        smallPercentLineLayer.removeFromSuperlayer()
        smallPercentLineBackgroundLayer.removeFromSuperlayer()
//        smallPercentLineLayer.isHidden = true
//        smallPercentLineBackgroundLayer.isHidden = true

        currentLineView.isHidden = true
    }
    
    private func configure() {
        self.backgroundColor = .homeBackgroundColor
        
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
        dayLabel.textColor = .white
        
        smallPercentLineLayer.path = circularPath.cgPath
        smallPercentLineLayer.fillColor = UIColor.clear.cgColor
        smallPercentLineLayer.lineCap = .round
        smallPercentLineLayer.position = CGPoint(x: 28, y: 40)
        smallPercentLineLayer.strokeStart = 0.0
        smallPercentLineLayer.strokeEnd = 0.1
        
        smallPercentLineBackgroundLayer.path = circularPath.cgPath
        smallPercentLineBackgroundLayer.fillColor = UIColor.clear.cgColor
        smallPercentLineBackgroundLayer.strokeColor = UIColor.smallCircleBackgroundColorGray.cgColor
        smallPercentLineBackgroundLayer.lineCap = .round
        smallPercentLineBackgroundLayer.position = CGPoint(x: 28, y: 40)
        smallPercentLineBackgroundLayer.lineWidth = 4
        
        selectedView.viewRadius(cornerRadius: 11)
        
        currentLineView.layer.borderColor = UIColor.currentDayCellLineViewColor
        currentLineView.backgroundColor = .clear
        currentLineView.layer.borderWidth = 3
        currentLineView.viewRadius(cornerRadius: 15)
    }
    
    private func configureLayer() {
        [ smallPercentLineBackgroundLayer, smallPercentLineLayer ].forEach() { contentView.layer.addSublayer($0) }
    }
    private func layout() {
        [ currentLineView, selectedView, dayLabel ].forEach() { contentView.addSubview($0) }
        
//        [ smallPercentLineBackgroundLayer, smallPercentLineLayer ].forEach() { contentView.layer.addSublayer($0) }
//        smallPercentLineLayer.isHidden = true
//        smallPercentLineBackgroundLayer.isHidden = true
        
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
        } else {
            dayLabel.alpha = 1.0
//            smallPercentLineLayer.isHidden = false
//            smallPercentLineBackgroundLayer.isHidden = false
            configureLayer()
            layer.insertSublayer(smallPercentLineLayer, at: 0)
            layer.insertSublayer(smallPercentLineBackgroundLayer, at: 0)
        }
        
        if data.isToday {
//            layer.insertSublayer(smallPercentLineLayer, at: 0)
            currentLineView.isHidden = false
        }
        if data.isSelected {
            
        }
    }
    
    func configureShapeLayer(data: CalendarCellViewModelEntity) {
        let circleAngleValue = Double.calculateCircleLineAngle(percent: data.percentValue)
        if data.percentValue == 0 {
            smallPercentLineLayer.lineWidth = 0
        } else {
            smallPercentLineLayer.lineWidth = 4
            smallPercentLineLayer.strokeColor = data.layerColor
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
        smallPercentLineLayer.add(animation, forKey: "urSoBasic")
        
    }
}
