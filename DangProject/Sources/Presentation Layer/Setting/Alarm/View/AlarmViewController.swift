//
//  AlramViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

import RxSwift
import RxCocoa

enum CellAmountState {
    case plus
    case minus
    case none
}

enum EatenTimeAlertController: String {
    case morning = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
}

class AlarmViewController: CustomViewController {
    weak var coordinator: AlarmCoordinator?
    private let disposeBag = DisposeBag()
    private var viewModel: AlarmViewModelProtocol
    private var navigationBar = AlarmNavigationBar()
    private var alarmTableView = UITableView()
    
    private lazy var addAlarmAlertController: UIAlertController = {
        let alert = UIAlertController(title: "기록되지 않았을 때 미리 알림받기",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        return alert
    }()
    
    private lazy var deleteAlertController: UIAlertController = {
        let alert = UIAlertController(title: "이 미리 알림을 삭제하시겠습니까?",
                                      message: nil,
                                      preferredStyle: .alert)
        return alert
    }()
    
    private lazy var invisibleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.frame = self.view.bounds
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkUserNotificationsIsFirst()
        configureUI()
        bind()
    }
      
    init(viewModel: AlarmViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupView
    private func configureUI() {
        setupBackground()
        setupNavigationBar()
        setupAlarmTableView()
        setupInvisibleView()
        setupAddAlarmAlertController()
        setupDeleteAlertController()
    }
    
    private func setupBackground() {
        view.backgroundColor = .homeBackgroundColor
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90))
        ])
    }
    
    private func setupAlarmTableView() {
        view.addSubview(alarmTableView)
        alarmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            alarmTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alarmTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            alarmTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        alarmTableView.backgroundColor = .homeBackgroundColor
        alarmTableView.separatorColor = UIColor.systemGray
        alarmTableView.register(AlarmTableViewCell.self,
                                forCellReuseIdentifier: AlarmTableViewCell.identifier)
        alarmTableView.showsVerticalScrollIndicator = true
        alarmTableView.indicatorStyle = .white
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTableView.contentInset = .init(top: 0, left: 0, bottom: UIScreen.main.bounds.maxY/3, right: 0)
    }
    
    private func setupInvisibleView() {
        view.addSubview(invisibleView)
        invisibleView.isHidden = true
    }
    
    private func setupAddAlarmAlertController() {
        let alertInstance = [EatenTimeAlertController.morning, EatenTimeAlertController.lunch, EatenTimeAlertController.dinner, EatenTimeAlertController.snack]
        alertInstance.forEach { eatenTimeAlert in
            makeAddAlarmAlertControllerAddAction(eatenTimeAlert: eatenTimeAlert)
        }
        addAlarmAlertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    }
    
    private func makeAddAlarmAlertControllerAddAction(eatenTimeAlert: EatenTimeAlertController) {
        var alertActionTitle: String = ""
        var alarmDataTitle: String = ""
        var alarmDataTime: Date = .init()
        switch eatenTimeAlert {
        case .morning:
            alertActionTitle = eatenTimeAlert.rawValue
            alarmDataTitle = "\(eatenTimeAlert.rawValue)식사"
            alarmDataTime = .makeTime(hour: 9, minute: 00)
        case .lunch:
            alertActionTitle = eatenTimeAlert.rawValue
            alarmDataTitle = "\(eatenTimeAlert.rawValue)식사"
            alarmDataTime = .makeTime(hour: 12, minute: 00)
        case .dinner:
            alertActionTitle = eatenTimeAlert.rawValue
            alarmDataTitle = "\(eatenTimeAlert.rawValue)식사"
            alarmDataTime = .makeTime(hour: 18, minute: 00)
        case .snack:
            alertActionTitle = eatenTimeAlert.rawValue
            alarmDataTitle = eatenTimeAlert.rawValue
            alarmDataTime = .makeTime(hour: 14, minute: 00)
        }
        addAlarmAlertController.addAction(UIAlertAction(title: alertActionTitle,
                                                style: .default,
                                                handler: { [weak self] _ in
            let alarmData = AlarmDomainModel(
                isOn: true,
                title: alarmDataTitle,
                time: alarmDataTime,
                selectedDaysOfTheWeek: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
            )
            self?.viewModel.addAlarmDomainModel(alarmData)
        }))
    }
    
    private func setupDeleteAlertController() {
        let no = UIAlertAction(title: "취소", style: .default, handler: nil)
        let yes = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteAlarmData()
        }
        deleteAlertController.addAction(yes)
        deleteAlertController.addAction(no)
    }
    
    // MARK: - Bind
    private func bind() {
        bindUI()
        bindAlarmTableViewCellData()
    }
    
    private func bindUI() {
        Observable.merge(
            navigationBar.backButton.rx.tap.map { NavigationBarEvent.back },
            navigationBar.addButton.rx.tap.map { NavigationBarEvent.add }
        )
        .bind { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .back:
                self.coordinator?.popAlarmViewController()
            case .add:
                self.present(self.addAlarmAlertController, animated: true, completion: nil)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func bindAlarmTableViewCellData() {
        var dataCount = viewModel.alarmDataArrayRelay.value.count
        

        viewModel.alarmDataArrayRelay
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self,
                      let cellAmountState = self?.viewModel.branchOutCellAmountState(dataCount, data.count) else { return }
                
                switch cellAmountState {
                case .plus:
                    self?.updateCellUI(.plus)
                    dataCount += 1
                case .minus:
                    self?.updateCellUI(.minus)
                    dataCount -= 1
                case .none:
                    self?.updateCellUI(.none)
                }
                
                strongSelf.performBatchTableViewCell(data)
                strongSelf.scrollToRowAtPlusAlarm(cellAmountState)
                strongSelf.scrollToRowAtNone(cellAmountState)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCellUI(_ cellAmountState: CellAmountState) {
        alarmTableView.performBatchUpdates {
            switch cellAmountState {
            case .plus:
                alarmTableView.insertRows(at: [IndexPath(row: viewModel.addedCellIndex, section: 0)],
                                          with: UITableView.RowAnimation.fade)
            case .minus:
                alarmTableView.deleteRows(at: [IndexPath(row: viewModel.willDeleteCellIndex, section: 0)],
                                          with: UITableView.RowAnimation.top)
            case .none:
                break
            }
        }
    }
    
    private func performBatchTableViewCell(_ data: [AlarmTableViewCellViewModel]) {
        alarmTableView.beginUpdates()
        for i in 0 ..< data.count {
            if let cell = self.alarmTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? AlarmTableViewCell {
                cell.setupCell(data: data[i], state: .none)
            }
        }
            
        alarmTableView.endUpdates()
    }
    
    private func scrollToRowAtPlusAlarm(_ direction: CellAmountState) {
        let addIndex = self.viewModel.addedCellIndex

        if direction == .plus {
            self.alarmTableView.scrollToRow(at: IndexPath(row: addIndex, section: 0),
                                            at: .top,
                                            animated: true)
        }
    }
    
    private func scrollToRowAtNone(_ direction: CellAmountState) {
        let row = viewModel.selectedMiddleButtonIndex
        
        if direction == .none {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.alarmTableView.scrollToRow(at: IndexPath(row: row, section: 0),
                                                at: .top,
                                                animated: true)
            }
        }
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.alarmDataArrayRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        setupCell(cell: cell, index: indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func setupCell(cell: AlarmTableViewCell,
                           index: Int) {
        let data = viewModel.alarmDataArrayRelay.value
        cell.parentableViewController = self
        cell.selectionStyle = .none
        cell.setupCell(data: data[index], state: .reuse)
    }
}

extension AlarmViewController: AlarmTableViewCellDelegate {
    func textFieldWillStartEditing(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        alarmTableView.scrollToRow(at: cellIndexPath, at: .top, animated: true)
        viewModel.expandSelectedCell(index: cellIndexPath.row)
        invisibleView.isHidden = false
    }
    
    func textFieldWillEndEditing() {
        invisibleView.isHidden = true
    }
    
    func middleAndBottomButtonDidTap(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeCellActivated(index: cellIndexPath.row)
    }
    
    func deleteButtonDidTap(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.willDeleteAlarmData(cellIndexPath.row)
        present(deleteAlertController, animated: true, completion: nil)
    }
    
    func isOnSwitchDidChanged(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeIsOnValue(index: cellIndexPath.row)
    }
    
    func changeEverydayValue(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeEveryday(index: cellIndexPath.row)
    }
    
    func dayOfTheWeekButtonDidTap(cell: UITableViewCell, tag: Int) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeDayOfTheWeek(index: cellIndexPath.row, tag: tag)
    }
    
    func userMessageTextFieldEndEditing(cell: UITableViewCell, text: String) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeUserMessage(index: cellIndexPath.row, text: text)
    }
    
    func timeTextFieldEndEditing(cell: UITableViewCell, time: Date) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeTime(index: cellIndexPath.row, time: time)
        alarmTableView.scrollToRow(at: IndexPath(row: viewModel.changedCellIndex, section: 0), at: .top, animated: true)
    }
}
