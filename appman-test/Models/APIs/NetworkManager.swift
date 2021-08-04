private class DefaultAlamofireManager: Alamofire.Session {
    static let APIManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .useProtocolCachePolicy
        let delegate = Session.default.delegate
        let manager = Session.init(configuration: configuration,
                                     delegate: delegate,
                                     startRequestsImmediately: true,
                                     cachedResponseHandler: nil)
        return manager
    }()
}

class NetworkManager: Networkable {
    
    // MARK: - Typealias or Enum
    enum Environment {
        case local
        case server
        
        func stubClosure(for target: TargetType) -> Moya.StubBehavior {
            return (self == .server ? .never : .immediate)
        }
    }

    // MARK: - Properties
    // MARK: Private
    private var environment: Environment
    private lazy var plugins: [PluginType] = {
        return [
            NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)),
            NetworkActivityPlugin(networkActivityClosure: { (changeType, targetType) in
                print(changeType)
                print(targetType)
            })
        ]
    }()
    
    // MARK: - Methods
    // MARK: Constructor
    
    /// Initialization with setting up environment parameter.
    /// - Parameters:
    ///     - environment: A type of environment it has 2 types.
    ///         1.) server: when you want to call APIs from the server, you have to set it.
    ///         2.) local: if you want to use mock datas from response for testing, you have to set it.
    ///
    init(environment: Environment = .server) {
        self.environment = environment
    }
    
    // MARK: Public or Internal
    func request<Target: TargetType>(target: Target) throws -> Promise<Moya.Response> {
        return async {
            let (moyaResponse, moyaError) = try `await`(self.call(target: target))
        
            if let response = moyaResponse {
                return response
            } else if let moyaError = moyaError {
                throw moyaError
            } else {
                throw NSError()
            }
        }
    }
}

// MARK: - Helpers
private extension NetworkManager {
    func call<Target: TargetType>(target: Target) -> Promise<(Moya.Response?, MoyaError?)> {
        return Promise { [weak self] promise in
            guard let weakSelf = self else { return }
            let provider = MoyaProvider<Target>(stubClosure: weakSelf.environment.stubClosure,
                                                session: DefaultAlamofireManager.APIManager,
                                                plugins: plugins)
            
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    promise.fulfill((response, nil))
                case let .failure(moyaError):
                    promise.fulfill((nil, moyaError))
                }
            }
        }
    }
    
    func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
}
