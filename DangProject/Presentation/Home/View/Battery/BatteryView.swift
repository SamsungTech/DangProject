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
    static let identifier = "BatteryCell"
    var viewModel: BatteryViewModel?
    private var disposeBag = DisposeBag()
    private var mainView = UIView()
    private var gradient = CAGradientLayer()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    private var circleProgressBarView = UIView()
    var targetNumber = UILabel()
    var percentLabel = UILabel()
    var targetSugar = UILabel()
    private var pulsatingLayer = CAShapeLayer()
    
    private var endCount: Int = 0
    private var currentCount: Int = 0
    private var timer = Timer()
    var targetNumberTopAnchor: NSLayoutConstraint?
    var cirlceProgressBarTopAnchor: NSLayoutConstraint?
    
    var calendarViewTopAnchor: NSLayoutConstraint?
    
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    let colors: [UIColor] = [ .systemGreen, .systemYellow, .systemBlue ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        circleConfigure()
        configure()
        backgroundColor = .systemYellow
        bringSubviewToFront(circleProgressBarView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        circleProgressBarView.do {
            $0.backgroundColor = .systemYellow
        }
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
            $0.text = "암것도없네"
        }
        calendarCollectionView.do {
            $0.register(CalendarCollectionViewCell.self,
                        forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func layout() {
        [ calendarCollectionView, circleProgressBarView ].forEach() { self.addSubview($0) }
        [ targetNumber, percentLabel, targetSugar ].forEach() { circleProgressBarView.addSubview($0) }
        
        circleProgressBarView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            cirlceProgressBarTopAnchor = circleProgressBarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 170)
            cirlceProgressBarTopAnchor?.isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
        targetNumber.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: circleProgressBarView.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: circleProgressBarView.centerYAnchor, constant: -25).isActive = true
        }
        percentLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 50).isActive = true
            $0.bottomAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: -5).isActive = true
        }
        targetSugar.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: 5).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        calendarCollectionView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 290).isActive = true
            calendarViewTopAnchor = calendarCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: -70)
            calendarViewTopAnchor?.isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
    }
    
    private func circleConfigure() {
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 110,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        trackLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.init(red: 255/255,
                                          green: 244/255,
                                          blue: 109/255,
                                          alpha: 1).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.position = CGPoint(x: 200, y: 150)
        }
        pulsatingLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.init(red: 1,
                                          green: 1,
                                          blue: 1,
                                          alpha: 0.3).cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.position = CGPoint(x: 200, y: 150)
        }
        shapeLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.white.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.strokeEnd = 0
            $0.position = CGPoint(x: 200, y: 150)
        }
        
        [ pulsatingLayer, trackLayer, shapeLayer ].forEach() { circleProgressBarView.layer.addSublayer($0) }
        
        animatePulsatingLayer()
        animateShapeLayer()
        countAnimation()
    }
}

extension BatteryView {
    func bind(viewModel: BatteryViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] foodData in
                self?.targetSugar.text = "목표: " + String(format: "%.1f", foodData.sum) + "/25.6g"
            })
            .disposed(by: disposeBag)
        
        viewModel?.batteryData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] batteryData in
                self?.calendarCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension BatteryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.batteryData.value.calendar?.count else { return 0 }
        
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let calendarCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.identifier,
            for: indexPath
        ) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        
        if let data = viewModel?.batteryData.value.calendar?[indexPath.item] {
            let viewModel = CalendarViewModel(calendarData: CalendarStackViewEntity(calendar: data))
            calendarCell.bind(viewModel: viewModel)
        }
        
        return calendarCell
    }
}

extension BatteryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: <#T##CGFloat#>,
                      height: <#T##CGFloat#>)
    }
}

extension BatteryView {
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
