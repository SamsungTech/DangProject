//
//  AccountViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import Foundation

protocol AccountViewModelInputProtocol: AnyObject {
    
}

protocol AccountViewModelOutputProtocol: AnyObject {
    
}

protocol AccountViewModelProtocol: AccountViewModelInputProtocol, AccountViewModelOutputProtocol {
    
}

class AccountViewModel: AccountViewModelProtocol {
    
    init() {}
    
}
