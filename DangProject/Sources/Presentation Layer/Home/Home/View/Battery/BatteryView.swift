//
//  BatteryCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import UIKit

import RxSwift

class BatteryView: UIView {
    private var viewModel: HomeViewModelProtocol?
    private var disposeBag = DisposeBag()
    private var gradient = CAGradientLayer()
    private var circleProgressBarView = UIView()
    private var endCount: Int = 0
    private var currentCount: Int = 0
    private var timer = Timer()
    private var batteryCalendarDataCount = 0
    private var mainProgressBarDangValue: CGFloat = 0
    var targetNumber = UILabel()
    var percentLabel = UILabel()
    var targetSugar = UILabel()
    var animationLineLayer = CAShapeLayer()
    var percentLineLayer = CAShapeLayer()
    var percentLineBackgroundLayer = CAShapeLayer()
    var targetNumberTopAnchor: NSLayoutConstraint?
    var circleProgressBarTopAnchor: NSLayoutConstraint?
    var calendarViewTopAnchor: NSLayoutConstraint?
    
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
        backgroundColor = .homeBoxColor
        bringSubviewToFront(circleProgressBarView)
        animatePulsatingLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        circleProgressBarView.backgroundColor = .homeBoxColor
        
        targetNumber.textColor = .white
        targetNumber.font = UIFont.boldSystemFont(ofSize: xValueRatio(50))
        targetNumber.textAlignment = .right
        
        percentLabel.textColor = .white
        percentLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(30))
        percentLabel.textAlignment = .center
        percentLabel.text = "%"
        
        targetSugar.textColor = .white
        targetSugar.font = UIFont.systemFont(ofSize: xValueRatio(20))
        targetSugar.text = "암것도없네"
        
        calendarCollectionView.register(CalendarCollectionViewCell.self,
                                        forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.backgroundColor = .homeBackgroundColor
        
    }
    
    private func layout() {
        [ calendarCollectionView, circleProgressBarView ].forEach() { self.addSubview($0) }
        [ targetNumber, percentLabel, targetSugar ].forEach() { circleProgressBarView.addSubview($0) }
        
        circleProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        circleProgressBarTopAnchor = circleProgressBarView.topAnchor.constraint(equalTo: self.topAnchor, constant: yValueRatio(170))
        circleProgressBarTopAnchor?.isActive = true
        circleProgressBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        circleProgressBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        circleProgressBarView.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        
        targetNumber.translatesAutoresizingMaskIntoConstraints = false
        targetNumber.centerXAnchor.constraint(equalTo: circleProgressBarView.centerXAnchor).isActive = true
        targetNumber.centerYAnchor.constraint(equalTo: circleProgressBarView.centerYAnchor, constant: xValueRatio(-25)).isActive = true
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xValueRatio(55)).isActive = true
        percentLabel.bottomAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: xValueRatio(-5)).isActive = true
        
        targetSugar.translatesAutoresizingMaskIntoConstraints = false
        targetSugar.topAnchor.constraint(equalTo: targetNumber.bottomAnchor, constant: xValueRatio(5)).isActive = true
        targetSugar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.heightAnchor.constraint(equalToConstant: yValueRatio(360)).isActive = true
        calendarViewTopAnchor = calendarCollectionView.topAnchor.constraint(equalTo: self.topAnchor)
        calendarViewTopAnchor?.isActive = true
        calendarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        calendarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    private func circleConfigure() {
        [ animationLineLayer, percentLineBackgroundLayer, percentLineLayer ].forEach() { circleProgressBarView.layer.addSublayer($0) }

        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 110,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        percentLineBackgroundLayer.path = circularPath.cgPath
        percentLineBackgroundLayer.strokeColor = UIColor.circleBackgroundColorYellow.cgColor
        percentLineBackgroundLayer.fillColor = UIColor.clear.cgColor
        percentLineBackgroundLayer.lineWidth = 14
        percentLineBackgroundLayer.lineCap = .round
        percentLineBackgroundLayer.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        
        animationLineLayer.path = circularPath.cgPath
        animationLineLayer.strokeColor = UIColor.circleAnimationColorYellow.cgColor
        animationLineLayer.fillColor = UIColor.clear.cgColor
        animationLineLayer.lineWidth = 14
        animationLineLayer.lineCap = .round
        animationLineLayer.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
        
        percentLineLayer.path = circularPath.cgPath
        percentLineLayer.strokeColor = UIColor.circleColorYellow.cgColor
        percentLineLayer.fillColor = UIColor.clear.cgColor
        percentLineLayer.lineWidth = 14
        percentLineLayer.lineCap = .round
        percentLineLayer.strokeEnd = 0
        percentLineLayer.position = CGPoint(x: xValueRatio(200), y: yValueRatio(150))
    }
}

extension BatteryView {
    func bind(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        bindBatteryCalendarData()
        bindReloadData()
        bindPagingState()
    }
    
    private func bindBatteryCalendarData() {
        viewModel?.dangComprehensiveData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let sugarSum = $0.todaySugarSum else { return }
                self?.targetSugar.text = "목표: " + String(format: "%.1f") +  sugarSum + "/25.6g"
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
            })
            .disposed(by: disposeBag)
    }
    
    private func bindPagingState() {
        viewModel?.pagingState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .left:
                    UIView.performWithoutAnimation {
                        self?.calendarCollectionView.insertItems(at: [.init(item: 0, section: 0)])
                        self?.calendarCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                                                  at: .centeredHorizontally,
                                                                  animated: false)
                        self?.calendarCollectionView.reloadItems(at: [.init(item: 0, section: 0)])
                    }
                case .right(let index):
                    self?.calendarCollectionView.insertItems(at: [.init(item: index, section: 0)])
                    self?.calendarCollectionView.reloadItems(at: [.init(item: index, section: 0)])
                case .empty: break
                }
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
    
    func animatePulsatingLayer() {
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
