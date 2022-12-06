# 🛍 M-Market
> 🗓 프로젝트 기간 2022.09.21 - 2022.11.20

- [소개](#-소개)
- [팀원](#-팀원)
- [실행화면](#-실행화면)
- [라이브러리](#-라이브러리)
- [Architecture](#-architecture)
- [앱 구조](#-앱-구조)
- [트러블 슈팅](#-트러블-슈팅)

## 📌 소개
![](https://i.imgur.com/Dm5eKm3.png)

## 📌 팀원
|[mmim](https://github.com/JoSH0318)|
|:---:|
|<img src="https://i.imgur.com/gTVUCZs.jpg" height="240">|

## 📌 실행화면
|Main화면-스크롤|Main화면-갱신|상세화면|
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/lj2n0iF.gif" width="300">|<img src="https://i.imgur.com/VfvcNuc.gif" width="300">|<img src="https://i.imgur.com/amNNRog.gif" width="300">|

|상품 수정|상품 삭제|상품 등록|
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/BJvubZp.gif" width="300">|<img src="https://i.imgur.com/ls5mfw8.gif" width="300">|<img src="https://i.imgur.com/FMyyHgr.gif" width="300">|

## 📌 라이브러리
- RxSwift
- RxCocoa
- SnapKit

## 📌 Architecture
### clean architecture + MVVM
- MVVM을 사용하면, 프로젝트가 커질수록 viewModel이 거대해지는 단점이 생긴다. 따라서 layer를 늘려 viewModel의 역할을 덜어내고 viewModel의 역할을 좀더 명확하게 하고 싶었다. clean achetecture를 사용하면 각 layer마다 역할이 명확히 나눌수 있다. 때문에 기능을 추가, 수정, 또는 개선할 때 문제가 되는 layer만 접근하기 때문에 코드 파악이 쉽고, 확장성이 좋다고 판단했다. 또한 역할이 명확하기 때문에 유닛테스트에도 용이하다고 판단했다.
<img src="https://i.imgur.com/CQg1cbQ.png" width="700">

## 📌 앱 구조
```
├── MMarket
│   ├── Application
│   ├── Util
│   ├── Data
│   │   ├── DTO
│   │   ├── Network
│   │   │   ├── ImageNetwork
│   │   └── Repository
│   │
│   ├── Domain
│   │   ├── Interface
│   │   ├── Entities
│   │   └── UseCase
│   │       └── Protocol
│   └── Presentation
│       ├── Common
│       │   
│       ├── Main
│       │   ├── Coordinator
│       │   ├── View
│       │   │   └── Cell
│       │   └── ViewModel
│       ├── MyPage
│       │   ├── Coordinator
│       │   ├── View
│       │   └── ViewModel
│       ├── Detail
│       │   ├── Coordinator
│       │   ├── View
│       │   │   └── Cell
│       │   └── ViewModel
│       └── Register
│           ├── Coordinator
│           ├── View
│           │   └── Cell
│           └── ViewModel
│   
└── MMarketTest
    ├── Network
    │   ├── Support
    │   └── DoubleTests(stub/mock)
    └── Repository   
```

## 📌 트러블 슈팅
### ⁉️ 확장성이 용이한 data layer 구현하기
> 🤔 network의 `HTTP method or 기능` 별로 통신을 하고 그것마다 request가 다르다.
때문에 URLSession dataTask() method에 각 기능에 해당하는 적절한 request를 전달하는 방법으로 구현해야한다고 판단했다.

> 💡 Endpoint 객체를 만들어 해당 통신의 endpoint에 적합한 url과 request를 만들어주도록 구현했다.
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

### ⁉️ scroll로 인하여 이전 cell의 이미지 다운로드가 불필요해진 경우, task를 cancel하는 방법
> 🤔 scroll을 할 경우 이미 넘어간 cell에 대한 이미지 다운로드는 필요없다. 따라서 별다른 조치가 없다면 불필요한 리소스가 낭비된다. 

>1️⃣  싱글턴 패턴으로 구현된 ImageDownloader가 task를 소유하고, cancelTask 해주는 방법
<img src="https://i.imgur.com/7iTG59x.jpg" width="700">

>❌ 싱글턴으로 구현된 ImageDownloader가 task를 단 하나 소유하고 있기 때문에 이미지 다운로드가 불필요해진 task를 cancel한다면 현재 다운로드 중인 task마저 cancel 된다. 또한 다수의 image가 비동기로 다운로드되면 task 관리가 어렵다.

>2️⃣ UIImage를 subscribe한 Downlownable 객체 구현하여 image downloade와 image를 해당 imageView에 적용하는 setImage 메서드를 구현 ➡️ cell이 imageDataTask를 소유하고  prepareForReuse에서 imageDataTask를 cancel하는 방법  
>* ImageDownloader
<img src="https://i.imgur.com/jmwtoGL.jpg" width="700">
>* cell
<img src="https://i.imgur.com/IIqSW20.jpg" width="700">

>❌ MVVM 구조에서 view의 영역인 cell이 task를 소유하는 것이 옳지 않다. 또한, ImageDownloade의 task가 cell의 imageDataTask에 할당되기 직전에 바뀐다면 원치 않는 task가 imageDataTask에 할당될 수도 있다. 

>3️⃣ ImageDownloader가 [Token: URLSessionDataTask] 형태의 taskQueue로 task를 관리하는 방법 
>* ImageDownloader
> 프로퍼티로 taskQueue와 currentToken을 가지고 있고, `nextToken()`, `insertTask()` 메서드로 token과 task를 관리하도록 했다. `cancelTask`는 해당 token을 key로 Queue에 접근하여 cancel하고 taskQueue에서 지우도록 했다.
> `nextToken()`, `insertTask()`은 NSLock을 통해 한번에 여러 thread가 접근하지 못하도록 하여, 동시에 token과 taskQueue에 접근하는 것을 방지했다.
<img src="https://i.imgur.com/qBVxFFQ.jpg" width="700">
<img src="https://i.imgur.com/Z9KBr7N.jpg" width="700">
<img src="https://i.imgur.com/6Q25ey8.jpg" width="700">
>* CellViewModel
> CellViewModel이 token을 가지고 있고, `nextToken()`을 통해 갱신된 token을 이용하여 imageDownloader에게 image 다운로드를 요청하고 task를 저장한다. Model의 input 메서드`onPrepareForReuse()`를 통해 해당 token key값을 가진 value task를 cancel하도록 했다. 이 메서드는 cell의 prepareForReuse에서 호출된다.
<img src="https://i.imgur.com/vx0z4Be.jpg" width="700">
<img src="https://i.imgur.com/8Nj2AWZ.jpg" width="700">

### ⁉️ 화면전환 코드들로 인해 ViewController가 무거워지는 문제를 해결할 수 없을까?
> 🤔 화면전환이 필요할 때마다 반복되는 코드가 많다. 기능 추가 또는 전환되는 화면이 많아짐에 따라 viewController에 코드량이 증가된다. 또한, 각 ViewController간의 의존성이 생긴다.
>💡 coordinator 패턴을 이용하여 해당 코드를 viewModel로 viewController간의 의존성을 제거하였다. 

<img src="https://i.imgur.com/NCmXnH8.png" width="700">

### ⁉️ 원하는 모양의 custom button을 쉽게 사용할 수 없을까?
> ![](https://i.imgur.com/vnJm8qe.jpg)
> 이런 형태의 button을 사용하고 싶었다.

> 🤔 UIKit에서 제공하는 button은 image, label을 혼합한 형태로 만들기 어렵고 복잡하다. 또한 자유도도 떨어지기 때문에 원하는 모양의 button을 만들기 어렵다. 따라서 UIButton을 상속한 custom 버튼을 만드는 것으로 문제를 해결하고자 했다.

> custom button의 view 구성은 다음과 같이 구현했다.
<img src="https://i.imgur.com/c8vcnIO.png" width="300">

> 🤔 button이 클릭되지 않고 반응이 없는 문제가 생겼다. UIStackView의 hitTest가 통과하지 못하여 responder chaining을 통해 UIButton에 전달되지 못하고 있다는 점을 발견했다.
> UIStackView를 상속하는 EnableStackView를 만들어 hitTest를 통과하도록 구현하는 것으로 문제를 해결했다.
> <img src="https://i.imgur.com/Ry6YYTf.jpg" width="500">

> 기존에 사용하는 UIStackView 대신 `EnableStackView`를 사용하므로써 responder chain이 button까지 이어지도록 해결했다.

