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
    private let week = [ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        configure()
        layout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        graphMainView.viewRadius(cornerRadius: xValueRatio(20))
        
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
        
        graphBackgroundStackView.backgroundColor = .clear
        graphBackgroundStackView.distribution = .fillEqually
        graphBackgroundStackView.spacing = xValueRatio(20)
        graphBackgroundStackView.axis = .horizontal
        
        graphStackView.backgroundColor = .clear
        graphStackView.spacing = xValueRatio(20)
        graphStackView.axis = .horizontal
        graphStackView.distribution = .fillProportionally
        graphStackView.alignment = .trailing
        
        graphNameStackView.backgroundColor = .clear
        graphNameStackView.spacing = xValueRatio(20)
        graphNameStackView.axis = .horizontal
        graphNameStackView.distribution = .fillEqually
        
        createGraphBackgroundViews()
        createGraphName()
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
    
    private func createGraphViews(items: GraphViewEntity) {
        var height: CGFloat?
        guard let items = items.weekDang else { return }
        for item in items {
            if Double(item)! > 30 {
                height = CGFloat(30)
            } else {
                height = CGFloat(Double(item)!)
            }
            let view = UIView()
            view.backgroundColor = .white
            view.viewRadius(cornerRadius: xValueRatio(13))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: (height ?? 0)*5).isActive = true
            
            graphStackView.addArrangedSubview(view)
        }
    }
    
    private func createGraphName() {
        for item in week {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
            label.text = item
            label.textAlignment = .center
            
            graphNameStackView.addArrangedSubview(label)
        }
    }
}
