//
//  AlarmDaySelectionView.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/04.
//

import UIKit

import RxSwift
import RxCocoa

protocol AlarmDaySelectionDelegate: AnyObject {
    func dayOfTheWeekButtonDidTap(tag: Int)
}

class AlarmDaySelectionView: UIView {
    weak var parentableTableViewCell: AlarmDaySelectionDelegate?
    
    private let week = [ "일", "월", "화", "수", "목", "금", "토"  ]
    private lazy var alarmStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    var sundayButton = UIButton()
    var mondayButton = UIButton()
    var tuesdayButton = UIButton()
    var wednesdayButton = UIButton()
    var thursdayButton = UIButton()
    var fridayButton = UIButton()
    var saturdayButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
            configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtonColor(_ tags: [Int]) {
        resetAllButtons()
        tags.forEach { tag in
            switch tag {
            case 0:
                sundayButton.backgroundColor = .circleColorGreen
                sundayButton.setTitleColor(UIColor.white, for: .normal)
            case 1:
                mondayButton.backgroundColor = .circleColorGreen
                mondayButton.setTitleColor(UIColor.white, for: .normal)
            case 2:
                tuesdayButton.backgroundColor = .circleColorGreen
                tuesdayButton.setTitleColor(UIColor.white, for: .normal)
            case 3:
                wednesdayButton.backgroundColor = .circleColorGreen
                wednesdayButton.setTitleColor(UIColor.white, for: .normal)
            case 4:
                thursdayButton.backgroundColor = .circleColorGreen
                thursdayButton.setTitleColor(UIColor.white, for: .normal)
            case 5:
                fridayButton.backgroundColor = .circleColorGreen
                fridayButton.setTitleColor(UIColor.white, for: .normal)
            case 6:
                saturdayButton.backgroundColor = .circleColorGreen
                saturdayButton.setTitleColor(UIColor.white, for: .normal)
            default: break
            }
        }
    }
}

extension AlarmDaySelectionView {
    
    private func configureUI() {
        setUpStackView()
    }
    
    private func setUpStackView() {
        let buttonsArray = [
            sundayButton, mondayButton, tuesdayButton,
            wednesdayButton, thursdayButton, fridayButton, saturdayButton
        ]
        var tagNumber = 0
        buttonsArray.forEach { button in
            button.setAttributedTitle(
                NSAttributedString(
                    string: "\(week[tagNumber])",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(
                            ofSize: xValueRatio(15),
                            weight: .heavy
                        )]
                ), for: .normal)
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.tag = tagNumber
            button.addTarget(
                self,
                action: #selector(didTapDaysButton(_:)),
                for: .touchUpInside
            )
            button.frame = CGRect(x: .zero, y: .zero, width: xValueRatio(33), height: yValueRatio(33))
            button.viewRadius(cornerRadius: xValueRatio(16.5))
            button.backgroundColor = .blue
            tagNumber += 1
            alarmStackView.addArrangedSubview(button)
        }
        addSubview(alarmStackView)
        alarmStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmStackView.topAnchor.constraint(equalTo: self.topAnchor),
            alarmStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            alarmStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            alarmStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func resetAllButtons() {
        sundayButton.backgroundColor = .clear
        sundayButton.setTitleColor(UIColor.lightGray, for: .normal)
        mondayButton.backgroundColor = .clear
        mondayButton.setTitleColor(UIColor.lightGray, for: .normal)
        tuesdayButton.backgroundColor = .clear
        tuesdayButton.setTitleColor(UIColor.lightGray, for: .normal)
        wednesdayButton.backgroundColor = .clear
        wednesdayButton.setTitleColor(UIColor.lightGray, for: .normal)
        thursdayButton.backgroundColor = .clear
        thursdayButton.setTitleColor(UIColor.lightGray, for: .normal)
        fridayButton.backgroundColor = .clear
        fridayButton.setTitleColor(UIColor.lightGray, for: .normal)
        saturdayButton.backgroundColor = .clear
        saturdayButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
}

extension AlarmDaySelectionView {
    @objc func didTapDaysButton(_ sender: UIButton) {
        parentableTableViewCell?.dayOfTheWeekButtonDidTap(tag: sender.tag)
    }
}
