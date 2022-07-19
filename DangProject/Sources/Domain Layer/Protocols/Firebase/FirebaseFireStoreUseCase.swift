//
//  FirebaseFireStoreUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

import RxSwift

protocol FirebaseFireStoreUseCase {
    var profileExistenceObservable: PublishSubject<Bool> { get }
    var yearMonthDayDataSubject: PublishSubject<GraphData> { get }
    func uploadFirebaseUID(uid: String)
    func uploadProfile(profile: ProfileDomainModel)
    func getProfileExistence(uid: String) -> Observable<Bool>
    func uploadEatenFood(eatenFood: FoodDomainModel)
    func getEatenFoods(dateComponents : DateComponents) -> Observable<[FoodDomainModel]>
    func getProfileData() -> Observable<ProfileDomainModel>
    func updateProfileData(_ data: ProfileDomainModel)
    func createGraphThisYearMonthDayData()
    func uploadDangAverage(_ data: Int)
}
