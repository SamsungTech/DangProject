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
    func didTapButton(tag: Int)
}

class AlarmDaySelectionView: UIView {
    private let disposeBag = DisposeBag()
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

    var delegate: AlarmDaySelectionDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

extension AlarmDaySelectionView {
    @objc func didTapDaysButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sundayButton.backgroundColor = .systemGreen
        case 1:
            mondayButton.backgroundColor = .systemGreen
        case 2:
            tuesdayButton.backgroundColor = .systemGreen
        case 3:
            wednesdayButton.backgroundColor = .systemGreen
        case 4:
            thursdayButton.backgroundColor = .systemGreen
        case 5:
            fridayButton.backgroundColor = .systemGreen
        case 6:
            saturdayButton.backgroundColor = .systemGreen
        default: break
        }
    }
}
