//
//  AlarmDeleteButton.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/27.
//

import UIKit

class AlarmDeleteButton: UIButton {
    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash.fill")
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .regular)
        label.text = "삭제하기"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlarmDeleteButton {
    private func configureUI() {
        setUpDeleteImageView()
        setUpDeleteLabel()
    }
    
    private func setUpDeleteImageView() {
        addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    private func setUpDeleteLabel() {
        addSubview(deleteLabel)
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
