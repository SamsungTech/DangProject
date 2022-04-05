//
//  CustomNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/21.
//

import UIKit
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
        profileImageView.image = UIImage(named: "231.png")
        profileImageView.tintColor = .white
        profileImageView.viewRadius(cornerRadius: xValueRatio(20))
        
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .bold)
        dateLabel.text = "2020년 2월"
        dateLabel.textAlignment = .center
        
        yearMouthButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        yearMouthButton.tintColor = .white
        
        weekStackView.distribution = .fillEqually
        weekStackView.alignment = .fill
        weekStackView.axis = .horizontal
    }
    
    private func layout() {
        [ profileImageView, dateLabel, yearMouthButton, weekStackView ].forEach() { self.addSubview($0) }
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: xValueRatio(-20)).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: xValueRatio(-30)).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        yearMouthButton.translatesAutoresizingMaskIntoConstraints = false
        yearMouthButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: xValueRatio(5)).isActive = true
        yearMouthButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        yearMouthButton.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        yearMouthButton.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        
        weekStackView.translatesAutoresizingMaskIntoConstraints = false
        weekStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: xValueRatio(10)).isActive = true
        weekStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        weekStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        weekStackView.heightAnchor.constraint(equalToConstant: xValueRatio(20)).isActive = true
        
    }
    
    private func createWeekLabel() {
        for item in week {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: xValueRatio(13))
            label.text = "\(item)"
            
            weekStackView.addArrangedSubview(label)
        }
    }
}
