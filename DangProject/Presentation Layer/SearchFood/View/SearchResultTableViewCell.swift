//
//  DetailFoodTableViewCell.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation
import UIKit

protocol TableViewCellDelegate {
    func favoriteButtonTapped(cell: UITableViewCell)
}

class SearchResultTableViewCell: UITableViewCell {
    
    var cellDelegation: TableViewCellDelegate?
    let titleLabel = UILabel()
    let favoriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        
        setUpTitleLabel()
        setUpFavoriteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        titleLabel.textColor = .black
    }
    
    func setUpFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)

        favoriteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        cellDelegation?.favoriteButtonTapped(cell: self)
    }
}
