//
//  BatteryCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit

class BatteryCell: UICollectionViewCell {
    static let identifier = "BatteryCell"
    var backgroundImage = UIImageView()
    var battery = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        battery.do {
            $0.image = UIImage(named: "battery.png")
        }
    }
    
    func layout() {
        [ battery ].forEach() { self.addSubview($0) }
        
        battery.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: viewXRatio(200)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: viewXRatio(160)).isActive = true
        }
    }
}
