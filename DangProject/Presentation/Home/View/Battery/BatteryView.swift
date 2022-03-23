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

class BatteryView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: HomeViewModel?
    private var mainView = UIView()
    private var gradient = CAGradientLayer()
    
    private var circleProgressBarView = UIView()
    var targetNumber = UILabel()
    var percentLabel = UILabel()
    var targetSugar = UILabel()
    var animationLineLayer = CAShapeLayer()
    var percentLineLayer = CAShapeLayer()
    var percentLineBackgroundLayer = CAShapeLayer()
    
    private var endCount: Int = 0
    private var currentCount: Int = 0
    private var timer = Timer()
    var targetNumberTopAnchor: NSLayoutConstraint?
    var circleProgressBarTopAnchor: NSLayoutConstraint?
    var calendarViewTopAnchor: NSLayoutConstraint?
    
    private var batteryCalendarDataCount = 0
    
    private var mainProgressBarDangValue: CGFloat = 0
    
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isPrefetchingEnabled = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
        circleConfigure()
        backgroundColor = .customHomeColor(.homeBoxColor)
        bringSubviewToFront(circleProgressBarView)
        animatePulsatingLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        circleProgressBarView.do {
            $0.backgroundColor = .customHomeColor(.homeBoxColor)
        }
        targetNumber.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(50))
            $0.textAlignment = .right
        }
        percentLabel.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(30))
            $0.textAlignment = .center
            $0.text = "%"
        }
        targetSugar.do {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: xValueRatio(20))
            $0.text = "암것도없네"
        }
        calendarCollectionView.do {
            $0.register(CalendarCollectionViewCell.self,
                        forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .customHomeColor(.homeBackgroundColor)
        }
    }
    
    private func layout() {
        [ calendarCollectionView, circleProgressBarView ].forEach() { self.addSubview($0) }
        [ targetNumber, percentLabel, targetSugar ].forEach() { circleProgressBarView.addSubview($0) }
        
        circleProgressBarView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            circleProgressBarTopAnchor = circleProgressBarView.topAnchor.constraint(equalTo: self.topAnchor, constant: yValueRatio(170))
            circleProgressBarTopAnchor?.isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        }
        targetNumber.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: circleProgressBarView.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: circleProgressBarView.centerYAnchor, constant: xValueRatio(-25)).isActive = true
        }
        percentLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xValueRatio(55)).isActive = true
            $0.bottomAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: xValueRatio(-5)).isActive = true
        }
        targetSugar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: xValueRatio(5)).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        calendarCollectionView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(360)).isActive = true
            calendarViewTopAnchor = calendarCollectionView.topAnchor.constraint(equalTo: self.topAnchor)
            calendarViewTopAnchor?.isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
    }
    
    private func circleConfigure() {
        [ animationLineLayer, percentLineBackgroundLayer, percentLineLayer ].forEach() { circleProgressBarView.layer.addSublayer($0) }

        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 110,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        percentLineBackgroundLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.customCircleBackgroundColor(.circleBackgroundColorYellow).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        }
        animationLineLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.customCircleAnimationColor(.circleAnimationColorYellow).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        }
        percentLineLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.customCircleColor(.circleColorYellow).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.strokeEnd = 0
            $0.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        }
    }
}

extension BatteryView {
    func bind(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        subscribe()
        bindReloadData()
        bindPagingState()
    }
    
    private func subscribe() {
        viewModel?.sumData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.targetSugar.text = "목표: " + String(format: "%.1f", $0.sum) + "/25.6g"
            })
            .disposed(by: disposeBag)
        
        viewModel?.batteryViewCalendarData
            .subscribe(onNext: { [weak self] in
                self?.batteryCalendarDataCount = $0.count
            })
            .disposed(by: disposeBag)
    }
    
    private func bindReloadData() {
        viewModel?.reloadData
            .subscribe(onNext: { [weak self] in
                self?.calendarCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func bindPagingState() {
        viewModel?.pagingState
            .subscribe(onNext: { [weak self] in
                guard let batteryView = self else { return }
                self?.viewModel?.handlePagingState($0, view: batteryView)
            })
            .disposed(by: disposeBag)
    }
}

extension BatteryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.batteryViewCalendarData.value.count else { return 3 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier,
                                                                    for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        if let data = viewModel?.batteryViewCalendarData.value[indexPath.item],
           let homeViewModel = self.viewModel {
            let viewModel = CalendarViewModel(calendarData: data)
            calendarCell.bind(viewModel: viewModel, homeViewModel: homeViewModel)
        }
        return calendarCell
    }
}

extension BatteryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.maxX,
                      height: yValueRatio(360))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension BatteryView {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        viewModel?.giveDirections(currentPoint: targetContentOffset.pointee.x)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel?.calculateAfterSettingDirection()
    }
}


extension BatteryView {
    func animateShapeLayer(_ circleDangValue: CGFloat,
                           _ duration: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = circleDangValue
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        percentLineLayer.add(animation, forKey: "urSoBasic")
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.115
        animation.duration = 1
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.infinity
        animationLineLayer.add(animation, forKey: "plusing")
    }
    
    func countAnimation(_ endCount: Int) {
        self.timer.invalidate()
        DispatchQueue.main.async {
            self.endCount = endCount
            self.currentCount = 0
            self.timer = Timer.scheduledTimer(timeInterval: 3/100,
                                              target: self,
                                              selector: #selector(BatteryView.updateNumber),
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
