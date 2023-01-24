//
//  SettingSecondStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

class SettingSecondStackView: UIStackView {
    private(set) lazy var versionView: SettingAppVersionView = {
        let button = SettingAppVersionView()
        button.itemLabel.text = "앱 버전"
        button.versionLabel.text = "1.0.1"
        button.frame = CGRect(x: .zero, y: .zero, width: calculateXMax(), height: yValueRatio(60))
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingSecondStackView {
    private func setupStackView() {
        self.backgroundColor = .homeBackgroundColor
        let views = [
            versionView
        ]
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 0
        views.forEach() { self.addArrangedSubview($0) }
    }
}

