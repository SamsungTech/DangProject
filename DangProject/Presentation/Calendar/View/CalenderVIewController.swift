//
//  CalenderVIewController.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/17.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: CalendarView customNavigationBar랑 합치기
class CalendarViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        autoLayout()
        view.bringSubviewToFront(testAnimationButton)
        view.backgroundColor = .white
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
        testAnimationButton.do {
            $0.rx.tap
                .bind {
                    self.collectionViewAnimation()
                }
                .disposed(by: disposeBag)
            $0.backgroundColor = .blue
        }
    }
    
    private func calculation() { // 월 별 일 수 계산
        let firstDay = calendar.date(from: dateComponents)
        let firstWeekDay = calendar.component(.weekday, from: firstDay!)
        
        print("firstDay: " + "\(firstDay)" + "firstWeekday : " + "\(firstWeekDay)")
        
        daysCount = calendar.range(of: .day, in: .month, for: firstDay!)!.count
        startDay = 2 - firstWeekDay
        
        print(daysCount)
        print(startDay)
        
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
        [ calendarCollectionView, testAnimationButton ].forEach() { view.addSubview($0) }
        
        calendarCollectionView.do {
            $0.frame = CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY)
        }
        testAnimationButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
    }
    
    private func collectionViewAnimation() {
        self.calendarCollectionView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.calendarCollectionView.do {
                $0.frame = CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.maxX, height: 0)
            }
        }
        
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return self.days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        switch indexPath.section {
        case 0:
            cell.dayLabel.text = weeks[indexPath.item]
        default:
            cell.dayLabel.text = days[indexPath.item]
        }
        
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
}
