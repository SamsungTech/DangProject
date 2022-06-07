//
//  TermViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

protocol TermViewModelInputProtocol: AnyObject {
    
}

protocol TermViewModelOutputProtocol: AnyObject {
    
}

protocol TermViewModelProtocol: TermViewModelInputProtocol, TermViewModelOutputProtocol {}

class TermViewModel: TermViewModelProtocol {
    init() {}
}
