//
//  CustomNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/21.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa

class CustomNavigationBar: UIView {
    var profileImageView = UIImageView()
    fileprivate var barHeightAnchor: NSLayoutConstraint?
    private let disposeBag = DisposeBag()
    private let gradient = CAGradientLayer()
    private let week = ["일", "월", "화", "수", "목", "금", "토"]
    private var weekStackView = UIStackView()
    private var weekLabels: [UILabel] = []
    var dateLabel = UILabel()
    var yearMouthButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .homeBoxColor
        createWeekLabel()
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        profileImageView.do {
            $0.image = UIImage(named: "231.png")
            $0.tintColor = .white
            $0.viewRadius(cornerRadius: xValueRatio(20))
        }
        dateLabel.do {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .bold)
            $0.text = "2020년 2월"
            $0.textAlignment = .center
        }
        yearMouthButton.do {
            $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            $0.tintColor = .white
        }
        weekStackView.do {
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    }
    
    private func layout() {
        [ profileImageView, dateLabel, yearMouthButton, weekStackView ].forEach() { self.addSubview($0) }
        
        profileImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: xValueRatio(-20)).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: xValueRatio(-30)).isActive = true
        }
        dateLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
            $0.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        }
        yearMouthButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: xValueRatio(5)).isActive = true
            $0.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        }
        weekStackView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: xValueRatio(10)).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: xValueRatio(20)).isActive = true
        }
    }
    
    private func createWeekLabel() {
        for item in week {
            let label = UILabel()
            label.do {
                $0.textAlignment = .center
                $0.textColor = .white
                $0.font = UIFont.boldSystemFont(ofSize: xValueRatio(13))
                $0.text = "\(item)"
            }
            weekStackView.addArrangedSubview(label)
        }
    }
}
