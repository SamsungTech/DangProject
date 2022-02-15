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
    var viewModel: AteFoodItemViewModel?
    private var disposeBag = DisposeBag()
    private var backView = UIView()
    var foodNameLabel = UILabel()
    var dangLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentView.layer.backgroundColor = UIColor.blue.cgColor
        setCollectionViewRadius(cell: self, radius: 15)
        setCollectionCellShadow(cell: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        foodNameLabel.do {
            $0.textColor = .white
            $0.font = UIFont.boldSystemFont(ofSize: 17)
            $0.textAlignment = .center
        }
        dangLabel.do {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textAlignment = .center
        }
    }
    
    private func layout() {
        [ foodNameLabel, dangLabel ].forEach() { contentView.addSubview($0) }
        
        foodNameLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        dangLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 5).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
    
    func bind(viewModel: AteFoodItemViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.items
            .subscribe(onNext: { [weak self] data in
//                self?.foodNameLabel.text = data
//                self?.dangLabel.text = data.dang
            })
            .disposed(by: disposeBag)
    }
}
