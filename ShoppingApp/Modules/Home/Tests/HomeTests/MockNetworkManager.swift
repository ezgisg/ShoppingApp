//
//  MockNetworkManager.swift
//
//
//  Created by Ezgi Sümer Günaydın on 5.09.2024.
//

import AppResources
import Alamofire
import Network
@testable import Network

final class MockNetworkManager<M: Decodable>: NetworkProtocol {
    
    // MARK: - Privates
    private var isSuccess: Bool
    private var response: M?
    private var errorType: BaseError
    
    // MARK: - Init
    init(
        isSuccess: Bool,
        response: M? = "",
        errorType: BaseError = .unknown
    ){
        self.isSuccess = isSuccess
        self.response = response
        self.errorType = errorType
    }
    
    
    func request<T>(
        _ request: any Alamofire.URLRequestConvertible,
        decodeToType type: T.Type,
        completion: @escaping (Result<T, BaseError>) -> ()
    ) where T : Decodable {
        if isSuccess,
           let response = response as? T {
            completion(.success(response))
        } else {
            completion(
                .failure(errorType)
            )
        }
    }
    
}
