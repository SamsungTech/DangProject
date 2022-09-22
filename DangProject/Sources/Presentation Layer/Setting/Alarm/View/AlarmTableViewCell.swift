//
//  AlarmTableViewItem.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/26.
//

import UIKit

enum TextFieldCase {
    case userMessage
    case time
}

protocol AlarmTableViewCellDelegate: AnyObject {
    
    func middleAndBottomButtonDidTap(cell: UITableViewCell)
    func deleteButtonDidTap(cell: UITableViewCell)
    func changeEverydayValue(cell: UITableViewCell)
    func isOnSwitchDidChanged(cell: UITableViewCell)
    func dayOfTheWeekButtonDidTap(cell: UITableViewCell, tag: Int)
    func userMessageTextFieldEndEditing(cell: UITableViewCell, text: String)
    func timeTextFieldEndEditing(cell: UITableViewCell, time: Date)
    func textFieldWillStartEditing(cell: UITableViewCell)
    func textFieldWillEndEditing()
    
}

class AlarmTableViewCell: UITableViewCell {
    
    var parentableViewController: AlarmTableViewCellDelegate?
    private var messageViewHeightConstant: NSLayoutConstraint?
    private var everydaySelectButtonHeightConstant: NSLayoutConstraint?
    private var dayOfTheWeekSelectViewHeightConstant: NSLayoutConstraint?
    private lazy var textFieldType: TextFieldCase = .userMessage
    private lazy var originalMessageText: String = ""
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .homeBackgroundColor
        return view
    }()
    
    private lazy var middleView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(middleBottomButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .homeBackgroundColor
        return button
    }()
    
    private lazy var bottomView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(middleBottomButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .homeBackgroundColor
        return button
    }()
    
    @objc func middleBottomButtonDidTap() {
        parentableViewController?.middleAndBottomButtonDidTap(cell: self)
    }
    
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
    
    private(set) lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: xValueRatio(45), weight: .medium)
        textField.tintColor = .clear
        textField.addTarget(self, action: #selector(timeTextFieldDidTap), for: .editingDidBegin)
        textField.inputView = wheelsTimePicker
        self.inputToolbar(into: textField)
        return textField
    }()
    
    @objc private func timeTextFieldDidTap() {
        self.textFieldType = .time
        parentableViewController?.textFieldWillStartEditing(cell: self)
    }
    
    private lazy var wheelsTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        return datePicker
    }()
    
    private lazy var defaultTimePickerBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: UIScreen.main.bounds.maxY/5)
        backgroundView.backgroundColor = .systemGray5
        backgroundView.addSubview(defaultTimePicker)
        defaultTimePicker.translatesAutoresizingMaskIntoConstraints = false
        defaultTimePicker.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        defaultTimePicker.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        return backgroundView
    }()
    
    private lazy var defaultTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko-KR")
        return datePicker
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
    
    @objc func isOnValueChanged(_ sender: UISwitch) {
        parentableViewController?.isOnSwitchDidChanged(cell: self)
    }
    
    private(set) lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.addTarget(self, action: #selector(middleBottomButtonDidTap), for: .touchUpInside)
        button.tintColor = .lightGray
        return button
    }()
    
    private(set) lazy var deleteButton: AlarmDeleteButton = {
        let button = AlarmDeleteButton()
        button.isHidden  = true
        button.addTarget(self, action: #selector(deleteButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func deleteButtonDidTap(_ sender: UIButton) {
        parentableViewController?.deleteButtonDidTap(cell: self)
    }
    
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
        textField.addTarget(self, action: #selector(userMessageTextFieldDidTap), for: .editingDidBegin)
        self.inputToolbar(into: textField)
        return textField
    }()
    
    @objc private func userMessageTextFieldDidTap() {
        self.textFieldType = .userMessage
        parentableViewController?.textFieldWillStartEditing(cell: self)
    }
    
    @objc private func cancelButtonDidTap() {
        switch textFieldType {
        case .userMessage:
            userMessageTextField.text = originalMessageText
        case .time:
            break
        }
        parentableViewController?.textFieldWillEndEditing()
        self.endEditing(true)
    }

    @objc private func doneButtonDidTap() {
        switch textFieldType {
        case .userMessage:
            if let userMessageText = userMessageTextField.text {
                parentableViewController?.userMessageTextFieldEndEditing(cell: self, text: userMessageText)
            }
        case .time:
            if #available(iOS 13.4, *) {
                parentableViewController?.timeTextFieldEndEditing(cell: self, time: wheelsTimePicker.date )
            } else {
                parentableViewController?.timeTextFieldEndEditing(cell: self, time: defaultTimePicker.date)
            }
        }
        parentableViewController?.textFieldWillEndEditing()
        self.endEditing(true)
    }
    
    private(set) lazy var everydaySelectButton: EveryDaySelectButton = {
        let button = EveryDaySelectButton()
        button.addTarget(self, action: #selector(everyDayButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func everyDayButtonDidTap() {
        parentableViewController?.changeEverydayValue(cell: self)
    }
    
    private(set) lazy var dayOfTheWeekSelectView: AlarmDaySelectionView = {
        let view = AlarmDaySelectionView()
        view.alarmDaySelectionDelegate = self
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .homeBackgroundColor
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func setupCell(data: AlarmTableViewCellViewModel) {
        setupAlarmIsOn(data.isOn)
        setupAlarmScale(data.scale)
        setupEveryDay(data.isEveryDay)
        setupTimePickerFirstValue(amPm: data.amPm, time: data.timeText)
        titleLabel.text = data.title
        userMessageTextField.text = data.message
        originalMessageText = data.message
        amPmLabel.text = data.amPm
        timeTextField.text = data.timeText
        selectedDayLabel.text = data.selectedDays
        
        dayOfTheWeekSelectView.configureButtonColor(data.selectedDaysOfWeek)
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
        messageViewHeightConstant?.isActive = true
        NSLayoutConstraint.activate([
            userMessageTextField.topAnchor.constraint(equalTo: topView.bottomAnchor),
            userMessageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20)),
            userMessageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -xValueRatio(20))
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
        middleView.addSubview(timeTextField)
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeTextField.leadingAnchor.constraint(equalTo: amPmLabel.trailingAnchor, constant: xValueRatio(5)),
            timeTextField.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -yValueRatio(10)),
            timeTextField.widthAnchor.constraint(equalToConstant: xValueRatio(120)),
            timeTextField.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        ])
    }
    
    private func setupEverydaySelectButton() {
        contentView.addSubview(everydaySelectButton)
        everydaySelectButton.translatesAutoresizingMaskIntoConstraints = false
        everydaySelectButtonHeightConstant = everydaySelectButton.heightAnchor.constraint(equalToConstant: 0)
        everydaySelectButtonHeightConstant?.isActive = true
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
        dayOfTheWeekSelectViewHeightConstant?.isActive = true
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
    
    private func inputToolbar(into textField: UITextField) {
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(cancelButtonDidTap))
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: #selector(doneButtonDidTap))
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, flexibleSpaceButton, saveButton], animated: false)
        toolbar.backgroundColor = .systemGray
        textField.inputAccessoryView = toolbar
    }
    
    //MARK: - everyday
    private func setupEveryDay(_ isEveryDay: Bool) {
        if isEveryDay {
            everydaySelectButton.setCircleViewCheckMark()
        } else {
            everydaySelectButton.setCircleViewNormal()
        }
    }
    
    //MARK: - isOn
    private func setupAlarmIsOn(_ value: Bool) {
        switch value {
        case true:
            self.setupAlarmIsValid()
        case false:
            self.setupAlarmIsInvalid()
        }
    }
    
    private func setupAlarmIsValid() {
        self.isOnSwitch.isOn = true
        self.titleLabel.textColor = .white
        self.amPmLabel.textColor = .white
        self.timeTextField.textColor = UIColor.white
        self.selectedDayLabel.textColor = .white
        self.arrowButton.tintColor = .white
    }
    
    private func setupAlarmIsInvalid() {
        self.isOnSwitch.isOn = false
        self.titleLabel.textColor = .lightGray
        self.amPmLabel.textColor = .lightGray
        self.timeTextField.textColor = UIColor.lightGray
        self.selectedDayLabel.textColor = .lightGray
        self.arrowButton.tintColor = .lightGray
    }
    
    // MARK: - TimePickerFirstValue
    private func setupTimePickerFirstValue(amPm: String, time: String) {
        if #available(iOS 13.4, *) {
            wheelsTimePicker.date = .stringToDate(amPm: amPm, time: time)
        } else {
            defaultTimePicker.date = .stringToDate(amPm: amPm, time: time)
        }
    }
    
    // MARK: - CellAnimating
    private func setupAlarmScale(_ scale: CellScaleState) {
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
        userMessageTextField.isHidden = true
        selectedDayLabel.isHidden = false
        deleteButton.isHidden = true
        arrowButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        everydaySelectButton.isHidden = true
        dayOfTheWeekSelectView.isHidden = true
        
        animateNormal()
    }
    
    private func setupDaysButtonExpand() {
        dayOfTheWeekSelectView.isHidden = true
        
        animateExpand()
    }
    
    private func setupDaysButtonMoreExpand() {
        userMessageTextField.isHidden = false
        arrowButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        dayOfTheWeekSelectView.isHidden = false
        selectedDayLabel.isHidden = true
        deleteButton.isHidden = false
        everydaySelectButton.isHidden = false

        animateMoreExpand()
    }
    
    private func animateNormal() {
        messageViewHeightConstant?.isActive = false
        everydaySelectButtonHeightConstant?.isActive = false
        dayOfTheWeekSelectViewHeightConstant?.isActive = false
        
        messageViewHeightConstant = self.userMessageTextField.heightAnchor.constraint(equalToConstant: 0)
        everydaySelectButtonHeightConstant = self.everydaySelectButton.heightAnchor.constraint(equalToConstant: 0)
        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: 0)

        messageViewHeightConstant?.isActive = true
        everydaySelectButtonHeightConstant?.isActive = true
        dayOfTheWeekSelectViewHeightConstant?.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    private func animateMoreExpand() {
        messageViewHeightConstant?.isActive = false
        everydaySelectButtonHeightConstant?.isActive = false
        dayOfTheWeekSelectViewHeightConstant?.isActive = false
        
        messageViewHeightConstant = self.userMessageTextField.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        everydaySelectButtonHeightConstant = self.everydaySelectButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: yValueRatio(33))
        
        messageViewHeightConstant?.isActive = true
        everydaySelectButtonHeightConstant?.isActive = true
        dayOfTheWeekSelectViewHeightConstant?.isActive = true

        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    private func animateExpand() {
        dayOfTheWeekSelectViewHeightConstant?.isActive = false
        dayOfTheWeekSelectViewHeightConstant = self.dayOfTheWeekSelectView.heightAnchor.constraint(equalToConstant: 0)
        dayOfTheWeekSelectViewHeightConstant?.isActive = true

        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
}

extension AlarmTableViewCell: AlarmDaySelectionDelegate {
    
    func dayOfTheWeekButtonDidTap(tag: Int) {
        parentableViewController?.dayOfTheWeekButtonDidTap(cell: self , tag: tag)
    }
}
