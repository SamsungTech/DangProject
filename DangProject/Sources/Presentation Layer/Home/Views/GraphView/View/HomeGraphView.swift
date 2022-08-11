//
//  HomeGraphCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import UIKit
import RxSwift

class HomeGraphView: UIView {
    static let identifier = "HomeGraphCell"
    private var viewModel: GraphViewModel
    private var disposeBag = DisposeBag()
    private var graphMainView = UIView()
    private var graphSegmentedControl = UISegmentedControl(items: ["Week", "Month", "Year"])
    private var graphBackgroundStackView = UIStackView()
    private var graphStackView = UIStackView()
    private var graphNameStackView = UIStackView()
    private var graphViewsArray: [UIView] = [ UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView() ]
    private var heightConstraintArray: [NSLayoutConstraint] = [ NSLayoutConstraint(), NSLayoutConstraint(),
                                                                NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(),
                                                                NSLayoutConstraint(), NSLayoutConstraint() ]
    private var graphLabelsArray: [UILabel] = [ UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel() ]
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        configure()
        layout()
        createGraphViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        graphMainView.viewRadius(cornerRadius: xValueRatio(20))
        bindGraphDataRelay()
        switchGraphViewAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeGraphView {
    private func configure() {
        graphMainView.backgroundColor = .homeBoxColor
        
        graphSegmentedControl.selectedSegmentIndex = 0
        graphSegmentedControl.tintColor = .systemYellow
        graphSegmentedControl.addTarget(self, action: #selector(switchGraphViews(_:)), for: .valueChanged)
        
        graphBackgroundStackView.backgroundColor = .clear
        graphBackgroundStackView.distribution = .fillEqually
        graphBackgroundStackView.spacing = xValueRatio(20)
        graphBackgroundStackView.axis = .horizontal
        
        graphStackView.backgroundColor = .clear
        graphStackView.spacing = xValueRatio(20)
        graphStackView.axis = .horizontal
        graphStackView.distribution = .fillProportionally
        graphStackView.alignment = .bottom
        
        graphNameStackView.backgroundColor = .clear
        graphNameStackView.axis = .horizontal
        graphNameStackView.distribution = .fillEqually
        createGraphLabels()
        createGraphBackgroundViews()
    }
    
    private func layout() {
        [ graphMainView ].forEach() { self.addSubview($0) }
        [ graphSegmentedControl, graphBackgroundStackView, graphNameStackView ].forEach() { graphMainView.addSubview($0) }
        graphBackgroundStackView.addSubview(graphStackView)
        
        graphMainView.translatesAutoresizingMaskIntoConstraints = false
        graphMainView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        graphMainView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        graphMainView.widthAnchor.constraint(equalToConstant: xValueRatio(350)).isActive = true
        graphMainView.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        
        graphSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        graphSegmentedControl.topAnchor.constraint(equalTo: graphMainView.topAnchor, constant: xValueRatio(10)).isActive = true
        graphSegmentedControl.centerXAnchor.constraint(equalTo: graphMainView.centerXAnchor).isActive = true
        graphSegmentedControl.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(20)).isActive = true
        graphSegmentedControl.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-20)).isActive = true
        graphSegmentedControl.heightAnchor.constraint(equalToConstant: yValueRatio(35)).isActive = true
        
        graphBackgroundStackView.translatesAutoresizingMaskIntoConstraints = false
        graphBackgroundStackView.topAnchor.constraint(equalTo: graphSegmentedControl.bottomAnchor, constant: yValueRatio(10)).isActive = true
        graphBackgroundStackView.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(20)).isActive = true
        graphBackgroundStackView.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-20)).isActive = true
        graphBackgroundStackView.bottomAnchor.constraint(equalTo: graphMainView.bottomAnchor, constant: yValueRatio(-50)).isActive = true
        
        graphStackView.translatesAutoresizingMaskIntoConstraints = false
        graphStackView.topAnchor.constraint(equalTo: graphBackgroundStackView.topAnchor).isActive = true
        graphStackView.leadingAnchor.constraint(equalTo: graphBackgroundStackView.leadingAnchor).isActive = true
        graphStackView.trailingAnchor.constraint(equalTo: graphBackgroundStackView.trailingAnchor).isActive = true
        graphStackView.bottomAnchor.constraint(equalTo: graphBackgroundStackView.bottomAnchor).isActive = true
        
        graphNameStackView.translatesAutoresizingMaskIntoConstraints = false
        graphNameStackView.topAnchor.constraint(equalTo: graphStackView.bottomAnchor).isActive = true
        graphNameStackView.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(10)).isActive = true
        graphNameStackView.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-10)).isActive = true
        graphNameStackView.bottomAnchor.constraint(equalTo: graphMainView.bottomAnchor, constant: yValueRatio(-10)).isActive = true
        
    }
    
    private func createGraphBackgroundViews() {
        for _ in 0..<7 {
            let view = UIView()
            view.backgroundColor = .init(red: 0,
                                         green: 0,
                                         blue: 0,
                                         alpha: 0.05)
            view.viewRadius(cornerRadius: xValueRatio(13))
            
            graphBackgroundStackView.addArrangedSubview(view)
        }
    }
    
    private func createGraphViews() {
        for i in 0...6 {
            graphViewsArray[i].backgroundColor = .white
            graphViewsArray[i].viewRadius(cornerRadius: xValueRatio(13))
            graphViewsArray[i].translatesAutoresizingMaskIntoConstraints = false
            heightConstraintArray[i] = graphViewsArray[i].heightAnchor.constraint(equalToConstant: 0)
            heightConstraintArray[i].isActive = true
            graphStackView.addArrangedSubview(graphViewsArray[i])
        }
    }
    
    private func createGraphLabels() {
        for i in 0...6 {
            graphLabelsArray[i].textColor = .white
            graphLabelsArray[i].font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
            graphLabelsArray[i].text = "없"
            graphLabelsArray[i].textAlignment = .center
            graphLabelsArray[i].translatesAutoresizingMaskIntoConstraints = false
            graphNameStackView.addArrangedSubview(graphLabelsArray[i])
        }
    }
    
    private func setupGraphViews(_ stringArray: [String]) {
        if stringArray.count != 0 {
            var array: [CGFloat] = []
            stringArray.forEach {
                array.append(CGFloat(Double($0) ?? 0))
            }
            animateGraphViews(array)
        } else {
            let array: [CGFloat] = [0,0,0,0,0,0,0]
            animateGraphViews(array)
        }
    }
    
    private func bindGraphDataRelay() {
        viewModel.graphDataRelay
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                switch self?.viewModel.graphDataTypeRelay.value {
                case .day:
                    strongSelf.setupGraphViews(data.dayArray)
                    guard let textArray = self?.viewModel.createGraphLabelText(.day) else { return }
                    strongSelf.animateGraphNameLabel(textArray)
                case .month:
                    strongSelf.setupGraphViews(data.monthArray)
                    guard let textArray = self?.viewModel.createGraphLabelText(.month) else { return }
                    strongSelf.animateGraphNameLabel(textArray)
                case .year:
                    strongSelf.setupGraphViews(data.yearArray)
                    guard let textArray = self?.viewModel.createGraphLabelText(.year) else { return }
                    strongSelf.animateGraphNameLabel(textArray)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func switchGraphViewAnimation() {
        viewModel.graphDataTypeRelay
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                switch $0 {
                case .day:
                    guard let data = self?.viewModel.graphDataRelay.value,
                          let textArray = self?.viewModel.createGraphLabelText(.day) else { return }
                    strongSelf.setupGraphViews(data.dayArray)
                    strongSelf.animateGraphNameLabel(textArray)
                case .month:
                    guard let data = self?.viewModel.graphDataRelay.value,
                          let textArray = self?.viewModel.createGraphLabelText(.month) else { return }
                    strongSelf.setupGraphViews(data.monthArray)
                    strongSelf.animateGraphNameLabel(textArray)
                case .year:
                    guard let data = self?.viewModel.graphDataRelay.value,
                          let textArray = self?.viewModel.createGraphLabelText(.year)  else { return }
                    strongSelf.setupGraphViews(data.yearArray)
                    strongSelf.animateGraphNameLabel(textArray)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func switchGraphViews(_ sender: UISegmentedControl) {
        viewModel.branchOutGraphDataType(sender.selectedSegmentIndex)
    }
    
    private func animateGraphViews(_ dataArray: [CGFloat]) {
        for i in 0...6 {
            heightConstraintArray[i].constant = xValueRatio(dataArray[i])
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
    
    private func animateGraphNameLabel(_ stringArray: [String]) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            for i in 0...6 {
                self?.graphLabelsArray[i].text = stringArray[i]
            }
        })
    }
}
