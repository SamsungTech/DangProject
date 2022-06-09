//
//  TabBarItem.swift
//  DangProject
//
//  Created by 김동우 on 2022/06/09.
//

import UIKit

class TabBarItem: UIButton {
    private(set) lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private(set) lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(10), weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setUpItemTitleLabel()
        setUpItemImageView()
    }
    
    private func setUpItemTitleLabel() {
        addSubview(itemTitleLabel)
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemTitleLabel.heightAnchor.constraint(equalToConstant: yValueRatio(20))
        ])
    }
    
    private func setUpItemImageView() {
        addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: self.topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: itemTitleLabel.topAnchor)
        ])
    }
}
