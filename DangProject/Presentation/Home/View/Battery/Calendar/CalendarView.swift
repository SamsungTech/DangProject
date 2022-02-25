//
//  CalendarCollectionView.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/23.
//

import UIKit
import RxSwift

class CalendarView: UIView {
    static let identifier = "CalendarCollectionView"
    var viewModel: BatteryCellViewModel?
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    var testAnimationButton = UIButton()
    var disposeBag = DisposeBag()
    
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
            $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
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
    
    func bind(viewModel: BatteryCellViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {}
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.batteryData.value.days?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        guard let day = viewModel?.batteryData.value.days?[indexPath.item] else { return UICollectionViewCell() }
        cell.dayLabel.text = day
        return cell
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    
}

