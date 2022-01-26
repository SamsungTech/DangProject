//
//  AteFoodCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit
import Then

class AteFoodCell: UICollectionViewCell {
    static let identifier = "AteFoodCell"
    var cardView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        configure()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        cardView.do {
            $0.backgroundColor = .systemMint
            $0.viewRadius(cornerRadius: 20)
            $0.setGradient(color1: .systemGreen, color2: .systemMint)
        }
    }
    
    func layout() {
        [ cardView ].forEach() { self.addSubview($0) }
        
        cardView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 300).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
    }
}

