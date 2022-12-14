# π M-Market
> π νλ‘μ νΈ κΈ°κ° 2022.09.21 - 2022.11.20

- [μκ°](#-μκ°)
- [νμ](#-νμ)
- [μ€ννλ©΄](#-μ€ννλ©΄)
- [λΌμ΄λΈλ¬λ¦¬](#-λΌμ΄λΈλ¬λ¦¬)
- [Architecture](#-architecture)
- [μ± κ΅¬μ‘°](#-μ±-κ΅¬μ‘°)
- [νΈλ¬λΈ μν](#-νΈλ¬λΈ-μν)

## π μκ°
![](https://i.imgur.com/Dm5eKm3.png)

## π νμ
|[mmim](https://github.com/JoSH0318)|
|:---:|
|<img src="https://i.imgur.com/gTVUCZs.jpg" height="240">|

## π μ€ννλ©΄
|Mainνλ©΄-μ€ν¬λ‘€|Mainνλ©΄-κ°±μ |μμΈνλ©΄|
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/lj2n0iF.gif" width="300">|<img src="https://i.imgur.com/VfvcNuc.gif" width="300">|<img src="https://i.imgur.com/amNNRog.gif" width="300">|

|μν μμ |μν μ­μ |μν λ±λ‘|
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/BJvubZp.gif" width="300">|<img src="https://i.imgur.com/ls5mfw8.gif" width="300">|<img src="https://i.imgur.com/FMyyHgr.gif" width="300">|

## π λΌμ΄λΈλ¬λ¦¬
- RxSwift
- RxCocoa
- SnapKit

## π Architecture
### clean architecture + MVVM
- MVVMμ μ¬μ©νλ©΄, νλ‘μ νΈκ° μ»€μ§μλ‘ viewModelμ΄ κ±°λν΄μ§λ λ¨μ μ΄ μκΈ΄λ€. λ°λΌμ layerλ₯Ό λλ € viewModelμ μ­ν μ λμ΄λ΄κ³  viewModelμ μ­ν μ μ’λ λͺννκ² νκ³  μΆμλ€. clean achetectureλ₯Ό μ¬μ©νλ©΄ κ° layerλ§λ€ μ­ν μ΄ λͺνν λλμ μλ€. λλ¬Έμ κΈ°λ₯μ μΆκ°, μμ , λλ κ°μ ν  λ λ¬Έμ κ° λλ layerλ§ μ κ·ΌνκΈ° λλ¬Έμ μ½λ νμμ΄ μ½κ³ , νμ₯μ±μ΄ μ’λ€κ³  νλ¨νλ€. λν μ­ν μ΄ λͺννκΈ° λλ¬Έμ μ λνμ€νΈμλ μ©μ΄νλ€κ³  νλ¨νλ€.
<img src="https://i.imgur.com/CQg1cbQ.png" width="700">

## π μ± κ΅¬μ‘°
```
βββ MMarket
β   βββ Application
β   βββ Util
β   βββ Data
β   β   βββ DTO
β   β   βββ Network
β   β   β   βββ ImageNetwork
β   β   βββ Repository
β   β
β   βββ Domain
β   β   βββ Interface
β   β   βββ Entities
β   β   βββ UseCase
β   β       βββ Protocol
β   βββ Presentation
β       βββ Common
β       β   
β       βββ Main
β       β   βββ Coordinator
β       β   βββ View
β       β   β   βββ Cell
β       β   βββ ViewModel
β       βββ MyPage
β       β   βββ Coordinator
β       β   βββ View
β       β   βββ ViewModel
β       βββ Detail
β       β   βββ Coordinator
β       β   βββ View
β       β   β   βββ Cell
β       β   βββ ViewModel
β       βββ Register
β           βββ Coordinator
β           βββ View
β           β   βββ Cell
β           βββ ViewModel
β   
βββ MMarketTest
    βββ Network
    β   βββ Support
    β   βββ DoubleTests(stub/mock)
    βββ Repository   
```

## π νΈλ¬λΈ μν
### βοΈ νμ₯μ±μ΄ μ©μ΄ν data layer κ΅¬ννκΈ°
> π€ networkμ `HTTP method or κΈ°λ₯` λ³λ‘ ν΅μ μ νκ³  κ·Έκ²λ§λ€ requestκ° λ€λ₯΄λ€.
λλ¬Έμ URLSession dataTask() methodμ κ° κΈ°λ₯μ ν΄λΉνλ μ μ ν requestλ₯Ό μ λ¬νλ λ°©λ²μΌλ‘ κ΅¬νν΄μΌνλ€κ³  νλ¨νλ€.

> π‘ Endpoint κ°μ²΄λ₯Ό λ§λ€μ΄ ν΄λΉ ν΅μ μ endpointμ μ ν©ν urlκ³Ό requestλ₯Ό λ§λ€μ΄μ£Όλλ‘ κ΅¬ννλ€.
```swift
final class Endpoint {
    private let baseURL: String
    private let path: String
    private let method: HTTPMethod
    private let header: [String: String]
    private let queries: [String: Any]
    private let body: Data?
    
    init(
        baseURL: String,
        path: String,
        method: HTTPMethod,
        header: [String : String] = [:],
        queries: [String : Any] = [:],
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.header = header
        self.queries = queries
        self.body = body
    }
    
    func generateRequest() throws -> URLRequest {
        ...
        return urlRequest
    }
    
    private func generateURL() throws -> URL {
        ...
        return url
    }
}

final class DefaultNetworkProvider: NetworkProvider {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func execute(endpoint: Endpoint) -> Observable<Data> {
        return Single<Data>.create { [weak self] single in
            guard let urlRequest = try? endpoint.generateRequest() else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            self?.urlSession.dataTask(with: urlRequest) { 
                //
            }
        }
    }
}
```

### βοΈ scrollλ‘ μΈνμ¬ μ΄μ  cellμ μ΄λ―Έμ§ λ€μ΄λ‘λκ° λΆνμν΄μ§ κ²½μ°, taskλ₯Ό cancelνλ λ°©λ²
> π€ scrollμ ν  κ²½μ° μ΄λ―Έ λμ΄κ° cellμ λν μ΄λ―Έμ§ λ€μ΄λ‘λλ νμμλ€. λ°λΌμ λ³λ€λ₯Έ μ‘°μΉκ° μλ€λ©΄ λΆνμν λ¦¬μμ€κ° λ­λΉλλ€. 

>1οΈβ£  μ±κΈν΄ ν¨ν΄μΌλ‘ κ΅¬νλ ImageDownloaderκ° taskλ₯Ό μμ νκ³ , cancelTask ν΄μ£Όλ λ°©λ²
<img src="https://i.imgur.com/7iTG59x.jpg" width="700">

>β μ±κΈν΄μΌλ‘ κ΅¬νλ ImageDownloaderκ° taskλ₯Ό λ¨ νλ μμ νκ³  μκΈ° λλ¬Έμ μ΄λ―Έμ§ λ€μ΄λ‘λκ° λΆνμν΄μ§ taskλ₯Ό cancelνλ€λ©΄ νμ¬ λ€μ΄λ‘λ μ€μΈ taskλ§μ  cancel λλ€. λν λ€μμ imageκ° λΉλκΈ°λ‘ λ€μ΄λ‘λλλ©΄ task κ΄λ¦¬κ° μ΄λ ΅λ€.

>2οΈβ£ UIImageλ₯Ό subscribeν Downlownable κ°μ²΄ κ΅¬ννμ¬ image downloadeμ imageλ₯Ό ν΄λΉ imageViewμ μ μ©νλ setImage λ©μλλ₯Ό κ΅¬ν β‘οΈ cellμ΄ imageDataTaskλ₯Ό μμ νκ³   prepareForReuseμμ imageDataTaskλ₯Ό cancelνλ λ°©λ²  
>* ImageDownloader
<img src="https://i.imgur.com/jmwtoGL.jpg" width="700">
>* cell
<img src="https://i.imgur.com/IIqSW20.jpg" width="700">

>β MVVM κ΅¬μ‘°μμ viewμ μμ­μΈ cellμ΄ taskλ₯Ό μμ νλ κ²μ΄ μ³μ§ μλ€. λν, ImageDownloadeμ taskκ° cellμ imageDataTaskμ ν λΉλκΈ° μ§μ μ λ°λλ€λ©΄ μμΉ μλ taskκ° imageDataTaskμ ν λΉλ  μλ μλ€. 

>3οΈβ£ ImageDownloaderκ° [Token: URLSessionDataTask] ννμ taskQueueλ‘ taskλ₯Ό κ΄λ¦¬νλ λ°©λ² 
>* ImageDownloader
> νλ‘νΌν°λ‘ taskQueueμ currentTokenμ κ°μ§κ³  μκ³ , `nextToken()`, `insertTask()` λ©μλλ‘ tokenκ³Ό taskλ₯Ό κ΄λ¦¬νλλ‘ νλ€. `cancelTask`λ ν΄λΉ tokenμ keyλ‘ Queueμ μ κ·Όνμ¬ cancelνκ³  taskQueueμμ μ§μ°λλ‘ νλ€.
> `nextToken()`, `insertTask()`μ NSLockμ ν΅ν΄ νλ²μ μ¬λ¬ threadκ° μ κ·Όνμ§ λͺ»νλλ‘ νμ¬, λμμ tokenκ³Ό taskQueueμ μ κ·Όνλ κ²μ λ°©μ§νλ€.
<img src="https://i.imgur.com/qBVxFFQ.jpg" width="700">
<img src="https://i.imgur.com/Z9KBr7N.jpg" width="700">
<img src="https://i.imgur.com/6Q25ey8.jpg" width="700">
>* CellViewModel
> CellViewModelμ΄ tokenμ κ°μ§κ³  μκ³ , `nextToken()`μ ν΅ν΄ κ°±μ λ tokenμ μ΄μ©νμ¬ imageDownloaderμκ² image λ€μ΄λ‘λλ₯Ό μμ²­νκ³  taskλ₯Ό μ μ₯νλ€. Modelμ input λ©μλ`onPrepareForReuse()`λ₯Ό ν΅ν΄ ν΄λΉ token keyκ°μ κ°μ§ value taskλ₯Ό cancelνλλ‘ νλ€. μ΄ λ©μλλ cellμ prepareForReuseμμ νΈμΆλλ€.
<img src="https://i.imgur.com/vx0z4Be.jpg" width="700">
<img src="https://i.imgur.com/8Nj2AWZ.jpg" width="700">

### βοΈ νλ©΄μ ν μ½λλ€λ‘ μΈν΄ ViewControllerκ° λ¬΄κ±°μμ§λ λ¬Έμ λ₯Ό ν΄κ²°ν  μ μμκΉ?
> π€ νλ©΄μ νμ΄ νμν  λλ§λ€ λ°λ³΅λλ μ½λκ° λ§λ€. κΈ°λ₯ μΆκ° λλ μ νλλ νλ©΄μ΄ λ§μμ§μ λ°λΌ viewControllerμ μ½λλμ΄ μ¦κ°λλ€. λν, κ° ViewControllerκ°μ μμ‘΄μ±μ΄ μκΈ΄λ€.
>π‘ coordinator ν¨ν΄μ μ΄μ©νμ¬ ν΄λΉ μ½λλ₯Ό viewModelλ‘ viewControllerκ°μ μμ‘΄μ±μ μ κ±°νμλ€. 

<img src="https://i.imgur.com/NCmXnH8.png" width="700">

### βοΈ μνλ λͺ¨μμ custom buttonμ μ½κ² μ¬μ©ν  μ μμκΉ?
> ![](https://i.imgur.com/vnJm8qe.jpg)
> μ΄λ° ννμ buttonμ μ¬μ©νκ³  μΆμλ€.

> π€ UIKitμμ μ κ³΅νλ buttonμ image, labelμ νΌν©ν ννλ‘ λ§λ€κΈ° μ΄λ ΅κ³  λ³΅μ‘νλ€. λν μμ λλ λ¨μ΄μ§κΈ° λλ¬Έμ μνλ λͺ¨μμ buttonμ λ§λ€κΈ° μ΄λ ΅λ€. λ°λΌμ UIButtonμ μμν custom λ²νΌμ λ§λλ κ²μΌλ‘ λ¬Έμ λ₯Ό ν΄κ²°νκ³ μ νλ€.

> custom buttonμ view κ΅¬μ±μ λ€μκ³Ό κ°μ΄ κ΅¬ννλ€.
<img src="https://i.imgur.com/c8vcnIO.png" width="300">

> π€ buttonμ΄ ν΄λ¦­λμ§ μκ³  λ°μμ΄ μλ λ¬Έμ κ° μκ²Όλ€. UIStackViewμ hitTestκ° ν΅κ³Όνμ§ λͺ»νμ¬ responder chainingμ ν΅ν΄ UIButtonμ μ λ¬λμ§ λͺ»νκ³  μλ€λ μ μ λ°κ²¬νλ€.
> UIStackViewλ₯Ό μμνλ EnableStackViewλ₯Ό λ§λ€μ΄ hitTestλ₯Ό ν΅κ³Όνλλ‘ κ΅¬ννλ κ²μΌλ‘ λ¬Έμ λ₯Ό ν΄κ²°νλ€.
> <img src="https://i.imgur.com/Ry6YYTf.jpg" width="500">

> κΈ°μ‘΄μ μ¬μ©νλ UIStackView λμ  `EnableStackView`λ₯Ό μ¬μ©νλ―λ‘μ¨ responder chainμ΄ buttonκΉμ§ μ΄μ΄μ§λλ‘ ν΄κ²°νλ€.

