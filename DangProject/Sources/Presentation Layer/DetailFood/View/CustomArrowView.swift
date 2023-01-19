//
//  CustomArrowView.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/19.
//

import UIKit

internal class CustomArrowView: UIView {
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "arrow.png")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 70),
            arrowImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
