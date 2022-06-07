//
//  SecessionViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

protocol SecessionViewModelInputProtocol: AnyObject {
    
}

protocol SecessionViewModelOutputProtocol: AnyObject {
    
}

protocol SecessionViewModelProtocol: SecessionViewModelInputProtocol, SecessionViewModelOutputProtocol {
    
}

class SecessionViewModel: SecessionViewModelProtocol {
    init() {}
}
