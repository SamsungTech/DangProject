//
//  HomeGraphCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit

class HomeGraphCell: UICollectionViewCell {
    static let identifier = "HomeGraphCell"
    var graphView = GraphView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        graphView.do {
            $0.viewRadius(cornerRadius: 15)
        }
    }
    func layout() {
        [ graphView ].forEach() { self.addSubview($0) }
        
        graphView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: viewXRatio(200)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: viewXRatio(200)).isActive = true
        }
    }
}
