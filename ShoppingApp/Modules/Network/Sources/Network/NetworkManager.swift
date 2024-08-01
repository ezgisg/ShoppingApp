//
//  NetworkManager.swift
//
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Alamofire
import Foundation

//MARK: NetworkManager
final class NetworkManager {
    static let shared = NetworkManager()
    
    func request<T: Decodable> (_ request: URLRequestConvertible, decodeToType type: T.Type, completion: @escaping (Result<T,BaseError>) -> ()) {
        AF.request(request).responseData { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decoding))
                    debugPrint(error.localizedDescription)
                }
            case .failure(let error):
                let statusCode = response.response?.statusCode ?? 0
                completion(.failure(getErrorType(according: statusCode)))
                debugPrint(error.localizedDescription)
            }
        }
        
    }
    
}


// MARK: - Error Management
private extension NetworkManager {
    final func getErrorType(according statusCode: Int) -> BaseError {
        switch statusCode {
            /// Bad Request
        case 400: return .badRequest
            /// Authorization
        case 401: return .auth
            /// Forbidden
        case 403: return .forbidden
            /// Not Found
        case 404: return .notFound
            /// Invalid Method
        case 405: return .invalidMethod
            /// Timeout
        case 408: return .timeout
            /// Request Cancelled
        case 499: return .requestCancelled
            /// Internal Server Error
        case 500: return .internalServerError
            /// Default
        default: return .unknown
        }
    }
}
