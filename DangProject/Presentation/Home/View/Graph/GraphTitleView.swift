//
//  GraphCellHeader.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit
import Then

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
        GraphCellTitle.do {
            $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(25))
            $0.textColor = .white
            $0.text = "🍯 당수치 그래프입니다."
        }
    }
    
    private func layout() {
        [ GraphCellTitle ].forEach() { self.addSubview($0) }
        
        GraphCellTitle.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
        }
    }
}

