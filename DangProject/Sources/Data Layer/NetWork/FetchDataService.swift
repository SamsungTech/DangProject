//
//  FetchFoodFromAPI.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

enum URLState {
    case baseURL
    case searchFoodURL
}

enum FoodApiError: String, Error {
    case serverConnectionError = "FoodAPI - serverError"
    case temporaryServerInspection = "FoodAPI - temporaryServerInspection"
}

class FetchDataService {
    // MARK: - Internal
    var foodInfoObservable = PublishSubject<FoodEntity>()
    
    func fetchFoodEntity(text: String,
                         completion: @escaping(Bool)->Void) {
        fetchFoodRx(text: text)
            .timeout(RxTimeInterval.seconds(15),
                     scheduler: MainScheduler.asyncInstance)
            .do(onError: { error in
                completion(false)
            })
            .map { data in
                try JSONDecoder().decode(FoodFromAPI.self, from: data)
            }
            .subscribe(onNext: { [weak self] in
                guard let result = $0.serviceType?.result else { return }
                self?.foodInfoObservable.onNext(FoodEntity.init(code: result.code,
                                                                foodEntity: $0.serviceType?.foodInfo ?? [],
                                                                keyword: text))
                completion(true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private func fetchFood(state: URLState,
                           text: String?,
                           onComplete: @escaping (Result<Data, Error>) -> Void) {
        guard let text = text else {
            return
        }

        var urlString: String
        
        switch state {
        case .baseURL:
            urlString = "http://openapi.foodsafetykorea.go.kr/api/402a53aa1ef448f3bc9b/I2790/json/1/100/"
        case .searchFoodURL:
            urlString =  "http://openapi.foodsafetykorea.go.kr/api/402a53aa1ef448f3bc9b/I2790/json/1/100/DESC_KOR=\(text)"
        }
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let stringToURL = URL(string: encodedString) else {
            return
        }
        
        URLSession.shared.dataTask(with: stringToURL) { data, response, error in
            if let error = error {
                onComplete(.failure(error))
                return
            }
            guard let data = data else {
                let httpResponse = response as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }
            onComplete(.success(data))
        }.resume()
    }
    
    private func fetchFoodRx(text: String) -> Observable<Data> {
        return Observable.create() { emitter in
            self.fetchFood(state: .searchFoodURL,
                           text: text) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    print(FoodApiError.serverConnectionError)
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
