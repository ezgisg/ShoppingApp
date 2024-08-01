//
//  Router.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Alamofire
import AppResources
import Foundation


// MARK: - Router
enum Router: URLRequestConvertible {
    
    static let apiKey = ""
    
    case products(productId: Int?)
    case categories
    case carts(cartId: Int?, startDate: String?, endDate: String?)
    case productsFromCategory(categoryName: String)
    
    var baseURL: URL? {
        return URL(string: Constants.URLPaths.baseURL)
    }
    
    var path: String {
        switch self {
        case .products(let productId):
            if let productId {
                return "products/\(productId)"
            } else {
                return "products"
            }
        case .categories:
            return "products/categories"
        case .carts(cardId: let cartId):
            return "carts/\(cartId)"
        case .productsFromCategory(let categoryName):
            return "products/category/\(categoryName)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .products, .categories, .carts, .productsFromCategory:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: Parameters = [:]
        switch self {
        case .products:
            return nil
        case .categories:
            return nil
        case .carts(cartId: let cartId, startDate: let startDate, endDate: let endDate):
            params["startdate"] = startDate
            params["endDate"] = endDate
        case .productsFromCategory:
            return nil
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch method {
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseURL else {throw URLError(.badURL)}
        var urlRequest = URLRequest(url: baseURL.appending(path: path))

        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var completeParameters = parameters ?? [:]
//        completeParameters["api_key"] = Router.apiKey
        
        do {
            let request = try encoding.encode(urlRequest, with: completeParameters)
            debugPrint("*** Request URL: ", request.url ?? "")
            return request
        } catch  {
            debugPrint("*** Error urlrequest: ", error)
            throw error
        }
    }
    
}
