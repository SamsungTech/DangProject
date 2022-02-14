//
//  AteFoodCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/25.
//

import Foundation
import UIKit
import Then

struct TempData {
    var foodName: String?
    var dang: String?
    
    init(foodName: String, dang: String) {
        self.foodName = foodName
        self.dang = dang
    }
}

class AteFoodCell: UICollectionViewCell {
    static let identifier = "AteFoodCell"
    var cardView = UIView()
    lazy var foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    let tempData: [TempData] = [
        TempData.init(foodName: "닭볶음탕", dang: "20.9"),
        TempData.init(foodName: "김치말이국수", dang: "10.0"),
        TempData.init(foodName: "냉면", dang: "25.9"),
        TempData.init(foodName: "김치볶음밥", dang: "10.0"),
        TempData.init(foodName: "카페라떼", dang: "5.2")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        foodCollectionView.do {
            $0.register(AteFoodCollectionCell.self, forCellWithReuseIdentifier: AteFoodCollectionCell.identifier)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func layout() {
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

extension AteFoodCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tempData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ateFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: AteFoodCollectionCell.identifier, for: indexPath) as? AteFoodCollectionCell else { return UICollectionViewCell() }
        
        return ateFoodCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 80)
    }
}

extension AteFoodCell: UICollectionViewDelegateFlowLayout {
    
}
