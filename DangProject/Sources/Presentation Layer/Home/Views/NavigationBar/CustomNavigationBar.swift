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
    fileprivate var barHeightAnchor: NSLayoutConstraint?
    private let disposeBag = DisposeBag()
    private let gradient = CAGradientLayer()
    private let week = ["일", "월", "화", "수", "목", "금", "토"]
    private var weekStackView = UIStackView()
    private var weekLabels: [UILabel] = []
    var dateLabel = UILabel()
    var yearMonthButton = UIButton()
    var profileImageView = UIImageView()
    
    var profileImageButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .homeBoxColor
        configureUI()
        configureLabelText(date: DateComponents.currentDateTimeComponents())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        createWeekLabel()
        setUpProfileImageButton()
        setUpDateLabel()
        setUpYearMonthButton()
        setUpWeekStackView()
    }
    
    private func setUpProfileImageButton() {
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
    
    private func setUpDateLabel() {
        addSubview(dateLabel)
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: xValueRatio(25), weight: .bold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(20)).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor).isActive = true
    }
    
    func configureLabelText(date: DateComponents) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        let dateToString = dateFormatter.string(from: Calendar.current.date(from: date)!)
        dateLabel.text = dateToString
    }
    
    private func setUpYearMonthButton() {
        addSubview(yearMonthButton)
        yearMonthButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        yearMonthButton.tintColor = .white
        yearMonthButton.translatesAutoresizingMaskIntoConstraints = false
        yearMonthButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: xValueRatio(5)).isActive = true
        yearMonthButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        yearMonthButton.widthAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
        yearMonthButton.heightAnchor.constraint(equalToConstant: xValueRatio(40)).isActive = true
    }
    
    private func setUpWeekStackView() {
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
}
