//
//  CalendarCollectionViewCell.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/17.
//

import Foundation
import UIKit
import RxSwift

class DaysCollectionViewCell: UICollectionViewCell {
    static let identifier = "DaysCollectionViewCell"
    private var viewModel: CalendarCellViewModel?
    private var dayLabel = UILabel()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dayLabel.do {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        self.contentView.backgroundColor = .clear
    }
    
    private func layout() {
        [ dayLabel ].forEach() { self.addSubview($0) }
        
        dayLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
    
    func bind(viewModel: CalendarCellViewModel) {
        self.viewModel = viewModel
        subscribe()
    }
    
    private func subscribe() {
        viewModel?.calendarData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.dayLabel.text = data.days
            })
            .disposed(by: disposeBag)
    }
}
