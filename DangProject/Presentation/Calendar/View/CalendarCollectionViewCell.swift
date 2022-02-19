//
//  CalendarCollectionViewCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/17.
//

import Foundation
import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    
    var dayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dayLabel.do {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
    }
    
    private func layout() {
        [ dayLabel ].forEach() { self.addSubview($0) }
        
        dayLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
    }
}
