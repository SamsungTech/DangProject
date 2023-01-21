import RxSwift

protocol FetchRepository {
    var foodDomainModelObservable: PublishSubject<SearchResultDomainModel> { get }
    var foodDomainModelErrorObservable: PublishSubject<String> { get }

    func fetchToDomainModel(text: String)
    
}
