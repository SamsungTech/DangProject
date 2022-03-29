//
//  HomeGraphCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit
import Then
import RxSwift

class HomeGraphView: UIView {
    static let identifier = "HomeGraphCell"
    private var viewModel: GraphViewModel?
    private var disposeBag = DisposeBag()
    private var graphMainView = UIView()
    private var graphSegmentedControl = UISegmentedControl(items: ["Week", "Mouth", "Year"])
    private var graphBackgroundStackView = UIStackView()
    private var graphStackView = UIStackView()
    private var graphNameStackView = UIStackView()
    private let week = [ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        graphMainView.do {
            $0.viewRadius(cornerRadius: xValueRatio(20))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        graphMainView.do {
            $0.backgroundColor = .homeBoxColor
        }
        graphSegmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.tintColor = .systemYellow
        }
        graphBackgroundStackView.do {
            $0.backgroundColor = .clear
            $0.distribution = .fillEqually
            $0.spacing = xValueRatio(20)
            $0.axis = .horizontal
        }
        graphStackView.do {
            $0.backgroundColor = .clear
            $0.spacing = xValueRatio(20)
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.alignment = .trailing
        }
        graphNameStackView.do {
            $0.backgroundColor = .clear
            $0.spacing = xValueRatio(20)
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        createGraphBackgroundViews()
        createGraphName()
    }
    
    private func layout() {
        [ graphMainView ].forEach() { self.addSubview($0) }
        [ graphSegmentedControl, graphBackgroundStackView, graphNameStackView ].forEach() { graphMainView.addSubview($0) }
        graphBackgroundStackView.addSubview(graphStackView)
        
        graphMainView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: xValueRatio(350)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(300)).isActive = true
        }
        graphSegmentedControl.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: graphMainView.topAnchor, constant: xValueRatio(10)).isActive = true
            $0.centerXAnchor.constraint(equalTo: graphMainView.centerXAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(20)).isActive = true
            $0.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-20)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: yValueRatio(35)).isActive = true
        }
        graphBackgroundStackView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: graphSegmentedControl.bottomAnchor, constant: yValueRatio(10)).isActive = true
            $0.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(20)).isActive = true
            $0.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-20)).isActive = true
            $0.bottomAnchor.constraint(equalTo: graphMainView.bottomAnchor, constant: yValueRatio(-50)).isActive = true
        }
        graphStackView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: graphBackgroundStackView.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: graphBackgroundStackView.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: graphBackgroundStackView.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: graphBackgroundStackView.bottomAnchor).isActive = true
        }
        graphNameStackView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: graphStackView.bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: graphMainView.leadingAnchor, constant: xValueRatio(20)).isActive = true
            $0.trailingAnchor.constraint(equalTo: graphMainView.trailingAnchor, constant: xValueRatio(-20)).isActive = true
            $0.bottomAnchor.constraint(equalTo: graphMainView.bottomAnchor, constant: yValueRatio(-10)).isActive = true
        }
    }
    
    private func createGraphBackgroundViews() {
        for _ in 0..<7 {
            let view = UIView()
            view.do {
                $0.backgroundColor = .init(red: 0,
                                           green: 0,
                                           blue: 0,
                                           alpha: 0.05)
                $0.viewRadius(cornerRadius: xValueRatio(13))
            }
            graphBackgroundStackView.addArrangedSubview(view)
        }
    }
    
    private func createGraphViews(items: [weekTemp]) {
        var height: CGFloat?
        
        for item in items {
            if item.dangdang > 30 {
                height = CGFloat(30)
            } else {
                height = CGFloat(item.dangdang)
            }
            let view = UIView()
            view.do {
                $0.backgroundColor = .white
                $0.viewRadius(cornerRadius: xValueRatio(13))
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.heightAnchor.constraint(equalToConstant: (height ?? 0)*5).isActive = true
            }
            graphStackView.addArrangedSubview(view)
        }
    }
    
    private func createGraphName() {
        for item in week {
            let label = UILabel()
            label.do {
                $0.textColor = .white
                $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
                $0.text = item
                $0.textAlignment = .center
            }
            graphNameStackView.addArrangedSubview(label)
        }
    }
}

extension HomeGraphView {
    func bind(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.items
            .subscribe(onNext: { [weak self] data in
                self?.createGraphViews(items: data)
            })
            .disposed(by: disposeBag)
    }
}
