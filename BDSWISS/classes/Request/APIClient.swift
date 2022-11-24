//
//  APIClient.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 24.11.2022.
//

import Foundation
import RxSwift

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
}

private enum Error: Swift.Error {
    case invalidResponse(URLResponse?)
    case invalidJSON(Swift.Error)
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard let components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

class APIClient {
    private let baseURL = URL(string: serverURL)!
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        let request = apiRequest.request(with: baseURL)
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }
            .map { data in
                do {
                    let items = try JSONDecoder().decode(T.self, from: data)
                    return items
                }
                catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
}
