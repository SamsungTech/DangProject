//
//  HomeCollectionFooter.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit
import Then

class HomeCollectionFooter: UICollectionReusableView {
    static let identfier = "HomeCollectionFooter"
    let footerTitle = UILabel()
    let context = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        footerTitle.do {
            $0.font = UIFont.boldSystemFont(ofSize: 25)
            $0.textColor = .lightGray
            $0.text = "Dang_Project"
        }
        context.do {
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.textColor = .lightGray
            $0.text = "1.0.0"
        }
    }
    
    func layout() {
        [ footerTitle, context ].forEach() { self.addSubview($0) }
        
        footerTitle.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        context.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: footerTitle.bottomAnchor,constant: 10).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
}
