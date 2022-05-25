//
//  FetchFoodFromAPI.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift



// MARK: 재인 - swift concurrency 꼭 찾아보기
// MARK: TASK 이런거
class FetchDataService {
    
    var foodInfoObservable = PublishSubject<FoodEntity>()
        
    let disposeBag = DisposeBag()
    
    
    // MARK: 재인 - 이거 공통점들 다 모아서
    // MARK: FetchFoodAPI(text: blahblah) { [weak self] in
//                asd
//           }
    // MARK: 알라모파이어 어드밴스드 유세이지 이런거 많음 NetworkManager
    private func fetchFood(text: String, onComplete: @escaping (Result<Data, Error>) -> Void) {
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
    
    func fetchFoodEntity(text: String) {
        fetchFoodRx(text: text)
            .map { data in
                try JSONDecoder().decode(FoodFromAPI.self, from: data)
            }
            .subscribe(onNext: { [self] in
                guard let result = $0.serviceType?.result else { return }
                foodInfoObservable.onNext(FoodEntity.init(code: result.code,
                                                          foodEntity: $0.serviceType?.foodInfo ?? [],
                                                          keyword: text))
            })
            .disposed(by: disposeBag)
    }
}
