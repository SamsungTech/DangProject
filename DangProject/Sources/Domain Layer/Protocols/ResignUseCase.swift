//
//  ResignUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/10/03.
//

import Foundation

protocol ResignUseCase {
    func deleteAllUserData(completion: @escaping (Bool) -> Void)
}
