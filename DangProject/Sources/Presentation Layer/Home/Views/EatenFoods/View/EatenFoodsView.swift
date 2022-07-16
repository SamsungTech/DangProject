//
//  AteFoodCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import UIKit
import RxSwift

class EatenFoodsView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: EatenFoodsViewModel
    
    private lazy var foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    // MARK: - Init
    init(viewModel: EatenFoodsViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        layout()
        configure()
        bindEatenFoods()
        self.backgroundColor = .clear
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func configure() {
        foodCollectionView.register(EatenFoodsCollectionViewCell.self, forCellWithReuseIdentifier: EatenFoodsCollectionViewCell.identifier)
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
    
    private func bindEatenFoods() {
        viewModel.eatenFoodsViewModelObservable
            .subscribe(onNext: { [weak self] eatenFoods in
                self?.foodCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension EatenFoodsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.eatenFoodsViewModelObservable.value.eatenFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = viewModel.eatenFoodsViewModelObservable.value.eatenFoods
        guard let eatenFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: EatenFoodsCollectionViewCell.identifier, for: indexPath) as? EatenFoodsCollectionViewCell else { return UICollectionViewCell() }
        
        eatenFoodCell.setupCell(data: data[indexPath.row])

        eatenFoodCell.contentView.layer.masksToBounds = true
        eatenFoodCell.contentView.layer.cornerRadius = xValueRatio(20)
        eatenFoodCell.contentView.backgroundColor = .homeBoxColor
        
        return eatenFoodCell
    }
}

extension EatenFoodsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: xValueRatio(150), height: yValueRatio(110))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
