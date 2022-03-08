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
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    private var testAnimationButton = UIButton()
    private var disposeBag = DisposeBag()
    
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
    
    func bind(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
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
        guard let count = viewModel?.calendarData.value.calendar?.days?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: xValueRatio(55), height: yValueRatio(60))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.identifier, for: indexPath) as? DaysCollectionViewCell else { return UICollectionViewCell() }
        if let data = viewModel?.calendarData.value.calendar?.days?[indexPath.item] {
            let viewModel = CalendarCellViewModel(calendarData: CalendarCellEntity(days: data))
            cell.bind(viewModel: viewModel)
        }
        return cell
    }
}

extension CalendarCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

