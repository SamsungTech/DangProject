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
    
    weak var alarmDaySelectionDelegate: AlarmDaySelectionDelegate?
    
    private let week = ["월", "화", "수", "목", "금", "토", "일"]
    private lazy var alarmStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    private var sundayButton = UIButton()
    private var mondayButton = UIButton()
    private var tuesdayButton = UIButton()
    private var wednesdayButton = UIButton()
    private var thursdayButton = UIButton()
    private var fridayButton = UIButton()
    private var saturdayButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
            configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtonColor(_ selectedDays: [DayOfWeek]) {
        resetAllButtons()
        selectedDays.forEach { dayOfWeek in
            switch dayOfWeek {
            case .monday:
                mondayButton.backgroundColor = .circleColorGreen
                mondayButton.setTitleColor(UIColor.white, for: .normal)
            case .tuesday:
                tuesdayButton.backgroundColor = .circleColorGreen
                tuesdayButton.setTitleColor(UIColor.white, for: .normal)
            case .wednesday:
                wednesdayButton.backgroundColor = .circleColorGreen
                wednesdayButton.setTitleColor(UIColor.white, for: .normal)
            case .thursday:
                thursdayButton.backgroundColor = .circleColorGreen
                thursdayButton.setTitleColor(UIColor.white, for: .normal)
            case .friday:
                fridayButton.backgroundColor = .circleColorGreen
                fridayButton.setTitleColor(UIColor.white, for: .normal)
            case .saturday:
                saturdayButton.backgroundColor = .circleColorGreen
                saturdayButton.setTitleColor(UIColor.white, for: .normal)
            case .sunday:
                sundayButton.backgroundColor = .circleColorGreen
                sundayButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
}

extension AlarmDaySelectionView {
    
    private func configureUI() {
        setUpStackView()
    }
    
    private func setUpStackView() {
        let buttonsArray = [mondayButton, tuesdayButton,
            wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
        var tagNumber = 1
        buttonsArray.forEach { button in
            button.setAttributedTitle(
                NSAttributedString(
                    string: "\(week[tagNumber - 1])",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(
                            ofSize: yValueRatio(15),
                            weight: .heavy
                        )]
                ), for: .normal)
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.tag = tagNumber
            button.addTarget(
                self,
                action: #selector(daysButtonDidTap(_:)),
                for: .touchUpInside
            )
            button.frame = CGRect(x: .zero, y: .zero, width: xValueRatio(33), height: yValueRatio(33))
            button.viewRadius(cornerRadius: yValueRatio(16.5))
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
    @objc func daysButtonDidTap(_ sender: UIButton) {
        alarmDaySelectionDelegate?.dayOfTheWeekButtonDidTap(tag: sender.tag)
    }
}
