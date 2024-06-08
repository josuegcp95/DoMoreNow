//
//  NetworkReachability.swift
//  DoMore
//
//  Created by Josue Cruz on 6/8/24.
//

import Foundation
import Network

final class NetworkReachability {

    static let shared = NetworkReachability()
    let backgroundQueue = DispatchQueue.global(qos: .background)
    var pathMonitor: NWPathMonitor!
    var path: NWPath?

    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }

    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = pathUpdateHandler
        pathMonitor.start(queue: backgroundQueue)
    }

     func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}

