//
//  AlramViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

import RxSwift
import RxCocoa

enum CellAmountState{
    case plus
    case minus
    case none
}

enum EatenTimeAlertController {
    case morning
    case lunch
    case dinner
    case snack
}

class AlarmViewController: UIViewController {
    weak var coordinator: AlarmCoordinator?
    private let disposeBag = DisposeBag()
    private var viewModel: AlarmViewModel
    private var navigationBar = AlarmNavigationBar()
    private var alarmTableView = UITableView()
    
    private lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "기록되지 않았을 때 미리 알림받기", message: nil, preferredStyle: .actionSheet)
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
        configureUI()
        bind()
    }
      
    init(viewModel: AlarmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupView()
        setupNavigationBar()
        setupAlarmTableView()
        setupInvisibleView()
        setupAlertController()
    }
    
    private func setupView() {
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
            alarmTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    private func setupAlertController() {
        let alertInstance = [EatenTimeAlertController.morning, EatenTimeAlertController.lunch, EatenTimeAlertController.dinner, EatenTimeAlertController.snack]
        alertInstance.forEach { eatenTimeAlert in
            makeAlertControllerAddAction(eatenTimeAlert: eatenTimeAlert)
        }
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    }
    
    private func makeAlertControllerAddAction(eatenTimeAlert: EatenTimeAlertController) {
        var alertActionTitle: String = ""
        var alarmDataTitle: String = ""
        var alarmDataTime: Date = .init()
        switch eatenTimeAlert {
        case .morning:
            alertActionTitle = "아침"
            alarmDataTitle = "아침 식사"
            alarmDataTime = .makeTime(hour: 7, minute: 00)
        case .lunch:
            alertActionTitle = "점심"
            alarmDataTitle = "점심 식사"
            alarmDataTime = .makeTime(hour: 12, minute: 00)
        case .dinner:
            alertActionTitle = "저녁"
            alarmDataTitle = "저녁 식사"
            alarmDataTime = .makeTime(hour: 18, minute: 00)
        case .snack:
            alertActionTitle = "간식"
            alarmDataTitle = "간식"
            alarmDataTime = .makeTime(hour: 14, minute: 00)
        }
        alertController.addAction(UIAlertAction(title: alertActionTitle,
                                                style: .default,
                                                handler: { [weak self] _ in
            let alarmData = AlarmEntity(
                isOn: true,
                title: alarmDataTitle,
                message: "",
                time: alarmDataTime,
                selectedDaysOfTheWeek: [0,1,2,3,4,5,6]
            )
            self?.viewModel.addAlarmEntity(alarmData)
        }))
    }
    
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
                self.present(self.alertController, animated: true, completion: nil)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func bindAlarmTableViewCellData() {
        var dataCount = viewModel.alarmDataArrayRelay.value.count
        viewModel.alarmDataArrayRelay
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                if data.count > dataCount {
                    self?.updateCellUI(.plus)
                    dataCount += 1
                } else {
                    self?.updateCellUI(.none)
                }
                for i in 0 ..< data.count {
                    if let cell = strongSelf.alarmTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? AlarmTableViewCell {
                        cell.setupCell(data: data[i])
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCellUI(_ cellAmountState: CellAmountState) {
        alarmTableView.performBatchUpdates {
            switch cellAmountState {
            case .plus:
                print(viewModel.addedCellIndex)
                alarmTableView.scrollToRow(at: IndexPath(row: viewModel.addedCellIndex, section: 0), at: .top, animated: true)
                // scrollToRow 가 간식 저녁 안먹힘
                alarmTableView.insertRows(at: [IndexPath(row: viewModel.addedCellIndex, section: 0)], with: UITableView.RowAnimation.none)
            case .minus:
                break
            case .none:
                break
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
        let alarmItemData = viewModel.alarmDataArrayRelay.value[indexPath.item]
        cell.setupCell(data: alarmItemData)
        cell.parentableViewController = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        viewModel.changeCellScale(index: cellIndexPath.row)
        if viewModel.cellScaleWillExpand {
            alarmTableView.scrollToRow(at: cellIndexPath, at: .top, animated: true)
        }
    }
    
    func deleteButtonDidTap(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.deleteAlarmData(cellIndexPath.row)
    }
    
    func isOnSwitchDidChanged(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeIsOnValue(index: cellIndexPath.row)
    }
    
    func everyDayButtonDidTap(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeEveryDay(index: cellIndexPath.row)
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
    }
}
