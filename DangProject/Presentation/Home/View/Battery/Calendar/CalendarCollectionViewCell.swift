//
//  CalendarCollectionView.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/23.
//

import UIKit
import RxSwift

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    private var viewModel: CalendarViewModel?
    private var homeViewModel: HomeViewModel?
    private var disposeBag = DisposeBag()
    private var testAnimationButton = UIButton()
    
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPrefetchingEnabled = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        autoLayout()
        self.bringSubviewToFront(testAnimationButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        calendarCollectionView.do {
            $0.register(DaysCollectionViewCell.self,
                        forCellWithReuseIdentifier: DaysCollectionViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
        }
    }
    
    private func autoLayout() {
        [ calendarCollectionView ].forEach() { self.addSubview($0) }
        
        calendarCollectionView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    func bind(viewModel: CalendarViewModel,
              homeViewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
        subscribe()
    }
    
    private func subscribe() {
        bindCalendarData()
        bindCurrentDayCellViewState()
        bindSelectedCellFillViewState()
        bindSelectedCalendarCellIsHidden()
        bindDeSelectedCalendarCellIsHidden()
        bindSelectedYearMonthState()
    }
    
    private func bindCalendarData() {
        viewModel?.calendarData
            .subscribe(onNext: { data in
                self.calendarCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCurrentDayCellViewState() {
        viewModel?.currentDayCellLineViewState
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .normal(let cell):
                    self?.setUpCurrentDayLineViewNormalColor(cell: cell)
                case .hidden(let cell):
                    self?.setUpCurrentDayLineViewHiddenColor(cell: cell)
                case .empty: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedCellFillViewState() {
        viewModel?.selectedCellFillViewState
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .normal(let collectionView, let cell, let indexPath):
                    self?.setUpSelectedCellFillNormalColorView(collectionView: collectionView,
                                                               cell: cell,
                                                               indexPath: indexPath)
                case .hidden(let cell):
                    self?.setUpSelectedCellFillHiddenView(cell: cell)
                case .empty: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedCalendarCellIsHidden() {
        viewModel?.selectedCalendarCellIsHidden
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .selectedTrue(let collectionView):
                    self?.setUpDidSelectedItemIsHiddenTrue(collectionView: collectionView)
                case .selectedFalse(let collectionView, let indexPath):
                    self?.setUpDidSelectedItemIsHiddenFalse(collectionView: collectionView,
                                                            indexPath: indexPath)
                case .empty: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDeSelectedCalendarCellIsHidden() {
        viewModel?.deSelectedCalendarCellIsHidden
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .DeSelectedTrue: break
                case .DeSelectedFalse(let collectionView, let indexPath):
                    self?.setUpDidDeSelectedItemIsHidden(collectionView: collectionView,
                                                         indexPath: indexPath)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedYearMonthState() {
        viewModel?.selectedYearMonthState
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .match(let collectionView, let indexPath, let cell):
                    self?.setUpMatchedSelectedView(collectionView: collectionView,
                                                   indexPath: indexPath,
                                                   cell: cell)
                case .differ: break
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension CalendarCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.identifier,
                                                            for: indexPath) as? DaysCollectionViewCell,
              let data = self.viewModel?.calendarData.value else { return UICollectionViewCell() }
        
        let viewModel = DaysCellViewModel(calendarData: data, indexPathItem: indexPath.item)
        cell.bind(viewModel: viewModel)
        setUpCalendarCollectionViewCell(indexPath: indexPath,
                                        cell: cell,
                                        collectionView: collectionView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel?.calculateSelectedItemIsHiddenValue(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        viewModel?.calculateDeSelectedItemIsHiddenValue(collectionView: collectionView, indexPath: indexPath)
    }
}

extension CalendarCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: xValueRatio(55), height: yValueRatio(60))
    }
}

extension CalendarCollectionViewCell {
    private func setUpCalendarCollectionViewCell(indexPath: IndexPath,
                                                 cell: DaysCollectionViewCell,
                                                 collectionView: UICollectionView) {
        guard let yearMonth = viewModel?.calendarData.value.yearMonth else { return }
        
        setUpCurrentDayLineViewCell(indexPath: indexPath,
                                    yearMonth: yearMonth,
                                    cell: cell)
        setUpViewWithSelectedDayData(indexPath: indexPath,
                                     yearMonth: yearMonth,
                                     cell: cell,
                                     collectionView: collectionView)
    }
    
    private func setUpCurrentDayLineViewCell(indexPath: IndexPath,
                                             yearMonth: String,
                                             cell: DaysCollectionViewCell) {
        guard let currentCount = homeViewModel?.currentCount.value,
              let currentYearMonth = homeViewModel?.currentYearMonth.value else { return }
        
        viewModel?.compareCurrentDayCellData(indexPath: indexPath,
                                             yearMonth: yearMonth,
                                             cell: cell,
                                             currentCount: currentCount,
                                             currentYearMonth: currentYearMonth)
    }
    
    private func setUpCurrentDayLineViewNormalColor(cell: DaysCollectionViewCell) {
        cell.currentLineView.layer.borderColor = UIColor.currentDayCellLineViewColor
    }
    
    private func setUpCurrentDayLineViewHiddenColor(cell: DaysCollectionViewCell) {
        cell.currentLineView.layer.borderColor = UIColor.currentDayCellLineViewHiddenColor
    }
    
    private func setUpViewWithSelectedDayData(indexPath: IndexPath,
                                              yearMonth: String,
                                              cell: DaysCollectionViewCell,
                                              collectionView: UICollectionView) {
        guard let selectedCellIndexPath = homeViewModel?.selectedCellData.value.indexPath?.item,
              let selectedCellYearMonth = homeViewModel?.selectedCellData.value.yearMonth else { return }
        
        viewModel?.compareSelectedDayCellData(indexPath: indexPath,
                                              yearMonth: yearMonth,
                                              cell: cell,
                                              collectionView: collectionView,
                                              selectedCellIndexPath: selectedCellIndexPath,
                                              selectedCellYearMonth: selectedCellYearMonth)
    }
    
    private func setUpSelectedCellFillNormalColorView(collectionView: UICollectionView,
                                                      cell: DaysCollectionViewCell,
                                                      indexPath: IndexPath) {
        cell.selectedView.backgroundColor = .selectedCellViewColor
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
    }
    
    private func setUpSelectedCellFillHiddenView(cell: DaysCollectionViewCell) {
        cell.selectedView.backgroundColor = .selectedCellViewHiddenColor
    }
    
    private func setUpDidSelectedItemIsHiddenFalse(collectionView: UICollectionView,
                                                   indexPath: IndexPath) {
        guard let selectedDangData = viewModel?.calendarData.value.dangArray?[indexPath.item],
              let selectedMaxDangData = viewModel?.calendarData.value.maxDangArray?[indexPath.item],
              let selectedYearMonth = viewModel?.calendarData.value.yearMonth,
              let cell = collectionView.cellForItem(at: indexPath) as? DaysCollectionViewCell else { return }
        
        homeViewModel?.didTapCalendarViewCell(selectedDangData: selectedDangData,
                                              selectedMaxDangData: selectedMaxDangData)
        homeViewModel?.resetBatteryViewMainCircleProgressBar()
        homeViewModel?.selectedCellData.accept(SelectedCalendarCellEntity(yearMonth: selectedYearMonth,
                                                                          indexPath: indexPath))
        cell.selectedView.backgroundColor = .selectedCellViewColor
    }
    
    private func setUpDidSelectedItemIsHiddenTrue(collectionView: UICollectionView) {
        guard let indexPath = homeViewModel?.selectedCellData.value.indexPath,
              let selectedYearMonth = homeViewModel?.selectedCellData.value.yearMonth,
              let cell = collectionView.cellForItem(at: indexPath) as? DaysCollectionViewCell else { return }
        
        viewModel?.compareSelectedYearMonthData(collectionView: collectionView,
                                                selectedYearMonth: selectedYearMonth,
                                                indexPath: indexPath,
                                                cell: cell)
    }
    
    private func setUpMatchedSelectedView(collectionView: UICollectionView,
                                          indexPath: IndexPath,
                                          cell: DaysCollectionViewCell) {
        cell.selectedView.backgroundColor = .selectedCellViewColor
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
    }
    
    
    private func setUpDidDeSelectedItemIsHidden(collectionView: UICollectionView,
                                                indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DaysCollectionViewCell else { return }
        
        cell.selectedView.backgroundColor = .selectedCellViewHiddenColor
    }
}
