//
//  ReachabilityManager.swift
//
//
//  Created by Ezgi Sümer Günaydın on 1.08.2024.
//

import Alamofire
import AppResources
import Foundation

// MARK: ReachabilityManager
public final class ReachabilityManager {
    public static let shared = ReachabilityManager()
    
    private init() {}
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: Constants.URLPaths.hostURL)
    
    public func startNetworkReachabilityObserver(completion: @escaping (Bool) -> Void) {
        reachabilityManager?.startListening { status in
            switch status {
            case .unknown:
                print("Network status is unknown")
                completion(false)
            case .notReachable:
                print("Network is not reachable")
                completion(false)
            case .reachable(_):
                completion(true)
            }
        }
    }
    
    public func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

