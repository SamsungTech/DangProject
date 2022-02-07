//
//  APIService.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

class FetchFoodRepository: FetchRepository {
    var dataStructure: FoodFromAPI?
    
    func fetchFood(text: String, onComplete: @escaping (Result<Data, Error>) -> Void) {
        let baseURL = "http://openapi.foodsafetykorea.go.kr/api/402a53aa1ef448f3bc9b/I2790/json/1/100/DESC_KOR=\(text)"
        let encodedStr = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        URLSession.shared.dataTask(with: URL(string: encodedStr)!) { data, response, error in
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
    
    func fetchFoodRx(text: String) -> Observable<Data> {
        return Observable.create() { emitter in
            self.fetchFood(text: text){ result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
