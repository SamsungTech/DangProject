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
    private var homeViewController: HomeViewController?
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
    var circleProgressBarTopAnchor: NSLayoutConstraint?
    var calendarViewTopAnchor: NSLayoutConstraint?
    private var scrollDirection: ScrollDirection?
    private var currentPoint: CGFloat = 0
    
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
        circleConfigure()
        backgroundColor = .systemYellow
        bringSubviewToFront(circleProgressBarView)
        animatePulsatingLayer()
        animateShapeLayer()
        countAnimation()
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
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xValueRatio(50)).isActive = true
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
        [ pulsatingLayer, trackLayer, shapeLayer ].forEach() { circleProgressBarView.layer.addSublayer($0) }

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
            $0.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
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
            $0.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        }
        shapeLayer.do {
            $0.path = circularPath.cgPath
            $0.strokeColor = UIColor.white.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = 14
            $0.lineCap = .round
            $0.strokeEnd = 0
            $0.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        }
    }
}

extension BatteryView {
    func bind(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        subscribe()
    }
    
    private func subscribe() {
        homeViewController?.viewModel?.sumData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.targetSugar.text = "목표: " + String(format: "%.1f", data.sum) + "/25.6g"
            })
            .disposed(by: disposeBag)
    }
}

extension BatteryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let count = homeViewController?.viewModel?.retriveBatteryData().calendar?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let calendarCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.identifier,
            for: indexPath
        ) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        
        if let data = homeViewController?.viewModel?.retriveBatteryData().calendar?[indexPath.item] {
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
    private func updateCalendarPoint() {
        switch scrollDirection {
        case .left:
            let centerPoint = CGPoint(x: UIScreen.main.bounds.maxX, y: .zero)
            self.calendarCollectionView.setContentOffset(centerPoint, animated: false)
        case .center:
            break
        case .right:
            let calendarCount = homeViewController?.viewModel?.retriveBatteryData().calendar?.count ?? 0
            let count = calendarCount - 2
            let centerPoint = CGPoint(x: UIScreen.main.bounds.maxX * CGFloat(count), y: .zero)
            self.calendarCollectionView.setContentOffset(centerPoint, animated: false)
        default:
            break
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let count = homeViewController?.viewModel?.retriveBatteryData().calendar?.count else { return }
        currentPoint = targetContentOffset.pointee.x
        
        if currentPoint <= 0 {
            scrollDirection = .left
        } else if currentPoint >= UIScreen.main.bounds.maxX * CGFloat(count-1) {
            scrollDirection = .right
        } else {
            scrollDirection = .center
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDirection {
        case .left:
            homeViewController?.viewModel?.scrolledCalendarToLeft()
            calendarCollectionView.reloadData()
            updateCalendarPoint()
            calculateCurrentPoint(point: currentPoint)
        case .center:
            calculateCurrentPoint(point: currentPoint)
            break
        case .right:
            homeViewController?.viewModel?.scrolledCalendarToRight()
            calendarCollectionView.reloadData()
            updateCalendarPoint()
            calculateCurrentPoint(point: currentPoint)
        default:
            break
        }
    }
    
    private func calculateCurrentPoint(point: CGFloat) {
        let maxXValue = UIScreen.main.bounds.maxX
        let result = point / maxXValue
        
        switch scrollDirection {
        case .left:
            homeViewController?.viewModel?.currentXPoint.accept(1)
            break
        case .right:
            guard let number = homeViewController?.viewModel?.retriveBatteryData().calendar?.count else { return }
            homeViewController?.viewModel?.currentXPoint.accept(Int(number-2))
            break
        case .center:
            homeViewController?.viewModel?.currentXPoint.accept(Int(result))
            break
        case .none:
            break
        }
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
