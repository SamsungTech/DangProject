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
        collectionView.isPrefetchingEnabled = false
        
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
        viewModel?.calendarData
            .subscribe(onNext: { data in
                self.calendarCollectionView.reloadData()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.identifier, for: indexPath) as? DaysCollectionViewCell else { return UICollectionViewCell() }
        
        if let data = self.viewModel?.calendarData.value {
            let viewModel = DaysCellViewModel(calendarData: data, indexPathItem: indexPath.item)
            cell.bind(viewModel: viewModel)
            if data.isCurrentDayArray?[indexPath.item] == true {
                cell.dayLabel.textColor = .white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedDangData = viewModel?.calendarData.value.dangArray?[indexPath.item],
              let selectedMaxDangData = viewModel?.calendarData.value.maxDangArray?[indexPath.item],
              let circlePercentValue = homeViewModel?.calculatePercentValue(dang: selectedDangData,
                                                                            maxDang: selectedMaxDangData),
              let circleDangValue = homeViewModel?.calculateMonthDangDataNumber(dang: selectedDangData,
                                                                                maxDang: selectedMaxDangData),
              let circleColor = homeViewModel?.calculateCircleProgressBarColor(dang: selectedDangData,
                                                                               maxDang: selectedMaxDangData),
              let circleBackgroundColor = homeViewModel?.calculateCircleProgressBackgroundColor(dang: selectedDangData,
                                                                                                maxDang: selectedMaxDangData),
              let animationLineColor = homeViewModel?.calculateCirclePercentLineColor(dang: selectedDangData,
                                                                                      maxDang: selectedMaxDangData) else { return }
        
        homeViewModel?.circleDangValue.accept(circleDangValue)
        homeViewModel?.circlePercentValue.accept(circlePercentValue)
        homeViewModel?.selectedDangValue.accept(String(selectedDangData))
        homeViewModel?.selectedMaxDangValue.accept(String(selectedMaxDangData))
        homeViewModel?.selectedCircleColor.accept(circleColor)
        homeViewModel?.selectedCircleBackgroundColor.accept(circleBackgroundColor)
        homeViewModel?.selectedAnimationLineColor.accept(animationLineColor)
        homeViewModel?.didTapCell()
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
