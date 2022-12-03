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
    private var averageGramBottomAnchorConstants: [NSLayoutConstraint] = []
    private var graphBackgroundViews: [UIView] = []
    private var graphLabels: [UILabel] = []
    private var averageGramLabels: [UILabel] = []
    
    init(viewModel: GraphViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        createDefaultGraph()
        layout()
        configure()
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
        graphStackView.distribution = .fillEqually
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
        createAverageGramLabel()
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
            graphView.backgroundColor = .customLabelColorBlack
            graphView.viewRadius(cornerRadius: xValueRatio(13))
            graphView.translatesAutoresizingMaskIntoConstraints = false
            graphHeightConstants.append(graphView.heightAnchor.constraint(equalToConstant: 0))
            graphHeightConstants[i].isActive = true
            graphStackView.addArrangedSubview(graphView)
        }
    }
    
    private func createGraphLabel() {
        for _ in 0 ..< 7 {
            let label = UILabel()
            label.textColor = .customFontColorBlack
            label.textAlignment = .center
            label.numberOfLines = 0
            graphLabels.append(label)
            graphNameStackView.addArrangedSubview(label)
        }
    }
    
    private func createAverageGramLabel() {
        for i in 0 ..< 7 {
            let label = UILabel()
            label.textColor = .customFontColorGray
            label.textAlignment = .center
            graphBackgroundViews[i].addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            averageGramBottomAnchorConstants.append(label.bottomAnchor.constraint(equalTo: graphBackgroundViews[i].bottomAnchor, constant: 0))
            averageGramBottomAnchorConstants[i].isActive = true
            averageGramLabels.append(label)
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
            let averageGramString = "\(Double(graphData[i].1).roundDecimal(to: 1))g"
            graphHeightConstants[i].constant = viewModel.configureGraphHeightConstant(self, sugarValue: graphData[i].1)
            graphLabels[i].text = graphData[i].0
            graphLabels[i].font = viewModel.configureGraphLabelFontSize(self, graphDataString: graphData[i].0)
            averageGramLabels[i].text = averageGramString
            averageGramLabels[i].font = viewModel.configureAverageGramLabelFontSize(self, graphDataString: averageGramString)
            averageGramBottomAnchorConstants[i].constant = -(viewModel.configureGraphHeightConstant(self, sugarValue: graphData[i].1) + yValueRatio(5))
        }
        self.bringSubviewToFront(graphStackView)
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
}
