//
//  AteFoodHeader.swift
//  DangProject
//
//  Created by κΉλμ° on 2022/01/25.
//

import UIKit

class EatenFoodsTitleView: UIView {
    private let eatenFoodsTitleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeEatenFoodsTitleLabel(text: String) {
        eatenFoodsTitleLabel.text = text
    }
    // MARK: - Private
    private func configure() {
        eatenFoodsTitleLabel.font = UIFont.boldSystemFont(ofSize: xValueRatio(25))
        eatenFoodsTitleLabel.textColor = .white
        eatenFoodsTitleLabel.text = "π² μ€λ λ¨Ήμκ²λ€"
    }
    
    private func layout() {
        [ eatenFoodsTitleLabel ].forEach() { self.addSubview($0) }
        eatenFoodsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        eatenFoodsTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        eatenFoodsTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
    }
}
