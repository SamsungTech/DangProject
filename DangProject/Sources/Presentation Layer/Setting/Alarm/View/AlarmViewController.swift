//
//  AlramViewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

import RxSwift
import RxCocoa

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
        setUpView()
        setUpNavigationBar()
        setUpAlarmTableView()
        setUpAlertController()
    }
    
    private func setUpView() {
        view.backgroundColor = .homeBackgroundColor
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: yValueRatio(90))
        ])
    }
    
    private func setUpAlarmTableView() {
        view.addSubview(alarmTableView)
        alarmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alarmTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            alarmTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alarmTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            alarmTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        alarmTableView.register(AlarmTableViewCell.self,
                                forCellReuseIdentifier: AlarmTableViewCell.identifier)
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
    }
    
    private func setUpAlertController() {
        alertController.addAction(UIAlertAction(title: "아침",
                                                style: .default,
                                                handler: { [weak self] _ in
            // AlarmEntity?
            let alarmData = AlarmEntity(
                isOn: true,
                title: "아침 식사",
                time: .makeTime(hour: 8, minute: 0),
                selectedDays: "매일"
            )
        }))
        alertController.addAction(UIAlertAction(title: "점심", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "저녁", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "간식", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
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
        viewModel.alarmDataArrayRelay
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                
                for i in 0 ... data.count-1 {
                    if let cell = strongSelf.alarmTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? AlarmTableViewCell {
                        cell.setupCell(data: data[i])
                    }
                }
                self?.updateCellUI()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCellUI() {
        self.alarmTableView.beginUpdates()
        self.alarmTableView.endUpdates()
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
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func didTapDeleteButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: alarmTableView)
        guard let indexPath = alarmTableView.indexPathForRow(at: point) else { return }
        DispatchQueue.main.async {
            self.alarmTableView.beginUpdates()
            self.alarmTableView.deleteRows(at: [indexPath], with: .fade)
            self.alarmTableView.endUpdates()
        }
        self.viewModel.deleteAlarmData(indexPath)
    }
}

extension AlarmViewController: AlarmTableViewCellDelegate {
    func middleBottonButtonDidTapped(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeCellScale(index: cellIndexPath.row)
        if viewModel.cellScaleWillExpand {
            alarmTableView.scrollToRow(at: cellIndexPath, at: .top, animated: true)
        }
    }
    
    func isOnSwitchDidChanged(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeIsOnValue(index: cellIndexPath.row)
    }
    
    func everyDayButtonDidTapped(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel.changeCellScaleMoreExpand(index: cellIndexPath.row)
    }
}
