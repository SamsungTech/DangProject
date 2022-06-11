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

            self?.insertAlarmTableViewCell(alarmData)
        }))
        alertController.addAction(UIAlertAction(title: "점심", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "저녁", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "간식", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    }
    
    private func bind() {
        bindUI()
        bindAlarmTableView()
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
    
    private func bindAlarmTableView() {
        viewModel?.alarmDataArrayRelay
            .subscribe(onNext: { [weak self] data in
                for i in 0 ..< data.count {
                    if data[i].cellScale == .expand {
                        self?.alarmTableView.scrollToRow(at: [0,i], at: .top, animated: true)
                    }
                }
                
                self?.updateUI()
                
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alarmTableView.beginUpdates()
            
            self.alarmTableView.endUpdates()
        }
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.alarmDataArrayRelay.value.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewItem.identifier, for: indexPath) as? AlarmTableViewItem else { return UITableViewCell() }
        setUpCell(indexPath, cell)
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.getHeightForRow(indexPath) ?? 0 + 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func didTapDeleteButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: alarmTableView)
        guard let indexPath = alarmTableView.indexPathForRow(at: point) else { return }
//        self.viewModel?.cellScaleStateRelay.accept(.normal)
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
//        cell.bind(viewModel: viewModel)
        cell.cellDelegate = self
        cell.selectionStyle = .none
        
    }
    
    private func insertAlarmTableViewCell(_ alarmData: AlarmEntity) {
        guard let insertIndexPath = self.viewModel?.searchRowsPosition(alarmData: alarmData) else { return }
        self.viewModel?.insertAlarmData(insertIndexPath, alarmData)
        DispatchQueue.main.async {
            self.alarmTableView.beginUpdates()
            self.alarmTableView.insertRows(at: [insertIndexPath], with: .fade)
            self.alarmTableView.endUpdates()
            self.alarmTableView.scrollToRow(at: insertIndexPath, at: .top, animated: true)
        }
    }
}

extension AlarmViewController: AlarmTableViewItemDelegate {
    func middleBottomButtonDidTap(cell: UITableViewCell) {
        guard let cellIndexPath = alarmTableView.indexPath(for: cell) else { return }
        viewModel?.cellScaleWillChange(index: cellIndexPath)

    }
    
}
