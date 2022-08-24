import UIKit

import FirebaseFirestore

struct FoodDomainModel: Equatable {
    static let empty: Self = .init(name: "",
                                   sugar: 0,
                                   foodCode: "",
                                   eatenTime: Timestamp.init())
    var name: String
    var sugar: Double
    var foodCode: String
    var favorite: Bool = false
    var amount: Int = 1
    var eatenTime: Timestamp
    var targetSugar: Double = 0.0
    
    init(name: String,
         sugar: Double,
         foodCode: String,
         eatenTime: Timestamp) {
        self.name = name
        self.sugar = sugar.roundDecimal(to: 2)
        self.foodCode = foodCode
        self.eatenTime = eatenTime
    }
    
    init(_ foodInfoFromAPI: FoodInfo) {
        self.name = foodInfoFromAPI.nameContent ?? ""
        self.sugar = Double(foodInfoFromAPI.sugarContent ?? "0") ?? 0
        self.foodCode = foodInfoFromAPI.foodCode ?? ""
        self.eatenTime = Timestamp.init()
    }
    
    init(_ foodViewModel: FoodViewModel) {
        self.name = foodViewModel.name ?? ""
        self.sugar = Double(foodViewModel.sugar ?? "0") ?? 0
        self.foodCode = foodViewModel.code ?? ""
        if foodViewModel.image == UIImage(systemName: "star.fill") {
            self.favorite = true
        }
        self.eatenTime = Timestamp.init()
        self.targetSugar = foodViewModel.targetSugar ?? 0.0
    }
    
    init(_ addFoodsViewModel: AddFoodsViewModel) {
        self.name = addFoodsViewModel.foodModel?.name ?? ""
        self.sugar = Double(addFoodsViewModel.foodModel?.sugar ?? "0") ?? 0
        self.foodCode = addFoodsViewModel.foodModel?.code ?? ""
        self.amount = addFoodsViewModel.amount
        self.eatenTime = Timestamp.init()
        self.targetSugar = addFoodsViewModel.foodModel?.targetSugar ?? 0.0
    }
    
    init(_ coreDataFood: FavoriteFoods) {
        self.name = coreDataFood.name ?? ""
        self.sugar = Double(coreDataFood.sugar ?? "0") ?? 0
        self.foodCode = coreDataFood.foodCode ?? ""
        self.favorite = true
        self.eatenTime = Timestamp.init()
    }
    
    init(_ eatenFoods: EatenFoods) {
        self.name = eatenFoods.name ?? ""
        self.sugar = eatenFoods.sugar
        self.foodCode = eatenFoods.foodCode ?? ""
        self.amount = Int(eatenFoods.amount)
        self.eatenTime = Timestamp.init()
        self.targetSugar = eatenFoods.targetSugar
    }
}

struct EatenFoodsPerDayDomainModel {
    static let empty: Self = .init(date: Date.init(), eatenFoods: [])
    let date: Date?
    let eatenFoods: [FoodDomainModel]
    
    init(date: Date, eatenFoods: [FoodDomainModel]) {
        self.date = date
        self.eatenFoods = eatenFoods
    }
    
    init(_ eatenFoodsPerDayEntity: EatenFoodsPerDay) {
        self.date = eatenFoodsPerDayEntity.date
        self.eatenFoods = eatenFoodsPerDayEntity.eatenFoodsArray.map { FoodDomainModel.init($0) }
    }
}

struct SearchResultDomainModel {
    let code: String
    let keyword: String
    let foodDomainModel: [FoodDomainModel]
    
    init(_ foodEntity: FoodEntity) {
        self.code = foodEntity.code
        self.keyword = foodEntity.keyword
        self.foodDomainModel = foodEntity.foodInfo.map { FoodDomainModel.init($0) }
    }
}
