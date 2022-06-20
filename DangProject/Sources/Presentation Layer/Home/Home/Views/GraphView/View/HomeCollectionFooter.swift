//
//  HomeCollectionFooter.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit

class HomeCollectionFooter: UICollectionReusableView {
    private var footerTitle = UILabel()
    private var context = UILabel()
    
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
    
    private func configure() {
        footerTitle.font = UIFont.boldSystemFont(ofSize: xValueRatio(25))
        footerTitle.textColor = .lightGray
        footerTitle.text = "Dang_Project"
        
        context.font = UIFont.boldSystemFont(ofSize: xValueRatio(20))
        context.textColor = .lightGray
        context.text = "1.0.0"
        
    }
    
    private func layout() {
        [ footerTitle, context ].forEach() { self.addSubview($0) }
        
        footerTitle.translatesAutoresizingMaskIntoConstraints = false
        footerTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        footerTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        context.translatesAutoresizingMaskIntoConstraints = false
        context.topAnchor.constraint(equalTo: footerTitle.bottomAnchor, constant: yValueRatio(10)).isActive = true
        context.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
}
