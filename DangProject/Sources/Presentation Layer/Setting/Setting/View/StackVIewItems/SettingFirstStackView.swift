//
//  SettingStackView.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/24.
//

import UIKit

class SettingFirstStackView: UIStackView {
    private(set) lazy var myTargetView: SettingStackViewItemsButton = {
        let button = SettingStackViewItemsButton()
        button.itemLabel.text = "나의 목표"
        button.frame = CGRect(x: .zero, y: .zero, width: calculateXMax(), height: yValueRatio(60))
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    private(set) lazy var themeView: SettingStackViewItemsButton = {
        let button = SettingStackViewItemsButton()
        button.itemLabel.text = "화면 테마"
        button.frame = CGRect(x: .zero, y: .zero, width: calculateXMax(), height: yValueRatio(60))
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    private(set) lazy var alarmView: SettingStackViewItemsButton = {
        let button = SettingStackViewItemsButton()
        button.itemLabel.text = "알림"
        button.frame = CGRect(x: .zero, y: .zero, width: calculateXMax(), height: yValueRatio(60))
        button.backgroundColor = .homeBoxColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingFirstStackView {
    private func configureUI() {
        setupSettingStackView()
    }
    
    private func setupSettingStackView() {
        self.backgroundColor = .homeBackgroundColor
        let views = [
             myTargetView, themeView, alarmView
        ]
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 0
        views.forEach() { self.addArrangedSubview($0) }
    }
}
