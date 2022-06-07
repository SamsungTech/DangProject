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
    private var viewModel: AlarmViewModel?
    weak var coordinator: AlarmCoordinator?
    private let disposeBag = DisposeBag()
    private var navigationBar = AlarmNavigationBar()
    private var selectedIndexPath = IndexPath(row: -1, section: 0)
    private var deSelectedIndexPath = IndexPath(row: -1, section: 0)
    private lazy var alarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlarmTableViewItem.self,
                           forCellReuseIdentifier: AlarmTableViewItem.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "기록되지 않았을 때 미리 알림받기", message: nil, preferredStyle: .actionSheet)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        configureUI()
        bind()
    }
    
    init(viewModel: AlarmViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
    }
    
    private func setUpAlertController() {
        alertController.addAction(UIAlertAction(title: "아침",
                                                style: .default,
                                                handler: { [weak self] _ in
            let alarmData = AlarmEntity(
                isOn: true,
                title: "아침 식사",
                time: "10:00",
                selectedDays: "매일"
            )
            self?.resetAlarmTableViewCellScale()
            self?.insertAlarmTableViewCell(alarmData)
        }))
        alertController.addAction(UIAlertAction(title: "점심", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "저녁", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "간식", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    }
    
    private func bind() {
        bindUI()
        bindAlarmTableViewItem()
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
    
    private func bindAlarmTableViewItem() {
        viewModel?.setUpCellStateRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .expand(let cell):
                    cell.setUpCellExpand()
                case .normal(let cell):
                    cell.setUpCellNormal()
                case .none: break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource, AlarmTableViewItemDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.alarmDataArrayRelay.value.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewItem.identifier, for: indexPath) as? AlarmTableViewItem else { return UITableViewCell() }
        setUpCell(indexPath, cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewModel?.branchOutHeightForRow(indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AlarmTableViewItem else { return }
        alarmTableViewCellDidTap(tableView, indexPath)
        viewModel?.branchOutSetUpCell(selectedIndexPath, indexPath, cell)
        selectedIndexPath = indexPath
        guard let cell2 = tableView.cellForRow(at: self.deSelectedIndexPath) as? AlarmTableViewItem else { return }
        cell2.setUpCellNormal()
        self.deSelectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselectedIndexPath", indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) as? AlarmTableViewItem else { return }
        cell.setUpCellNormal()
    }
    
    func didTapDaysButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alarmTableView.beginUpdates()
            self.viewModel?.branchOutMoreExpand()
            self.alarmTableView.endUpdates()
        }
    }
    
    func didTapDeleteButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: alarmTableView)
        guard let indexPath = alarmTableView.indexPathForRow(at: point) else { return }
        self.viewModel?.cellScaleStateRelay.accept(.normal)
        self.viewModel?.selectedIndexRelay.accept(IndexPath(row: -1, section: 0))
        DispatchQueue.main.async {
            self.alarmTableView.beginUpdates()
            self.alarmTableView.deleteRows(at: [indexPath], with: .fade)
            self.alarmTableView.endUpdates()
        }
        self.viewModel?.deleteAlarmData(indexPath)
    }
}

extension AlarmViewController {
    private func setUpCell(_ indexPath: IndexPath,
                           _ cell: AlarmTableViewItem) {
        guard let alarmItemEntity = viewModel?.alarmDataArrayRelay.value[indexPath.item] else { return }
        let viewModel = AlarmTableViewItemViewModel(alarmItemEntity: alarmItemEntity)
        cell.bind(viewModel: viewModel)
        cell.delegate = self
        cell.selectionStyle = .none
        
    }
    
    private func alarmTableViewCellDidTap(_ tableView: UITableView, _ indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.beginUpdates()
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.viewModel?.branchOutSelectedIndex(indexPath)
            tableView.endUpdates()
        }
    }
    
    private func insertAlarmTableViewCell(_ alarmData: AlarmEntity) {
        guard let insertIndexPath = self.viewModel?.searchRowsPosition(alarmData: alarmData) else { return }
        self.viewModel?.insertAlarmData(insertIndexPath, alarmData)
        DispatchQueue.main.async {
            self.alarmTableView.beginUpdates()
            self.alarmTableView.insertRows(at: [insertIndexPath], with: .fade)
            self.alarmTableView.endUpdates()
            self.alarmTableView.scrollToRow(at: insertIndexPath, at: .top, animated: true)
            self.alarmTableView.delegate?.tableView?(self.alarmTableView, didDeselectRowAt: self.deSelectedIndexPath)
            self.alarmTableView.delegate?.tableView?(self.alarmTableView, didSelectRowAt: insertIndexPath)
            
            self.deSelectedIndexPath = insertIndexPath
        }
    }
    
    private func resetAlarmTableViewCellScale() {
        guard let count = viewModel?.alarmDataArrayRelay.value.count else { return }

        for i in 0..<count {
            
            guard let cell = alarmTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? AlarmTableViewItem else { return }
            cell.setUpCellNormal()
            viewModel?.cellScaleStateRelay.accept(.normal)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.alarmTableView.beginUpdates()
            self?.alarmTableView.endUpdates()
        }
    }
}
