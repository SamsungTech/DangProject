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

enum ScrollDiection {
    case right
    case none
    case left
}

class BatteryView: UIView {
    static let identifier = "BatteryCell"
    var viewModel: BatteryCellViewModel?
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
    var calendarStackView = UIStackView()
    var calendarScrollView = UIScrollView()
    var scrollViewTopAnchor: NSLayoutConstraint?
    var calendarViews: [CalendarView] = []
    private var scrollDiection: ScrollDiection?
    
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
        calendarScrollView.do {
            $0.showsVerticalScrollIndicator = true
            $0.isPagingEnabled = true
            $0.contentSize = CGSize(width: UIScreen.main.bounds.maxX * 3, height: 300)
            $0.delegate = self
        }
    }
    
    private func layout() {
        calendarScrollView.addSubview(calendarStackView)
        [ circleProgressBarView, calendarScrollView ].forEach() { self.addSubview($0) }
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
        calendarScrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 290).isActive = true
            scrollViewTopAnchor = calendarScrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: -70)
            scrollViewTopAnchor?.isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
        calendarStackView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: calendarScrollView.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: calendarScrollView.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: calendarScrollView.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: calendarScrollView.bottomAnchor).isActive = true
        }
    }
    
    func circleConfigure() {
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
    func bind(viewModel: BatteryCellViewModel) {
        self.viewModel = viewModel
        subscribe()
        createStackView()
    }
    
    private func subscribe() {
        viewModel?.items
            .subscribe(onNext: { foodData in
                self.targetSugar.text = "목표: " + String(format: "%.1f", foodData.sum) + "/25.6g"
            })
            .disposed(by: disposeBag)
        
        viewModel?.batteryData
            .subscribe(onNext: { batteryData in
            })
            .disposed(by: disposeBag)
    }
    
    func createStackView() {
        for i in 0..<3 {
            guard let viewModel = self.viewModel else { return }
            let calendarView = CalendarView()
            calendarView.bind(viewModel: viewModel)
            calendarView.do {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.maxX).isActive = true
                $0.heightAnchor.constraint(equalToConstant: 300).isActive = true
                $0.backgroundColor = colors[i]
            }
            calendarViews.append(calendarView)
            calendarStackView.addArrangedSubview(calendarView)
        }
    }
}

extension BatteryView: UIScrollViewDelegate {
    
    // MARK: 무한 스크롤 캘린더 만들기
    // MARK: calendarUsecase에서 3개의 달력 데이터를 미리 끌고오고 담아놓고
    // MARK: 스크롤 할때마다 그 해당 앞 달이든 뒷 달이든 데이터를 불러와야됨
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch targetContentOffset.pointee.x {
        case 0:
            scrollDiection = .left
            let centerView = calendarViews[1]
//            centerView.viewModel?.batteryData.accept(<#T##event: BatteryEntity##BatteryEntity#>)
            print("왼쪽")
        case self.frame.width * CGFloat(1):
            break
        case self.frame.width * CGFloat(2):
            scrollDiection = .right
            print("오른쪽")
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDiection {
        case .left:
            print("왼쪽")
            updateCalendar()
        case .none:
            break
        case .right:
            print("오른쪽")
            updateCalendar()
        default:
            break
        }
    }
}

extension BatteryView {
    private func updateCalendar() {
        let centerPoint = CGPoint(x: self.frame.width, y: .zero)
        calendarScrollView.setContentOffset(centerPoint, animated: false)
    }
    
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
