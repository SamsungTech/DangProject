//
//  AlarmNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/26.
//

import UIKit

class AlarmNavigationBar: UIView {
    
    private(set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.viewRadius(cornerRadius: xValueRatio(15))
        button.tintColor = .white
        return button
    }()
    
    private lazy var alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .bold)
        return label
    }()
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.viewRadius(cornerRadius: xValueRatio(15))
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlarmNavigationBar {
    private func configureUI() {
        setUpNavigationBar()
        setUpBackButton()
        setUpAlarmLabel()
        setUpAddButton()
    }
    
    private func setUpNavigationBar() {
        self.backgroundColor = .homeBoxColor
    }
    
    private func setUpBackButton() {
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(10)),
            backButton.widthAnchor.constraint(equalToConstant: xValueRatio(30)),
            backButton.heightAnchor.constraint(equalToConstant: yValueRatio(30))
        ])
    }
    
    private func setUpAlarmLabel() {
        addSubview(alarmLabel)
        alarmLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            alarmLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setUpAddButton() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: yValueRatio(10)),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -xValueRatio(10)),
            addButton.widthAnchor.constraint(equalToConstant: xValueRatio(30)),
            addButton.heightAnchor.constraint(equalToConstant: yValueRatio(30))
        ])
    }
}
