//
//  ThemeItem.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/20.
//

import UIKit

class ThemeItem: UIButton {
    private(set) lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 1, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: xValueRatio(17), weight: .semibold)
        return label
    }()
    
    private(set) lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .clear
        imageView.image = UIImage(systemName: "checkmark")
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

extension ThemeItem {
    private func configureUI() {
        setUpView()
        setUpItemLabel()
        setUpCheckMarkImageView()
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
    
    private func setUpCheckMarkImageView() {
        addSubview(checkMarkImageView)
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkMarkImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(20)),
            checkMarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: xValueRatio(30)),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: yValueRatio(25))
        ])
    }
    
    @objc private func touchDownEvent(_ sender: UIButton) {
        self.backgroundColor = .init(white: 1, alpha: 0.1)
    }
    
    @objc private func touchUpEvent(_ sender: UIButton) {
        self.backgroundColor = .clear
    }
}


