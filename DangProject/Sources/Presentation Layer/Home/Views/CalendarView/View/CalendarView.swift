//
//  CalendarCollectionView.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/20.
//
import Foundation
import UIKit

import RxCocoa
import RxSwift
import RxRelay

protocol CalendarViewDelegate {
    func fetchEatenFoodsPerMonths(_ dateComponents: DateComponents )
    func cellDidSelected(dateComponents: DateComponents, cellIndexColumn: Int)
}

class CalendarView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel: CalendarViewModelProtocol
    private let screenWidthSize = UIScreen.main.bounds.maxX
    var parentableViewController: CalendarViewDelegate?
    
    let calendarScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var currentCalendarCollectionView = makeCollectionView()
    lazy var previousCalendarCollectionView = makeCollectionView()
    lazy var nextCalendarCollectionView = makeCollectionView()
    lazy var selectedLeadingCalendarCollectionView = makeCollectionView()
    lazy var selectedTrailingCalendarCollectionView = makeCollectionView()
    
    init(viewModel: CalendarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        configureViews()
        binding()
        makeContentOffsetCentered()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(calendarScrollView)
        calendarScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        calendarScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        calendarScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        calendarScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        calendarScrollView.contentLayoutGuide.widthAnchor.constraint(equalToConstant: screenWidthSize*5).isActive = true
        calendarScrollView.backgroundColor = .black
        calendarScrollView.delegate = self
        
        configureCollectionView(collectionView: selectedLeadingCalendarCollectionView, section: 0)
        configureCollectionView(collectionView: previousCalendarCollectionView, section: 1)
        configureCollectionView(collectionView: currentCalendarCollectionView, section: 2)
        configureCollectionView(collectionView: nextCalendarCollectionView, section: 3)
        configureCollectionView(collectionView: selectedTrailingCalendarCollectionView, section: 4)
    }
    
    private func binding() {
        
        viewModel.currentDataObservable
            .bind(to: currentCalendarCollectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.identifier, cellType: CalendarCollectionViewCell.self)) { index, data, cell in
                cell.configureCell(data: data)
                cell.configureShapeLayer(data: data)
            }
            .disposed(by: disposeBag)
        
        viewModel.previousDataObservable
            .bind(to: previousCalendarCollectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.identifier, cellType: CalendarCollectionViewCell.self)) { index, data, cell in
                cell.configureCell(data: data)
            }
            .disposed(by: disposeBag)
        
        viewModel.nextDataObservable
            .bind(to: nextCalendarCollectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.identifier, cellType: CalendarCollectionViewCell.self)) { index, data, cell in
                cell.configureCell(data: data)
            }
            .disposed(by: disposeBag)
        
        currentCalendarCollectionView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.changeCurrentCell(index: indexPath.item)
                
                guard let dateComponents = self?.viewModel.selectedDateComponents else { return }
                self?.parentableViewController?.cellDidSelected(dateComponents: dateComponents,
                                                                cellIndexColumn: indexPath.item/7)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.maxX/7), height: yValueRatio(60))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .homeBackgroundColor
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPrefetchingEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func configureCollectionView(collectionView: UICollectionView, section: CGFloat) {
        calendarScrollView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: calendarScrollView.leadingAnchor, constant: screenWidthSize*section).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: screenWidthSize).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: yValueRatio(360)).isActive = true
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collectionView.delegate = self
    }
    
    private func makeContentOffsetCentered() {
        calendarScrollView.setContentOffset(CGPoint(x: screenWidthSize*2, y: 0), animated: false)
        self.layoutIfNeeded()
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layoutcollectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width)/7,
                      height: (collectionView.frame.height)/6)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CalendarView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = targetContentOffset.pointee.x / screenWidthSize
        switch page {
        case 1:
            viewModel.scrollDirection = .left
        case 3:
            viewModel.scrollDirection = .right
        default:
            viewModel.scrollDirection = .center
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.checkScrollViewDirection()
        parentableViewController?.fetchEatenFoodsPerMonths(viewModel.currentDateComponents)
        calendarScrollView.setContentOffset(CGPoint(x: screenWidthSize*2, y: 0), animated: false)
    }
}
