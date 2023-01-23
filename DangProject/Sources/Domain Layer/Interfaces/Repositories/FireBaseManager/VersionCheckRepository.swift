//
//  VersionCheckRepository.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/23.
//

import Foundation

protocol VersionCheckRepository: AnyObject {
    func isUpdateAvailable(completion: @escaping (VersionData, Error?) -> Void)
}
