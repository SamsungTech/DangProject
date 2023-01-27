//
//  FirebaseFireStoreManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import UIKit

import FirebaseFirestore
import RxRelay
import RxSwift

class DefaultManageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let fireStoreManagerRepository: FireStoreManagerRepository
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
        
    // MARK: - Internal
    let profileExistenceObservable = PublishSubject<Bool>()
    public var firebaseStoreUseCaseErrorObservable = PublishSubject<String>()
    
    func uploadFirebaseUID(uid: String) {
        fireStoreManagerRepository.uploadFirebaseUserUID(uid: uid,
                                                         ProfileExistence: false)
    }
    
    func uploadProfile(profile: ProfileDomainModel, completion: @escaping (Bool) -> Void) {
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: profile.uid,
                                                            ProfileExistence: true,
                                                            completion: { [weak self] saveResult in
            if saveResult {
                self?.fireStoreManagerRepository.saveProfileDocument(profile: profile, completion: completion)
            } else {
                completion(false)
            }
        })
    }
    
    func getProfileExistence(uid: String) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            self?.fireStoreManagerRepository.checkProfileField(with: "profileExistence", uid: uid) { profileExist in
                if profileExist {
                    emitter.onNext(true)
                } else {
                    emitter.onNext(false)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getProfileData() -> Observable<(ProfileDomainModel, Bool)> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getProfileDataInFireStore()
                .subscribe(onNext: { profileData, bool in
                    var domainProfileData = ProfileDomainModel.empty
                    if bool {
                        for (key, value) in profileData {
                            switch key {
                            case "name": domainProfileData.name = value as? String ?? ""
                            case "sugarLevel": domainProfileData.sugarLevel = value as? Int ?? 0
                            case "uid": domainProfileData.uid = value as? String ?? ""
                            case "weight": domainProfileData.weight = value as? Int ?? 0
                            case "height": domainProfileData.height = value as? Int ?? 0
                            default: break
                            }
                        }
                        emitter.onNext((domainProfileData, true))
                    } else {
                        emitter.onNext((ProfileDomainModel.empty, false))
                    }
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    func getEatenFoods(dateComponents: DateComponents) -> Observable<([FoodDomainModel], Bool)> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getEatenFoodsInFirestore(dateComponents: dateComponents)
                .subscribe(onNext: { foodData, bool in
                    var addedFoodDomainModel = [FoodDomainModel]()
                    if bool {
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
                        emitter.onNext((addedFoodDomainModel, true))
                    } else {
                        emitter.onNext(([],false))
                    }
                    
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
        
    }
    
    func uploadEatenFood(eatenFood: FoodDomainModel, completion: @escaping (Bool) -> Void) {
        fireStoreManagerRepository.saveEatenFood(eatenFood: eatenFood, completion: completion)
    }
    
    func changeDemoValue(completion: @escaping ((Bool)->Void)) {
        fireStoreManagerRepository.changeDemoValue(completion: completion)
    }
}
