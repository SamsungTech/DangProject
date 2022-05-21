import UIKit

struct FoodDomainModel: Equatable {
    static let empty: Self = .init(name: "", sugar: "", foodCode: "")
    var name: String
    var sugar: String
    var foodCode: String
    var favorite: Bool = false
    var amount: Int = 1
    
    init(name: String,
         sugar: String,
         foodCode: String) {
        self.name = name
        self.sugar = sugar
        self.foodCode = foodCode
    }
        
    init(_ foodInfoFromAPI: FoodInfo) {
        self.name = foodInfoFromAPI.nameContent ?? ""
        self.sugar = foodInfoFromAPI.sugarContent ?? ""
        self.foodCode = foodInfoFromAPI.foodCode ?? ""
    }
    
    init(_ foodViewModel: FoodViewModel) {
        self.name = foodViewModel.name ?? ""
        self.sugar = foodViewModel.sugar ?? ""
        self.foodCode = foodViewModel.code ?? ""
        if foodViewModel.image == UIImage(systemName: "star.fill") {
            self.favorite = true
        }
    }
    
    init(_ addFoodsViewModel: AddFoodsViewModel) {
        self.name = addFoodsViewModel.foodModel?.name ?? ""
        self.sugar = addFoodsViewModel.foodModel?.sugar ?? "0"
        self.foodCode = addFoodsViewModel.foodModel?.code ?? ""
        self.amount = addFoodsViewModel.amount
    }
    
    init(_ coreDataFood: FavoriteFoods) {
        self.name = coreDataFood.name ?? ""
        self.sugar = coreDataFood.sugar ?? "0"
        self.foodCode = coreDataFood.foodCode ?? ""
        self.favorite = true
    }
}

struct SearchResultDomainModel {
    var keyword: String
    let foodDomainModel: [FoodDomainModel]
    
    init(_ foodEntity: FoodEntity) {
        self.keyword = foodEntity.keyword
        self.foodDomainModel = foodEntity.foodInfo.map { FoodDomainModel.init($0) }
    }
}
