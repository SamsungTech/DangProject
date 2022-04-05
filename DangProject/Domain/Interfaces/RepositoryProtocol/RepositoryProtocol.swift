//
//  RepositoryProtocol.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation

protocol HomeRepositoryProtocol: AnyObject {
    var monthData: [MonthDangEntity] { get }
}
