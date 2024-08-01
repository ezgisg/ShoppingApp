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
public enum Router: URLRequestConvertible {
    
    static let apiKey = ""
    
    case products
    case product(productId: Int)
    case categories
    case carts(startDate: String?, endDate: String?)
    case cart(cartId: Int)
    case productsFromCategory(categoryName: String)
    
    var baseURL: URL? {
        return URL(string: Constants.URLPaths.baseURL)
    }
    
    var path: String {
        switch self {
        case .products:
            return "products"
        case .product(let productId):
            return "products/\(productId)"
        case .categories:
            return "products/categories"
        case .carts:
            return "carts"
        case .cart(let cartId):
            return "carts/\(cartId)"
        case .productsFromCategory(let categoryName):
            return "products/category/\(categoryName)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .products, .product, .categories, .carts, .cart, .productsFromCategory:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: Parameters = [:]
        switch self {
        case .products:
            return nil
        case .product:
            return nil
        case .categories:
            return nil
        case .carts(startDate: let startDate, endDate: let endDate):
            if let startDate {
                params["startdate"] = startDate
            }
            if let endDate {
                params["endDate"] = endDate
            }
        case .cart:
            return nil
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
    
    public func asURLRequest() throws -> URLRequest {
        guard let baseURL else {throw URLError(.badURL)}
        var urlRequest = URLRequest(url: baseURL.appending(path: path))

        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let completeParameters = parameters ?? [:]
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
