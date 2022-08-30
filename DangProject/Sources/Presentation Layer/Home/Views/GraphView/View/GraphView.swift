//
//  GraphView.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import UIKit

import RxSwift
import RxRelay

class GraphView: UIView {
    
    private var viewModel: GraphViewModelProtocol
    private var disposeBag = DisposeBag()
    private var graphMainView = UIView()
    private var graphSegmentedControl = UISegmentedControl(items: ["Daily", "Weekly", "Monthly"])
    private var graphBackgroundStackView = UIStackView()
    private var graphStackView = UIStackView()
    private var graphNameStackView = UIStackView()
    
    private var graphHeightConstants: [NSLayoutConstraint] = []
    private var graphBackgroundViews: [UIView] = []
    private var graphViews: [UIView] = []
    private var graphLabels: [UILabel] = []
    private var gramLabels: [UILabel] = []
    
    init(viewModel: GraphViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        layout()
        configure()
        createDefaultGraph()
        bindingGraphDatas()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        graphMainView.viewRadius(cornerRadius: xValueRatio(20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        graphMainView.backgroundColor = .homeBoxColor
        
        graphSegmentedControl.selectedSegmentIndex = 0
        graphSegmentedControl.tintColor = .systemYellow
        graphSegmentedControl.addTarget(self, action: #selector(graphSegmentedControlDidChange(_:)), for: .valueChanged)
        
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
        graphNameStackView.spacing = xValueRatio(20)
        graphNameStackView.axis = .horizontal
        graphNameStackView.distribution = .fillEqually
    }
    
    @objc private func graphSegmentedControlDidChange(_ sender: UISegmentedControl) {
        viewModel.changeGraphView(to: sender.selectedSegmentIndex)
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
        graphNameStackView.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(20)).isActive = true
        graphNameStackView.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-20)).isActive = true
        graphNameStackView.bottomAnchor.constraint(equalTo: graphMainView.bottomAnchor, constant: yValueRatio(-10)).isActive = true
    }
    
    private func createDefaultGraph() {
        createGraphBackgroundViews()
        createGraphViews()
        createGraphLabel()
    }

    private func createGraphBackgroundViews() {
        for _ in 0 ..< 7 {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .init(red: 0,
                                         green: 0,
                                         blue: 0,
                                         alpha: 0.1)
            backgroundView.viewRadius(cornerRadius: xValueRatio(13))
            graphBackgroundViews.append(backgroundView)
            graphBackgroundStackView.addArrangedSubview(backgroundView)
        }
    }
    
    private func createGraphViews() {
        for i in 0 ..< 7 {
            let graphView = UIView()
            graphView.backgroundColor = .white
            graphView.viewRadius(cornerRadius: xValueRatio(13))
            graphView.translatesAutoresizingMaskIntoConstraints = false
            graphViews.append(graphView)
            graphHeightConstants.append(graphView.heightAnchor.constraint(equalToConstant: 0))
            graphHeightConstants[i].isActive = true
            graphStackView.addArrangedSubview(graphView)
        }
    }
    
    private func createGraphLabel() {
        for _ in 0 ..< 7 {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            graphLabels.append(label)
            graphNameStackView.addArrangedSubview(label)
        }
    }
    
    private func createAverageGramLabel(_ graphData: [(String, CGFloat)]) {
        if gramLabels.isEmpty == false {
            gramLabels.forEach { gramLabel in
                gramLabel.removeFromSuperview()
            }
            gramLabels.removeAll()
        }
        for i in 0 ..< 7 {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = "\(Double(graphData[i].1).roundDecimal(to: 1))g"
            graphBackgroundViews[i].addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.bottomAnchor.constraint(equalTo: graphViews[i].topAnchor, constant: -yValueRatio(5)).isActive = true
            gramLabels.append(label)
        }
    }
    
    private func bindingGraphDatas() {
        viewModel.graphDataRelay
            .subscribe(onNext: { [weak self] dailyData in
                self?.animateGraphView(dailyData)
            })
            .disposed(by: disposeBag)
    }
    
    private func animateGraphView(_ graphData: [(String, CGFloat)]) {
        for i in 0 ..< graphData.count {
            graphHeightConstants[i].constant = viewModel.configureGraphHeightConstant(self, sugarValue: graphData[i].1)
            graphLabels[i].text = graphData[i].0
            graphLabels[i].font = viewModel.configureGraphLabelFontSize(self, graphDataString: graphData[i].0)
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
        { [weak self] _ in
            self?.createAverageGramLabel(graphData)
        }
    }
    
}
