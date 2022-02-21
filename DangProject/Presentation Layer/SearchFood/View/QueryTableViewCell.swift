//
//  QueryTableViewCell.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/22.
//

import Foundation
import UIKit

class QueryTableViewCell: UITableViewCell {
    
    let queryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUpQueryLabel()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpQueryLabel() {
        self.addSubview(queryLabel)
        queryLabel.translatesAutoresizingMaskIntoConstraints = false
        queryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        queryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        queryLabel.textColor = .black
    }
}
