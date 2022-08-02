//
//  AlramDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import Foundation

class AlarmDIContainer {
    func makeAlarmViewController() -> AlarmViewController {
        return AlarmViewController(viewModel: makeAlarmViewModel())
    }
    
    func makeAlarmViewModel() -> AlarmViewModel {
        return AlarmViewModel(searchRowPositionFactory: SearchRowPositionFactory())
    }
}
