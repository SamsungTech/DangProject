//
//  FirebaseFireStoreManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

class DefaultFirebaseFireStoreUseCase: FirebaseFireStoreUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let fireStoreManagerRepository: FireStoreManagerRepository
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
    
    // MARK: - Internal
    let profileExistenceObservable = PublishSubject<Bool>()
    
    func uploadFirebaseUID(uid: String) {
        fireStoreManagerRepository.saveFirebaseUIDDocument(uid: uid)
    }
    
    func uploadProfile(profile: ProfileDomainModel) {
        fireStoreManagerRepository.saveProfileDocument(profile: profile)
    }
    
    func getProfileExistence(uid: String) {
        fireStoreManagerRepository.checkProfileField(with: "profileExistence", uid: uid) { [weak self] profileExist in
            if profileExist {
                self?.profileExistenceObservable.onNext(true)
            } else {
                self?.profileExistenceObservable.onNext(false)
            }
        }
    }
    
    func getEatenFoods(uid: String, date: DateComponents) -> Observable<[FoodDomainModel]> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireStoreManagerRepository.getEatenFoodsInFirestore(uid: uid, date: date)
                .subscribe(onNext: { foodData in
                    var addedFoodDomainModel = [FoodDomainModel]()
                    foodData.forEach { foods in
                        var foodModel = FoodDomainModel.empty
                        for (key, value) in foods {
                            switch key {
                            case "name": foodModel.name = value as? String ?? ""
                            case "sugar": foodModel.sugar = value as? String ?? ""
                            case "foodCode": foodModel.foodCode = value as? String ?? ""
                            case "amount": foodModel.amount = value as? Int ?? 0
                            case "favorite": foodModel.favorite = value as? Bool ?? false
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
    
    func uploadEatenFood(eatenFood: FoodDomainModel, currentDate: DateComponents) {
        fireStoreManagerRepository.saveEatenFood(eatenFood: eatenFood, currentDate: currentDate)
    }
}
