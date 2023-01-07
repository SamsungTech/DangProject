//
//  AteFoodCollectionCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/13.
//

import UIKit

class EatenFoodsCollectionViewCell: UICollectionViewCell {
    private var backView = UIView()
    private var foodNameLabel = UILabel()
    private var amountLabel = UILabel()
    private var dangLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        layout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = xValueRatio(20)
        
        foodNameLabel.textColor = .customFontColorBlack
        foodNameLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(15))
        foodNameLabel.numberOfLines = 0
        foodNameLabel.textAlignment = .center
        
        amountLabel.textColor = .customFontColorBlack
        amountLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(13))
        amountLabel.textAlignment = .center
        
        dangLabel.textColor = .customFontColorBlack
        dangLabel.font = UIFont.systemFont(ofSize: xValueRatio(13))
        dangLabel.textAlignment = .center
    }
    
    private func layout() {
        [ amountLabel, foodNameLabel, dangLabel ].forEach() { contentView.addSubview($0) }
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        amountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        foodNameLabel.bottomAnchor.constraint(equalTo: amountLabel.topAnchor, constant: -yValueRatio(10)).isActive = true
        foodNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        foodNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        foodNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        dangLabel.translatesAutoresizingMaskIntoConstraints = false
        dangLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: yValueRatio(10)).isActive = true
        dangLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupCell(data: EatenFoodsViewModelEntity) {
        foodNameLabel.text = data.name
        amountLabel.text = "\(data.amount)개"
        dangLabel.text = "\(data.sugar)g"
    }
}
