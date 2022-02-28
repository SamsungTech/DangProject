//
//  HomeFactory.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/28.
//

import Foundation
import UIKit

enum viewModelFactory {
    case batteryCellItemViewModel
    case batteryCellDataViewModel
    case ateFoodItemViewModel
    case ateFoodCellInItemViewModel
    case graphItemViewModel
    case calendarViewModel
}

enum viewFactory {
    case calendarView
    case batteryView
    case ateFoodView
    case homeGraphView
}

enum cellFactory {
    case calendarCollectionViewCell
    case ateFoodCollectionCell
}

protocol ViewModelFactoryProtocol {
    
}

protocol ViewFactoryProtocol {
    
}

protocol CellFactoryProtocol {
    func bind(viewModel: ViewModelFactoryProtocol)
}

protocol HomeFactoryProtocol {
//    func createViewModel(viewModelType: viewModelFactory) -> ViewModelFactoryProtocol
//    
//    func createView(viewType: viewFactory) -> ViewFactoryProtocol
    
    func createCell(cellType: cellFactory,
                    collectionView: UICollectionView,
                    indexPath: IndexPath) -> UICollectionViewCell
}

class HomeFactory: HomeFactoryProtocol {
//    func createViewModel(viewModelType: viewModelFactory) -> ViewModelFactoryProtocol {
//        switch viewModelType {
//        case .calendarViewModel:
//
//            return CalendarViewModel(calendarData: <#T##CalendarStackViewEntity#>)
//
//        case .batteryCellItemViewModel:
//
//            return BatteryCellViewModel(item: <#T##sugarSum#>)
//
//        case .batteryCellDataViewModel:
//
//            return BatteryCellViewModel(batteryData: <#T##BatteryEntity#>)
//
//        case .ateFoodItemViewModel:
//            <#code#>
//        case .ateFoodCellInItemViewModel:
//            <#code#>
//        case .graphItemViewModel:
//            <#code#>
//        }
//    }
//
//    func createView(viewType: viewFactory) -> ViewFactoryProtocol {
//        <#code#>
//    }
    
    func createCell(cellType: cellFactory,
                    collectionView: UICollectionView,
                    indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType {
        case .ateFoodCollectionCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AteFoodCollectionCell.identifier, for: indexPath) as? AteFoodCollectionCell else { return UICollectionViewCell() }
            return cell
        case .calendarCollectionViewCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    
}
