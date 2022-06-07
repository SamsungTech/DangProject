//
//  AteFoodCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import UIKit
import RxSwift

class AteFoodView: UIView {
    static let identifier = "AteFoodCell"
    private var viewModel: AteFoodViewModel?
    private var disposeBag = DisposeBag()
    private var cardView = UIView()
    lazy var foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        foodCollectionView.register(AteFoodCollectionCell.self, forCellWithReuseIdentifier: AteFoodCollectionCell.identifier)
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.backgroundColor = .clear
        foodCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    private func layout() {
        [ foodCollectionView ].forEach() { self.addSubview($0) }
        
        foodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        foodCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        foodCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        foodCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        foodCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
}

extension AteFoodView {
    func bind(viewModel: AteFoodViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    private func subscribe() {}
}

extension AteFoodView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let tempDataCount = viewModel?.items.value.dangArray.count else { return 0 }
        
        return tempDataCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let ateFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: AteFoodCollectionCell.identifier, for: indexPath) as? AteFoodCollectionCell else { return UICollectionViewCell() }
        
        if let dang = viewModel?.items.value.dangArray[indexPath.item],
           let foodName = viewModel?.items.value.foodNameArray[indexPath.item] {
            let viewModel = AteFoodCellInItemViewModel(
                item: AteFoodCellEntity.init(dang: dang, foodName: foodName)
            )
            ateFoodCell.bind(viewModel: viewModel)
        }
        
        ateFoodCell.contentView.layer.masksToBounds = true
        ateFoodCell.contentView.layer.cornerRadius = xValueRatio(20)
        ateFoodCell.contentView.backgroundColor = .homeBoxColor
        
        return ateFoodCell
    }
}

extension AteFoodView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: xValueRatio(150), height: yValueRatio(80))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
