//
//  AteFoodHeader.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit
import Then

class AteFoodTitleView: UIView {
    static let identifier = "AteFoodHeader"
    private let ateFoodTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        ateFoodTitle.do {
            $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(25))
            $0.textColor = .white
            $0.text = "🍲 오늘 먹은것들"
        }
    }
    
    private func layout() {
        [ ateFoodTitle ].forEach() { self.addSubview($0) }
        
        ateFoodTitle.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
        }
    }
    
}
