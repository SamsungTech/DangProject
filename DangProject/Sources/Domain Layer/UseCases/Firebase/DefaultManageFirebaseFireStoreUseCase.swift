//
//  FirebaseFireStoreManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import RxSwift
import UIKit
import RxRelay

import FirebaseFirestore

class DefaultManageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let fireStoreManagerRepository: FireStoreManagerRepository
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
        
    let profileExistenceObservable = PublishSubject<Bool>()
    
    func uploadFirebaseUID(uid: String) {
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: uid, ProfileExistence: false)
    }
    
    func uploadProfile(profile: ProfileDomainModel) {
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: profile.uid, ProfileExistence: true)
        fireStoreManagerRepository.saveProfileDocument(profile: profile)
    }
    
    func getProfileExistence(uid: String) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            self?.fireStoreManagerRepository.checkProfileField(with: "profileExistence", uid: uid) {  profileExist in
                if profileExist {
                    emitter.onNext(true)
                } else {
                    emitter.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func getProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getProfileDataInFireStore()
                .subscribe(onNext: { profileData in
                    var domainProfileData = ProfileDomainModel.empty
                    for (key, value) in profileData {
                        switch key {
                        case "name": domainProfileData.name = value as? String ?? ""
                        case "gender": domainProfileData.gender = value as? String ?? ""
                        case "sugarLevel": domainProfileData.sugarLevel = value as? Int ?? 0
                        case "uid": domainProfileData.uid = value as? String ?? ""
                        case "weight": domainProfileData.weight = value as? Int ?? 0
                        case "height": domainProfileData.height = value as? Int ?? 0
                        case "birthDay": domainProfileData.birthday = value as? String ?? ""
                        default: break
                        }
                    }
                    emitter.onNext(domainProfileData)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    func updateProfileData(_ data: ProfileDomainModel) {
        fireStoreManagerRepository.saveProfileDocument(profile: data)
    }
    
    func getEatenFoods(dateComponents: DateComponents) -> Observable<[FoodDomainModel]> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getEatenFoodsInFirestore(dateComponents: dateComponents)
                .subscribe(onNext: { foodData in
                    var addedFoodDomainModel = [FoodDomainModel]()
                    foodData.forEach { foods in
                        var foodModel = FoodDomainModel.empty
                        for (key, value) in foods {
                            switch key {
                            case "name": foodModel.name = value as? String ?? ""
                            case "sugar": foodModel.sugar = value as? Double ?? 0
                            case "foodCode": foodModel.foodCode = value as? String ?? ""
                            case "amount": foodModel.amount = value as? Int ?? 0
                            case "favorite": foodModel.favorite = value as? Bool ?? false
                            case "eatenTime": foodModel.eatenTime = value as? Timestamp ?? Timestamp.init()
                            default:
                                break
                            }
                        }
                        addedFoodDomainModel.append(foodModel)
                    }
                    emitter.onNext(addedFoodDomainModel)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
        
    }
    
    func uploadEatenFood(eatenFood: FoodDomainModel) {
        fireStoreManagerRepository.saveEatenFood(eatenFood: eatenFood)
    }
}
