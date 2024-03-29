
import UIKit

import RxSwift

class BatteryView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: BatteryViewModel
    private var circleProgressBarView = UIView()
    
    private var endCount: Int = 0
    private var currentCount: Int = 0
    private var timer = Timer()

    private var percentNumberLabel = UILabel()
    private var percentLabel = UILabel()
    private var targetSugarLabel = UILabel()
    
    private var animationLineLayer = CAShapeLayer()
    private var percentLineLayer = CAShapeLayer()
    private var percentLineBackgroundLayer = CAShapeLayer()
    var dataCheckDelegate: CheckDataProtocol?
    
    init(viewModel: BatteryViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        configure()
        circleConfigure()
        layout()
        bindTotalSugarSum()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .homeBoxColor
        circleProgressBarView.backgroundColor = .homeBoxColor
        self.roundCorners(cornerRadius: xValueRatio(30),
                          maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        
        percentNumberLabel.textColor = .customFontColorBlack
        percentNumberLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(50))
        percentNumberLabel.textAlignment = .right
        
        percentLabel.textColor = .customFontColorBlack
        percentLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(30))
        percentLabel.textAlignment = .center
        percentLabel.text = "%"
        
        targetSugarLabel.textColor = .customFontColorBlack
        targetSugarLabel.font = UIFont.systemFont(ofSize: xValueRatio(20))
    }
    
    private func layout() {
        [ circleProgressBarView ].forEach() { self.addSubview($0) }
        [ percentNumberLabel, percentLabel, targetSugarLabel ].forEach() { circleProgressBarView.addSubview($0) }
        
        circleProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        circleProgressBarView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        circleProgressBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        circleProgressBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        circleProgressBarView.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        
        percentNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        percentNumberLabel.centerXAnchor.constraint(equalTo: circleProgressBarView.centerXAnchor).isActive = true
        percentNumberLabel.centerYAnchor.constraint(equalTo: circleProgressBarView.centerYAnchor, constant: xValueRatio(-25)).isActive = true
        
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xValueRatio(55)).isActive = true
        percentLabel.bottomAnchor.constraint(equalTo: percentNumberLabel.bottomAnchor, constant: xValueRatio(-5)).isActive = true
        
        targetSugarLabel.translatesAutoresizingMaskIntoConstraints = false
        targetSugarLabel.topAnchor.constraint(equalTo: percentNumberLabel.bottomAnchor, constant: xValueRatio(5)).isActive = true
        targetSugarLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    private func circleConfigure() {
        [ animationLineLayer, percentLineBackgroundLayer, percentLineLayer ].forEach() { circleProgressBarView.layer.addSublayer($0) }
        
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: layerRadius(),
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        percentLineBackgroundLayer.path = circularPath.cgPath
        percentLineBackgroundLayer.fillColor = UIColor.clear.cgColor
        percentLineBackgroundLayer.lineWidth = 14
        percentLineBackgroundLayer.lineCap = .round
        percentLineBackgroundLayer.position = percentLayerPosition()
        
        animationLineLayer.path = circularPath.cgPath
        animationLineLayer.fillColor = UIColor.clear.cgColor
        animationLineLayer.lineWidth = 14
        animationLineLayer.lineCap = .round
        animationLineLayer.position = percentLayerPosition()
        
        percentLineLayer.path = circularPath.cgPath
        percentLineLayer.fillColor = UIColor.clear.cgColor
        percentLineLayer.lineWidth = 14
        percentLineLayer.lineCap = .round
        percentLineLayer.strokeEnd = 0
        percentLineLayer.position = percentLayerPosition()
    }
    
    private func bindTotalSugarSum() {
        viewModel.batteryEntityObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] totalSugarSum, targetSugar in
                self?.dataCheckDelegate?.checkData()
                let percentValue = Int.calculatePercentValue(dang: totalSugarSum, maxDang: Double(targetSugar))
                self?.targetSugarLabel.text = "목표: \(totalSugarSum)/\(targetSugar)"
                self?.configureLineLayerColor(totalSugar: totalSugarSum, targetSugar: targetSugar)
                self?.countAnimation(endCount: percentValue)
                self?.animatePulsatingLayer()
                self?.animateShapeLayer(circleAngleValue: Double.calculateCircleLineAngle(percent: percentValue))
            })
            .disposed(by: disposeBag)
    }
}

extension BatteryView {
    private func configureLineLayerColor(totalSugar: Double,
                                         targetSugar: Int) {
        let lineBackgroundColor = CGColor.calculateCircleProgressBackgroundColor(dang: totalSugar, maxDang: Double(targetSugar))
        let lineColor = CGColor.calculateCirclePercentLineColor(dang: totalSugar, maxDang: Double(targetSugar))
        let lineAnimationColor = CGColor.calculateCircleProgressBarColor(dang: totalSugar, maxDang: Double(targetSugar))
        percentLineLayer.strokeColor = lineColor
        percentLineBackgroundLayer.strokeColor = lineBackgroundColor
        animationLineLayer.strokeColor = lineAnimationColor
        
    }
    private func animateShapeLayer(circleAngleValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = circleAngleValue
        if circleAngleValue < 0.4 {
            animation.duration = 1
        } else {
            animation.duration = 2
        }
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
    
    private func countAnimation(endCount: Int) {
        self.timer.invalidate()
        self.endCount = endCount
        self.currentCount = 0
        if endCount > 50 {
            self.timer = Timer.scheduledTimer(timeInterval: 2/100,
                                              target: self,
                                              selector: #selector(self.updateNumber),
                                              userInfo: nil,
                                              repeats: true)
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 3/100,
                                              target: self,
                                              selector: #selector(self.updateNumber),
                                              userInfo: nil,
                                              repeats: true)
        }
        
    }
    
    @objc private func updateNumber() {
        self.percentNumberLabel.text = String(currentCount)
        currentCount += 1
        if currentCount > endCount {
            self.timer.invalidate()
            return
        }
    }
    
    private func percentLayerPosition() -> CGPoint {
        switch UIScreen.main.bounds.maxY {
        case 667.0:
            return CGPoint(x: xValueRatio(196.5), y: yValueRatio(150))
        default:
            return CGPoint(x: xValueRatio(196.5), y: yValueRatio(150))
        }
    }
    
    private func layerRadius() -> CGFloat {
        switch UIScreen.main.bounds.maxY {
        case 667.0:
            return xValueRatio(90)
        default:
            return xValueRatio(110)
        }
    }
}

