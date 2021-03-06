//
//  GraphCellHeader.swift
//  DangProject
//
//  Created by κΉλμ° on 2022/01/25.
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
        GraphCellTitle.textColor = .white
        GraphCellTitle.text = "π― λΉμμΉ κ·Έλνμλλ€."
        
    }
    
    private func layout() {
        [ GraphCellTitle ].forEach() { self.addSubview($0) }
        
        GraphCellTitle.translatesAutoresizingMaskIntoConstraints = false
        GraphCellTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        GraphCellTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
    }
}

