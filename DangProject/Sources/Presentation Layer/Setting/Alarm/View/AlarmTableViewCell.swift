//
//  AlarmTableViewItem.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/26.
//

import UIKit

protocol AlarmTableViewCellDelegate: AnyObject {
    func middleBottonButtonDidTapped(cell: UITableViewCell)
    func everyDayButtonDidTapped(cell: UITableViewCell)
    func isOnSwitchDidChanged(cell: UITableViewCell)
}

class AlarmTableViewCell: UITableViewCell {
    var delegate: AlarmTableViewCellDelegate?
    private lazy var messageViewHeightConstant: NSLayoutConstraint = self.userMessageTextField.heightAnchor.constraint(equalToConstant: yValueRatio(50))
    private lazy var everydaySelectButtonHeightConstant: NSLayoutConstraint = self.everydaySelectButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
    private lazy var dayOfTheWeekSelectViewHeightConstant: NSLayoutConstraint = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: yValueRatio(33))
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    private lazy var middleView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(middleBottomButtonTaped), for: .touchUpInside)
        button.backgroundColor = .systemRed
        return button
    }()
    
    private lazy var bottomView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(middleBottomButtonTaped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(24), weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    private(set) lazy var amPmLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(23), weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    private(set) lazy var timeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(45), weight: .medium)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    
    private(set) lazy var selectedDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .heavy)
        label.textColor = .lightGray
        return label
    }()
    
    private(set) lazy var isOnSwitch: UISwitch = {
        let checkSwitch = UISwitch()
        checkSwitch.addTarget(self, action: #selector(isOnValueChanged(_:)), for: .valueChanged)
        return checkSwitch
    }()
    
    private(set) lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private(set) lazy var deleteButton: AlarmDeleteButton = {
        let button = AlarmDeleteButton()
        button.isHidden  = true
        button.addTarget(self, action: #selector(deleteButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var userMessageTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.lightGray
        textField.font = UIFont.systemFont(ofSize: xValueRatio(15), weight: .semibold)
        textField.attributedPlaceholder = NSAttributedString(
            string: "사용자 지정 메시지",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: xValueRatio(15), weight: .semibold)
            ]
        )
        return textField
    }()
    
    private(set) lazy var everydaySelectButton: AlarmSelectedDaysButton = {
        let button = AlarmSelectedDaysButton()
        button.addTarget(self, action: #selector(everyDayButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) var dayOfTheWeekSelectView = AlarmDaySelectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func setupCell(data: AlarmTableViewCellViewModel) {
        bindAlarmIsOn(data.isOn)
        bindAlarmScale(data.scale)
        titleLabel.text = data.title
        amPmLabel.text = data.pmAm
        timeButton.setTitle(
            data.time,
            for: .normal
        )
        selectedDayLabel.text = data.selectedDays
    }
    
    func getCellHeight(_ scale: CellScaleState) -> CGFloat {
        let defaultHeight: CGFloat = topView.frame.height + middleView.frame.height + bottomView.frame.height
        let messageFieldHeight: CGFloat = userMessageTextField.frame.height
        let alarmSelectedDaysButtonHeight: CGFloat = everydaySelectButton.frame.height
        let alarmDaySelectionViewHeight: CGFloat = dayOfTheWeekSelectView.frame.height
        switch scale {
        case .expand:
            return defaultHeight + messageFieldHeight + alarmSelectedDaysButtonHeight
        case .normal:
            return defaultHeight
        case .moreExpand:
            return defaultHeight + messageFieldHeight + alarmSelectedDaysButtonHeight + alarmDaySelectionViewHeight
        }
    }
    
    // MARK: - Private

    private func configureUI() {
        setupTopView()
        setupUserMessageTextField()
        setupTitleLabel()
        setupAlarmSwitch()
        setupMiddleView()
        setupAmPmLabel()
        setupTimeLabel()
        setupEverydaySelectButton()
        setupDayOfTheWeekSelectView()
        setupBottomView()
        setupSelectedDayLabel()
        setupDownArrowButton()
        setupDeleteButton()
    }
    
    private func setupTopView() {
        contentView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setupUserMessageTextField() {
        contentView.addSubview(userMessageTextField)
        userMessageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageViewHeightConstant = userMessageTextField.heightAnchor.constraint(equalToConstant: 0)
        messageViewHeightConstant.isActive = true
        NSLayoutConstraint.activate([
            userMessageTextField.topAnchor.constraint(equalTo: topView.bottomAnchor),
            userMessageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    
    private func setupTitleLabel() {
        topView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: yValueRatio(20)),
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: xValueRatio(20)),
        ])
    }
    
    private func setupAlarmSwitch() {
        topView.addSubview(isOnSwitch)
        isOnSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isOnSwitch.topAnchor.constraint(equalTo: topView.topAnchor, constant: yValueRatio(20)),
            isOnSwitch.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -xValueRatio(20))
        ])
    }
    
    private func setupMiddleView() {
        contentView.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleView.topAnchor.constraint(equalTo: userMessageTextField.bottomAnchor),
            middleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            middleView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setupAmPmLabel() {
        middleView.addSubview(amPmLabel)
        amPmLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amPmLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: xValueRatio(20)),
            amPmLabel.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -yValueRatio(5))
        ])
    }
    
    private func setupTimeLabel() {
        middleView.addSubview(timeButton)
        timeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeButton.leadingAnchor.constraint(equalTo: amPmLabel.trailingAnchor, constant: xValueRatio(5)),
            timeButton.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -yValueRatio(10)),
            timeButton.widthAnchor.constraint(equalToConstant: xValueRatio(120)),
            timeButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        ])
    }
    
    private func setupEverydaySelectButton() {
        contentView.addSubview(everydaySelectButton)
        everydaySelectButton.translatesAutoresizingMaskIntoConstraints = false
        everydaySelectButtonHeightConstant = everydaySelectButton.heightAnchor.constraint(equalToConstant: 0)
        everydaySelectButtonHeightConstant.isActive = true
        NSLayoutConstraint.activate([
            everydaySelectButton.topAnchor.constraint(equalTo: middleView.bottomAnchor),
            everydaySelectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(10)),
            everydaySelectButton.widthAnchor.constraint(equalToConstant: xValueRatio(90))
        ])
    }
    
    private func setupDayOfTheWeekSelectView() {
        contentView.addSubview(dayOfTheWeekSelectView)
        dayOfTheWeekSelectView.translatesAutoresizingMaskIntoConstraints = false
        dayOfTheWeekSelectViewHeightConstant = dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: 0)
        dayOfTheWeekSelectViewHeightConstant.isActive = true
        NSLayoutConstraint.activate([
            dayOfTheWeekSelectView.topAnchor.constraint(equalTo: everydaySelectButton.bottomAnchor, constant: 10),
            dayOfTheWeekSelectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20)),
            dayOfTheWeekSelectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -xValueRatio(20))
        ])
    }
    
    private func setupBottomView() {
        contentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: xValueRatio(50))
        ])
    }
    
    private func setupSelectedDayLabel() {
        bottomView.addSubview(selectedDayLabel)
        selectedDayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedDayLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: xValueRatio(20)),
            selectedDayLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -yValueRatio(20))
        ])
    }
    
    private func setupDownArrowButton() {
        bottomView.addSubview(arrowButton)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -xValueRatio(20)),
            arrowButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -yValueRatio(10)),
            arrowButton.widthAnchor.constraint(equalToConstant: xValueRatio(40)),
            arrowButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        ])
    }
    
    private func setupDeleteButton() {
        bottomView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: xValueRatio(30)),
            deleteButton.centerYAnchor.constraint(equalTo: arrowButton.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: xValueRatio(150)),
            deleteButton.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        ])
    }
    
    private func bindAlarmIsOn(_ value: Bool) {
        switch value {
        case true:
            self.setupAlarmIsValid()
        case false:
            self.setupAlarmIsInvaild()
        }
    }
    
    private func setupAlarmIsValid() {
        self.isOnSwitch.isOn = true
        self.titleLabel.textColor = .white
        self.amPmLabel.textColor = .white
        self.timeButton.setTitleColor(UIColor.white, for: .normal)
        self.selectedDayLabel.textColor = .white
        self.arrowButton.tintColor = .white
    }
    
    private func setupAlarmIsInvaild() {
        self.isOnSwitch.isOn = false
        self.titleLabel.textColor = .lightGray
        self.amPmLabel.textColor = .lightGray
        self.timeButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.selectedDayLabel.textColor = .lightGray
        self.arrowButton.tintColor = .lightGray
    }
    
}

extension AlarmTableViewCell {
    @objc func isOnValueChanged(_ sender: UISwitch) {
        delegate?.isOnSwitchDidChanged(cell: self)
    }
    
    @objc func deleteButtonDidTap(_ sender: UIButton) {
    }
    
    @objc func middleBottomButtonTaped() {
        delegate?.middleBottonButtonDidTapped(cell: self)
    }
    
    @objc func everyDayButtonTapped() {
        delegate?.everyDayButtonDidTapped(cell: self)
    }
}

extension AlarmTableViewCell {
    
    private func bindAlarmScale(_ scale: CellScaleState) {
        switch scale {
        case .expand:
            self.setupDaysButtonExpand()
        case .normal:
            self.setupCellNormal()
        case .moreExpand:
            self.setupDaysButtonMoreExpand()
        }
    }
    
    private func setupCellNormal() {
        selectedDayLabel.isHidden = false
        deleteButton.isHidden = true
        arrowButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        everydaySelectButton.isHidden = true
        
        dayOfTheWeekSelectView.isHidden = true
        self.contentView.backgroundColor = .clear
        
        animateNormal()
    }
    
    private func setupDaysButtonExpand() {
        dayOfTheWeekSelectView.isHidden = true
        
        animateExpand()
    }
    
    private func setupDaysButtonMoreExpand() {
        arrowButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        dayOfTheWeekSelectView.isHidden = false
        selectedDayLabel.isHidden = true
        deleteButton.isHidden = false
        // 매일 버튼 on off
        everydaySelectButton.isHidden = false
        everydaySelectButton.layer.borderColor = UIColor.systemGreen.cgColor
        everydaySelectButton.circleView.backgroundColor = .systemGreen

        animateMoreExpand()
    }
    
    private func animateNormal() {
        messageViewHeightConstant.isActive = false
        everydaySelectButtonHeightConstant.isActive = false
        dayOfTheWeekSelectViewHeightConstant.isActive = false
        
        messageViewHeightConstant = self.userMessageTextField.heightAnchor.constraint(equalToConstant: 0)
        everydaySelectButtonHeightConstant = self.everydaySelectButton.heightAnchor.constraint(equalToConstant: 0)
        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: 0)

        messageViewHeightConstant.isActive = true
        everydaySelectButtonHeightConstant.isActive = true
        dayOfTheWeekSelectViewHeightConstant.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    private func animateMoreExpand() {
        messageViewHeightConstant.isActive = false
        everydaySelectButtonHeightConstant.isActive = false
        dayOfTheWeekSelectViewHeightConstant.isActive = false
        
        messageViewHeightConstant = self.userMessageTextField.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        everydaySelectButtonHeightConstant = self.everydaySelectButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: yValueRatio(33))
        
        messageViewHeightConstant.isActive = true
        everydaySelectButtonHeightConstant.isActive = true
        dayOfTheWeekSelectViewHeightConstant.isActive = true

        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    private func animateExpand() {
        messageViewHeightConstant.isActive = false
        everydaySelectButtonHeightConstant.isActive = false
        dayOfTheWeekSelectViewHeightConstant.isActive = false
        
        messageViewHeightConstant = self.userMessageTextField.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        everydaySelectButtonHeightConstant = self.everydaySelectButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: 0)
        
        messageViewHeightConstant.isActive = true
        everydaySelectButtonHeightConstant.isActive = true
        dayOfTheWeekSelectViewHeightConstant.isActive = true

        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
//        dayOfTheWeekSelectViewHeightConstant.isActive = false
//        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: 0)
//        dayOfTheWeekSelectViewHeightConstant.isActive = true
//
//        UIView.animate(withDuration: 0.3, animations: {
//            self.contentView.layoutIfNeeded()
//        })
    }
}
