//
//  CalendarCollectionViewCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/17.
//

import Foundation
import UIKit
import RxSwift

class DaysCollectionViewCell: UICollectionViewCell {
    static let identifier = "DaysCollectionViewCell"
    var viewModel: DaysCellViewModel?
    private var disposeBag = DisposeBag()
    var dayLabel = UILabel()
    var selectedView = UIView()
    var selectedLineView = UIView()
    private let smallPercentLineLayer = CAShapeLayer()
    private let smallPercentLineBackgroundLayer = CAShapeLayer()
    private let circularPath = UIBezierPath(arcCenter: .zero,
                                            radius: 15,
                                            startAngle: -CGFloat.pi / 2,
                                            endAngle: 2 * CGFloat.pi,
                                            clockwise: true)
    private var isAnimationExecute = false
    private var currentDayBackground = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        configure()
        layout()
        self.bringSubviewToFront(currentDayBackground)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dayLabel.do {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
        }
        smallPercentLineLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.customCircleColor(.circleColorYellow).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 4
            $0.lineCap = .round
            $0.position = CGPoint(x: 28, y: 40)
            $0.strokeStart = 0.0
            $0.strokeEnd = 0.1
        }
        smallPercentLineBackgroundLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.customSmallCircleBackgroundColor(.smallCircleBackgroundColorYellow).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 4
            $0.lineCap = .round
            $0.position = CGPoint(x: 28, y: 40)
        }
        selectedView.do {
            $0.backgroundColor = .init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0)
            $0.viewRadius(cornerRadius: 11)
        }
        selectedLineView.do {
            $0.backgroundColor = .clear
            $0.layer.borderColor = .init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0)
            $0.layer.borderWidth = 3
            $0.viewRadius(cornerRadius: 15)
        }
    }
    
    private func layout() {
        [ selectedLineView, selectedView, dayLabel ].forEach() { contentView.addSubview($0) }
        [ smallPercentLineBackgroundLayer, smallPercentLineLayer ].forEach() { contentView.layer.addSublayer($0) }
        
        dayLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        selectedView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        }
        selectedLineView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    func bind(viewModel: DaysCellViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.days
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dayLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        viewModel?.isHidden
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let dayLabel = self?.dayLabel,
                      let lineLayer = self?.smallPercentLineLayer,
                      let lineBackgroundLayer = self?.smallPercentLineBackgroundLayer else { return }
                self?.viewModel?.calculateAlphaHiddenValues($0,
                                                            label: dayLabel,
                                                            Layer: lineLayer,
                                                            backgroundLayer: lineBackgroundLayer)
            })
            .disposed(by: disposeBag)
        
        viewModel?.isCurrentDay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let currentBackgroundView = self?.currentDayBackground else { return }
                self?.viewModel?.calculateCurrentDayAlphaValues($0,
                                                                currentBackgroundView)
            })
            .disposed(by: disposeBag)
        
        viewModel?.circleColor
            .subscribe(onNext: { [weak self] in
                self?.smallPercentLineLayer.strokeColor = $0
            })
            .disposed(by: disposeBag)
        
        viewModel?.circleNumber
            .subscribe(onNext: { [weak self] in
                self?.smallPercentLineLayer.strokeEnd = $0
            })
            .disposed(by: disposeBag)
    }
    
    func animateShapeLayer() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 0.8
        animation.duration = 2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        smallPercentLineLayer.add(animation, forKey: "urSoBasic")
    }
}
