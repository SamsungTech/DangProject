//
//  AteFoodCollectionCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/13.
//

import UIKit
import Then
import RxSwift

class AteFoodCollectionCell: UICollectionViewCell {
    static let identifier = "AteFoodCollectionCell"
    private var viewModel: AteFoodCellInItemViewModel?
    private var disposeBag = DisposeBag()
    private var backView = UIView()
    private var foodNameLabel = UILabel()
    private var dangLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = xValueRatio(20)
            
        }
        foodNameLabel.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(17))
            $0.textAlignment = .center
        }
        dangLabel.do {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: xValueRatio(13))
            $0.textAlignment = .center
        }
    }
    
    private func layout() {
        [ foodNameLabel, dangLabel ].forEach() { contentView.addSubview($0) }
        
        foodNameLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: xValueRatio(20)).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        dangLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: xValueRatio(5)).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
}

extension AteFoodCollectionCell {
    func bind(viewModel: AteFoodCellInItemViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.foodNameLabel.text = data.foodName
                self?.dangLabel.text = data.dang
            })
            .disposed(by: disposeBag)
    }
}
