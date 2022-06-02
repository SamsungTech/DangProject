import RxSwift

protocol FetchRepository {
    
    var foodDomainModelObservable: PublishSubject<SearchResultDomainModel> { get }

    func fetchToDomainModel(text: String)
    
}
