//
//  AlarmTableViewItem.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/26.
//

import UIKit

import RxSwift

protocol AlarmTableViewItemDelegate: AnyObject {
    func didTapDaysButton()
    func didTapDeleteButton(_ sender: UIButton)
}

class AlarmTableViewItem: UITableViewCell {
    static let identifier = "AlarmTableViewItem"
    private let disposeBag = DisposeBag()
    var viewModel: AlarmTableViewItemViewModel?
    var delegate: AlarmTableViewItemDelegate?
    private var middleViewTopConstant: NSLayoutConstraint?
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemCyan
        return view
    }()
    
    private lazy var middleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(24), weight: .semibold)
        label.textColor = .lightGray
        label.text = "아침 식사"
        return label
    }()
    
    private(set) lazy var pmAmLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(23), weight: .semibold)
        label.textColor = .lightGray
        label.text = "오전"
        return label
    }()
    
    private(set) lazy var timeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(45), weight: .medium)
        button.setTitle("12:00", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    
    private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .heavy)
        label.textColor = .lightGray
        label.text = "매일"
        return label
    }()
    
    private(set) lazy var alarmSwitch: UISwitch = {
        let checkSwitch = UISwitch()
        checkSwitch.addTarget(self, action: #selector(checkSwitchDidTap(_:)), for: .valueChanged)
        return checkSwitch
    }()
    
    private(set) lazy var downArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private(set) lazy var deleteButton: AlarmDeleteButton = {
        let button = AlarmDeleteButton()
        button.isHidden = true
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
    
    private lazy var expandMiddleView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private(set) lazy var alarmSelectedDaysButton: AlarmSelectedDaysButton = {
        let button = AlarmSelectedDaysButton()
        
        return button
    }()
    
    private(set) var alarmDaySelectionView = AlarmDaySelectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: AlarmTableViewItemViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.alarmEntityRelay.value.message
        pmAmLabel.text = viewModel.alarmEntityRelay.value.pmAm
        timeButton.setTitle(
            viewModel.alarmEntityRelay.value.selectedTime,
            for: .normal
        )
        dayLabel.text = viewModel.alarmEntityRelay.value.selectedDays
        alarmDaySelectionView.isHidden = true
        bindCheckSwitchValue()
    }
}

extension AlarmTableViewItem {
    private func configureUI() {
        setUpUserMessageTextField()
        setUpTopView()
        setUpTitleLabel()
        setUpAlarmSwitch()
        setUpMiddleView()
        setUpPmAmLabel()
        setUpTimeLabel()
        setUpBottomView()
        setUpDayLabel()
        setUpDownArrowButton()
        setUpDeleteButton()
        setUpExpandMiddleView()
        setUpSelectedDaysButton()
        setUpAlarmDaySelectionView()
    }
    
    private func setUpUserMessageTextField() {
        contentView.addSubview(userMessageTextField)
        userMessageTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userMessageTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yValueRatio(70)),
            userMessageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20))
        ])
    }
    
    private func setUpTopView() {
        contentView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setUpTitleLabel() {
        topView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20)),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yValueRatio(20)),
        ])
    }
    
    private func setUpAlarmSwitch() {
        topView.addSubview(alarmSwitch)
        alarmSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -xValueRatio(20)),
            alarmSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yValueRatio(20))
        ])
    }
    
    private func setUpMiddleView() {
        contentView.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleViewTopConstant = middleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yValueRatio(60))
        middleViewTopConstant?.isActive = true
        NSLayoutConstraint.activate([
            middleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            middleView.heightAnchor.constraint(equalToConstant: yValueRatio(58.8))
        ])
    }
    
    private func setUpPmAmLabel() {
        middleView.addSubview(pmAmLabel)
        pmAmLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pmAmLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: xValueRatio(20)),
            pmAmLabel.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -yValueRatio(5))
        ])
    }
    
    private func setUpTimeLabel() {
        middleView.addSubview(timeButton)
        timeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeButton.leadingAnchor.constraint(equalTo: pmAmLabel.trailingAnchor, constant: xValueRatio(5)),
            timeButton.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -yValueRatio(10)),
            timeButton.widthAnchor.constraint(equalToConstant: xValueRatio(120)),
            timeButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        ])
    }
    
    private func setUpBottomView() {
        contentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: xValueRatio(50))
        ])
    }
    
    private func setUpDayLabel() {
        bottomView.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20)),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -yValueRatio(20))
        ])
    }
    
    private func setUpDownArrowButton() {
        bottomView.addSubview(downArrowButton)
        downArrowButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downArrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -xValueRatio(20)),
            downArrowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -yValueRatio(10)),
            downArrowButton.widthAnchor.constraint(equalToConstant: xValueRatio(40)),
            downArrowButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        ])
    }
    
    private func setUpDeleteButton() {
        bottomView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(30)),
            deleteButton.centerYAnchor.constraint(equalTo: downArrowButton.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: xValueRatio(150)),
            deleteButton.heightAnchor.constraint(equalToConstant: yValueRatio(50))
        ])
    }
    
    private func setUpExpandMiddleView() {
        contentView.addSubview(expandMiddleView)
        contentView.sendSubviewToBack(expandMiddleView)
        expandMiddleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandMiddleView.topAnchor.constraint(equalTo: middleView.bottomAnchor),
            expandMiddleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            expandMiddleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            expandMiddleView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    private func setUpSelectedDaysButton() {
        expandMiddleView.addSubview(alarmSelectedDaysButton)
        alarmSelectedDaysButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmSelectedDaysButton.topAnchor.constraint(equalTo: pmAmLabel.bottomAnchor, constant: yValueRatio(10)),
            alarmSelectedDaysButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(10)),
            alarmSelectedDaysButton.widthAnchor.constraint(equalToConstant: xValueRatio(90)),
            alarmSelectedDaysButton.heightAnchor.constraint(equalToConstant: yValueRatio(40))
        ])
    }
    
    private func setUpAlarmDaySelectionView() {
        contentView.addSubview(alarmDaySelectionView)
        contentView.sendSubviewToBack(alarmDaySelectionView)
        alarmDaySelectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmDaySelectionView.topAnchor.constraint(equalTo: expandMiddleView.bottomAnchor),
            alarmDaySelectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xValueRatio(20)),
            alarmDaySelectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -xValueRatio(20)),
            alarmDaySelectionView.heightAnchor.constraint(equalToConstant: yValueRatio(33))
        ])
    }
    
    private func bindUI() {
        alarmSelectedDaysButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapDaysButton()
                self.viewModel?.branchOutMoreExpandState()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCheckSwitchValue() {
        viewModel?.switchValueRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case true:
                    self.setUpItemTextColorTrue()
                case false:
                    self.setUpItemTextColorFalse()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.expandStateRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .expand:
                    self.setUpDaysButtonExpand()
                case .moreExpand:
                    self.setUpDaysButtonMoreExpand()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension AlarmTableViewItem {
    @objc func checkSwitchDidTap(_ sender: UISwitch) {
        viewModel?.branchOutSwitchValue(sender)
    }
    
    @objc func deleteButtonDidTap(_ sender: UIButton) {
        delegate?.didTapDeleteButton(sender)
    }
}

extension AlarmTableViewItem {
    private func setUpItemTextColorTrue() {
        self.alarmSwitch.isOn = true
        self.titleLabel.textColor = .white
        self.pmAmLabel.textColor = .white
        self.timeButton.setTitleColor(UIColor.white, for: .normal)
        self.dayLabel.textColor = .white
    }
    
    private func setUpItemTextColorFalse() {
        self.alarmSwitch.isOn = false
        self.titleLabel.textColor = .lightGray
        self.pmAmLabel.textColor = .lightGray
        self.timeButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.dayLabel.textColor = .lightGray
    }
    
    func setUpCellExpand() {
        dayLabel.isHidden = true
        deleteButton.isHidden = false
        middleViewTopConstant?.constant = yValueRatio(110)
        alarmDaySelectionView.isHidden = true
        self.contentView.backgroundColor = .systemBrown
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    func setUpCellNormal() {
        dayLabel.isHidden = false
        deleteButton.isHidden = true
        middleViewTopConstant?.constant = yValueRatio(60)
        alarmSelectedDaysButton.circleView.backgroundColor = .clear
        alarmDaySelectionView.isHidden = true
        self.contentView.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    private func setUpDaysButtonExpand() {
        alarmDaySelectionView.isHidden = true
        alarmSelectedDaysButton.layer.borderColor = UIColor.lightGray.cgColor
        alarmSelectedDaysButton.circleView.backgroundColor = .clear
    }
    
    private func setUpDaysButtonMoreExpand() {
        alarmDaySelectionView.isHidden = false
        alarmSelectedDaysButton.layer.borderColor = UIColor.systemGreen.cgColor
        alarmSelectedDaysButton.circleView.backgroundColor = .systemGreen
    }
}
