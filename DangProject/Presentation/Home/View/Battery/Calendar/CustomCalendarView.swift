//
//  CustomCalendarView.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/23.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: CalendarView customNavigationBar랑 합치기
class CustomCalendarView: UIView {
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    var yearMonthLabel = UILabel()
    let currentDate = Date()
    var calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var dateComponents = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var daysCount = 0
    var startDay = 0
    
    var testAnimationButton = UIButton()
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        autoLayout()
        self.bringSubviewToFront(testAnimationButton)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        calendarCollectionView.do {
            $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .systemMint
        }
        dateFormatter.dateFormat = "yyyy년 M월"
        dateComponents.year = calendar.component(.year, from: currentDate)
        dateComponents.month = calendar.component(.month, from: currentDate)
        dateComponents.day = 1
        self.calculation()
    }
    
    private func calculation() { // 월 별 일 수 계산
        let firstDay = calendar.date(from: dateComponents)
        let firstWeekDay = calendar.component(.weekday, from: firstDay!)
        
        daysCount = calendar.range(of: .day, in: .month, for: firstDay!)!.count
        startDay = 2 - firstWeekDay
        
        self.yearMonthLabel.text = dateFormatter.string(from: firstDay!)
        self.days.removeAll()
        for day in startDay...daysCount {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
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
}

extension CustomCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        cell.dayLabel.text = days[indexPath.item]
        return cell
    }
}

extension CustomCalendarView: UICollectionViewDelegateFlowLayout {
    
}
