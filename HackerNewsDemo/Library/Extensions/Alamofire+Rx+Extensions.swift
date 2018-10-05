//
//  Alamofire+Rx.swift
//
//  Created by Daniel García Alvarado on 28/01/2018.
//  Copyright © 2017 Ozgur. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import RxAlamofire
import RxSwift

// MARK: SessionManager
public class APIResponse<T> {
    var statusCode : Int = 200
    var response: T?
}

let INTERNAL_ERROR = 1000

public class APIError : NSError {
    var statusCode : Int = INTERNAL_ERROR
    
    public required init(statusCode: Int, userInfo: [String: Any]? = nil) {
        super.init(domain: "io.dflabs.Laundry", code: statusCode, userInfo: userInfo)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class BaseResponse : Mappable {
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
    }
}

extension ObservableType {
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<APIResponse<T>> {
        return flatMap { data -> Observable<APIResponse<T>> in
            guard let (response, object) = data as? (HTTPURLResponse, Any),
                let value = Mapper<T>().map(JSONObject: object) else {
                    throw APIError(statusCode: INTERNAL_ERROR, userInfo: [NSLocalizedDescriptionKey: "ObjectMapper can't mapping"])
            }
            let apiResponse = APIResponse<T>()
            apiResponse.statusCode = response.statusCode
            apiResponse.response = value
            return Observable.create({ (observer) -> Disposable in
                switch apiResponse.statusCode {
                case 200..<300:
                    observer.onNext(apiResponse)
                    observer.onCompleted()
                default:
                    let error = APIError(statusCode: apiResponse.statusCode)
                    observer.onError(error)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
        }
    }
    
    public func mapArray<T: Mappable>(type: T.Type) -> Observable<APIResponse<[T]>> {
        return flatMap { data -> Observable<APIResponse<[T]>> in
            guard let (response, objects) = data as? (HTTPURLResponse, Any),
                let values = Mapper<T>().mapArray(JSONObject: objects) else {
                    throw NSError(
                        domain: "com.example",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "ObjectMapper can't mapping"]
                    )
            }
            let apiResponse = APIResponse<[T]>()
            apiResponse.statusCode = response.statusCode
            apiResponse.response = values
            return Observable.create({ (observer) -> Disposable in
                switch apiResponse.statusCode {
                case 200..<300:
                    observer.onNext(apiResponse)
                    observer.onCompleted()
                default:
                    let error = APIError(statusCode: apiResponse.statusCode)
                    observer.onError(error)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
        }
    }
}

extension Reactive where Base: SessionManager {
    
    public func responseObject<T: Mappable>(_ method: Alamofire.HTTPMethod,
                                            _ url: URLConvertible,
                                            _ parameters: [String: Any]? = nil,
                                            encoding: ParameterEncoding = JSONEncoding.default,
                                            headers: [String: String]? = nil
        )
        -> Observable<(HTTPURLResponse, T)>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { request in
                return request.rx.responseObject()
        }
    }
    
    public func object<T: Mappable>(_ method: Alamofire.HTTPMethod,
                                    _ url: URLConvertible,
                                    _ parameters: [String: Any]? = nil,
                                    encoding: ParameterEncoding = JSONEncoding.default,
                                    headers: [String: String]? = nil
        )
        -> Observable<T>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            )
            .flatMap { request in
                return request.rx.object()
        }
    }
    
    public func responseObjectArray<T: Mappable>(_ method: Alamofire.HTTPMethod,
                                                 _ url: URLConvertible,
                                                 _ parameters: [String: Any]? = nil,
                                                 keyPath: String? = nil,
                                                 encoding: ParameterEncoding = JSONEncoding.default,
                                                 headers: [String: String]? = nil
        )
        -> Observable<(HTTPURLResponse, [T])>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { request in
                return request.rx.responseObjectArray(keyPath: keyPath)
        }
    }
    
    public func objectArray<T: Mappable>(_ method: Alamofire.HTTPMethod,
                                         _ url: URLConvertible,
                                         _ parameters: [String: Any]? = nil,
                                         keyPath: String? = nil,
                                         encoding: ParameterEncoding = JSONEncoding.default,
                                         headers: [String: String]? = nil
        )
        -> Observable<[T]>
    {
        return request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).flatMap { request in
                return request.rx.objectArray(keyPath: keyPath)
        }
    }
}

// MARK: DataRequest

extension Reactive where Base: DataRequest {
    
    func responseObject<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil,
                                     mapToObject object: T? = nil, context: MapContext? = nil)
        -> Observable<(HTTPURLResponse, T)>
    {
        return Observable.create { observer in
            let dataRequest = self.base.responseObject(
                queue: queue, keyPath: keyPath, mapToObject: object, context: context,
                completionHandler: { packedResponse in
                    
                    switch packedResponse.result {
                    case .success(let result):
                        if let httpResponse = packedResponse.response {
                            observer.onNext((httpResponse, result))
                        }
                        else {
                            observer.on(.error(RxAlamofireUnknownError))
                        }
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error as Error))
                    }
            })
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    func object<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil,
                             mapToObject object: T? = nil, context: MapContext? = nil)
        -> Observable<T>
    {
        return Observable.create { observer in
            let dataRequest = self.base
                .responseObject(completionHandler: {
                    (packedResponse: DataResponse<T>) in
                    switch packedResponse.result {
                    case .success(let result):
                        if let _ = packedResponse.response {
                            observer.on(.next(result))
                        }
                        else {
                            observer.on(.error(RxAlamofireUnknownError))
                        }
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error as Error))
                    }
                })
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    func responseObjectArray<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil,
                                          context: MapContext? = nil)
        -> Observable<(HTTPURLResponse, [T])>
    {
        return Observable.create { observer in
            let dataRequest = self.base.responseArray(
                queue: queue, keyPath: keyPath, context: context,
                completionHandler: {
                    (packedResponse: DataResponse<[T]>) in
                    
                    switch packedResponse.result {
                    case .success(let result):
                        if let httpResponse = packedResponse.response {
                            observer.onNext((httpResponse, result))
                        }
                        else {
                            observer.on(.error(RxAlamofireUnknownError))
                        }
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error as Error))
                    }
            })
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    func objectArray<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil,
                                  context: MapContext? = nil) -> Observable<[T]>
    {
        return Observable.create { observer in
            let dataRequest = self.base.validate(statusCode: 200 ..< 300)
                .responseArray(
                    queue: queue, keyPath: keyPath, context: context,
                    completionHandler: {
                        (packedResponse: DataResponse<[T]>) in
                        switch packedResponse.result {
                        case .success(let result):
                            if let _ = packedResponse.response {
                                observer.on(.next(result))
                            }
                            else {
                                observer.on(.error(RxAlamofireUnknownError))
                            }
                            observer.on(.completed)
                        case .failure(let error):
                            observer.on(.error(error as Error))
                        }
                })
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
