import RxSwift

protocol FetchRepository {
    
    var foodDomainModelObservable: PublishSubject<[FoodDomainModel]> { get }
    
    func fetchToDomainModel(text: String)
    
}
