//
//  CustomNavigationBar.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/21.
//

import UIKit

import RxSwift
import RxCocoa

protocol NavigationBarDelegate {
    func changeViewControllerExpandation(state: ChevronButtonState)
    func profileImageButtonDidTap()
}

enum ChevronButtonState {
    case expand
    case revert
}

class CustomNavigationBar: UIView {
    private let disposeBag = DisposeBag()
    private let gradient = CAGradientLayer()
    private let week = ["일", "월", "화", "수", "목", "금", "토"]
    private let weekStackView = UIStackView()
    private let weekLabels: [UILabel] = []
    private let dateLabel = UILabel()
    private let chevronButton = UIButton()
    private var chevronButtonState: ChevronButtonState = .revert
    private(set) lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileImageButtonDidTap), for: .touchDown)
        return button
    }()
    
    var parentableViewController: NavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .homeBoxColor
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        createWeekLabel()
        setupProfileImageButton()
        setupDateLabel()
        setupChevronButton()
        setupWeekStackView()
    }
    
    private func setupProfileImageButton() {
        self.addSubview(profileImageButton)
        /// fetch profile
        profileImageButton.setImage(UIImage(named: "231.png"), for: .normal)
        
        profileImageButton.viewRadius(cornerRadius: xValueRatio(20))
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        profileImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: xValueRatio(-20)).isActive = true
        profileImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: xValueRatio(-30)).isActive = true
    }
    
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .bold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor).isActive = true
    }
    
    func changeNavigationBarTitleLabel(text: String) {
        dateLabel.text = text
    }
    
    private func setupChevronButton() {
        addSubview(chevronButton)
        chevronButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        chevronButton.tintColor = .white
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        chevronButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: xValueRatio(5)).isActive = true
        chevronButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        chevronButton.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        chevronButton.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        chevronButton.addTarget(self, action: #selector(chevronButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func chevronButtonDidTapped() {
        changeChevronButton()
        parentableViewController?.changeViewControllerExpandation(state: chevronButtonState)
    }
    
    @objc private func profileImageButtonDidTap() {
        parentableViewController?.profileImageButtonDidTap()
    }
    
    private func setupWeekStackView() {
        addSubview(weekStackView)
        weekStackView.distribution = .fillEqually
        weekStackView.alignment = .fill
        weekStackView.axis = .horizontal
        weekStackView.translatesAutoresizingMaskIntoConstraints = false
        weekStackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: xValueRatio(10)).isActive = true
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
    
    private func changeChevronButton() {
        switch chevronButtonState {
        case .expand:
            chevronButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            chevronButtonState = .revert
        case .revert:
            chevronButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            chevronButtonState = .expand
        }
    }
}
