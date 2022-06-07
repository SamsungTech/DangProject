//
//  AteFoodCollectionCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/13.
//

import UIKit
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
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = xValueRatio(20)
        
        foodNameLabel.textColor = .white
        foodNameLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(17))
        foodNameLabel.textAlignment = .center
        
        dangLabel.textColor = .white
        dangLabel.font = UIFont.systemFont(ofSize: xValueRatio(15))
        dangLabel.textAlignment = .center
    }
    
    private func layout() {
        [ foodNameLabel, dangLabel ].forEach() { contentView.addSubview($0) }
        
        foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        foodNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: xValueRatio(20)).isActive = true
        foodNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        dangLabel.translatesAutoresizingMaskIntoConstraints = false
        dangLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: xValueRatio(5)).isActive = true
        dangLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
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
            .subscribe(onNext: { [weak self] in
                self?.foodNameLabel.text = $0.foodName
                self?.dangLabel.text = $0.dang
            })
            .disposed(by: disposeBag)
    }
}
