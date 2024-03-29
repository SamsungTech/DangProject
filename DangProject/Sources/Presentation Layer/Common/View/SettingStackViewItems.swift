//
//  SettingAccountView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/24.
//

import UIKit

class SettingStackViewItemsButton: UIButton {
    private(set) lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customLabelColorBlack
        label.font = UIFont.systemFont(ofSize: xValueRatio(16), weight: .semibold)
        return label
    }()
    
    private(set) lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .buttonColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingStackViewItemsButton {
    private func configureUI() {
        setUpView()
        setUpItemLabel()
        setUpItemImageView()
    }
    
    private func setUpView() {
        self.addTarget(self, action: #selector(touchDownEvent(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpEvent(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    private func setUpItemLabel() {
        addSubview(itemLabel)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)),
            itemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setUpItemImageView() {
        addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: xValueRatio(10)),
            itemImageView.heightAnchor.constraint(equalToConstant: yValueRatio(20))
        ])
    }
    
    @objc private func touchDownEvent(_ sender: UIButton) {
        self.backgroundColor = .init(white: 1, alpha: 0.1)
    }
    
    @objc private func touchUpEvent(_ sender: UIButton) {
        self.backgroundColor = .homeBoxColor
    }
}
