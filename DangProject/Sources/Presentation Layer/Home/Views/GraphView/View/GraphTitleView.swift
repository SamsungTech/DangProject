//
//  GraphCellHeader.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import UIKit

class GraphTitleView: UIView {
    private let GraphCellTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        GraphCellTitle.font = UIFont.boldSystemFont(ofSize: xValueRatio(25))
        GraphCellTitle.textColor = .customFontColorBlack
        GraphCellTitle.text = "🍯 당수치 그래프입니다."
        
    }
    
    private func layout() {
        [ GraphCellTitle ].forEach() { self.addSubview($0) }
        
        GraphCellTitle.translatesAutoresizingMaskIntoConstraints = false
        GraphCellTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        GraphCellTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
    }
}

