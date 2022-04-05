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
    private var dayLabel = UILabel()
    var selectedView = UIView()
    var currentLineView = UIView()
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
        dayLabel.textColor = .white
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
        
        smallPercentLineLayer.path = circularPath.cgPath
        smallPercentLineLayer.strokeColor = UIColor.circleColorYellow.cgColor
        smallPercentLineLayer.fillColor = UIColor.clear.cgColor
        smallPercentLineLayer.lineWidth = 4
        smallPercentLineLayer.lineCap = .round
        smallPercentLineLayer.position = CGPoint(x: 28, y: 40)
        smallPercentLineLayer.strokeStart = 0.0
        smallPercentLineLayer.strokeEnd = 0.1
        
        smallPercentLineBackgroundLayer.path = circularPath.cgPath
        smallPercentLineBackgroundLayer.strokeColor = UIColor.smallCircleBackgroundColorYellow.cgColor
        smallPercentLineBackgroundLayer.fillColor = UIColor.clear.cgColor
        smallPercentLineBackgroundLayer.lineWidth = 4
        smallPercentLineBackgroundLayer.lineCap = .round
        smallPercentLineBackgroundLayer.position = CGPoint(x: 28, y: 40)
        
        selectedView.viewRadius(cornerRadius: 11)
        
        currentLineView.backgroundColor = .clear
        currentLineView.layer.borderWidth = 3
        currentLineView.viewRadius(cornerRadius: 15)
        
    }
    
    private func layout() {
        [ currentLineView, selectedView, dayLabel ].forEach() { contentView.addSubview($0) }
        [ smallPercentLineBackgroundLayer, smallPercentLineLayer ].forEach() { contentView.layer.addSublayer($0) }
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        selectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
        selectedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3).isActive = true
        selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
        currentLineView.translatesAutoresizingMaskIntoConstraints = false
        currentLineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        currentLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        currentLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        currentLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
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
}
