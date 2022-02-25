//
//  AteFoodCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit
import Then
import RxSwift

class AteFoodView: UIView {
    static let identifier = "AteFoodCell"
    var viewModel: AteFoodItemViewModel?
    private var cardView = UIView()
    lazy var foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    private var disposeBag = DisposeBag()
    
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
        foodCollectionView.do {
            $0.register(AteFoodCollectionCell.self, forCellWithReuseIdentifier: AteFoodCollectionCell.identifier)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func layout() {
        [ foodCollectionView ].forEach() { self.addSubview($0) }
        
        foodCollectionView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
}

extension AteFoodView {
    func bind(viewModel: AteFoodItemViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.items
            .subscribe(onNext: { foodData in
                self.foodCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension AteFoodView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let tempDataCount = viewModel?.items.value.count else { return 0 }
        return tempDataCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ateFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: AteFoodCollectionCell.identifier, for: indexPath) as? AteFoodCollectionCell else { return UICollectionViewCell() }
        
        if let data = viewModel?.items.value[indexPath.item] {
            let viewModel = AteFoodCellInItemViewModel(item: data)
            ateFoodCell.bind(viewModel: viewModel)
        }
        ateFoodCell.contentView.layer.masksToBounds = true
        ateFoodCell.contentView.layer.cornerRadius = 20
        ateFoodCell.backgroundColor = .systemYellow
        return ateFoodCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 80)
    }
}

extension AteFoodView: UICollectionViewDelegateFlowLayout {
    
}
