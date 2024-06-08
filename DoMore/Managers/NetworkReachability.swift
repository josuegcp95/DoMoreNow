//
//  NetworkReachability.swift
//  DoMore
//
//  Created by Josue Cruz on 6/8/24.
//

import Network

final class NetworkReachability {
    
    static let shared = NetworkReachability()
    private init() {}
    
    func isConnectedToInternet() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        let semaphore = DispatchSemaphore(value: 0)
        
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            isConnected = (path.status == .satisfied)
            /// Signal the semaphore once the status is known
            semaphore.signal()
        }
        
        monitor.start(queue: queue)
        
        /// Wait for the semaphore to be signaled
        semaphore.wait()
        /// Stop monitoring after we get the status
        monitor.cancel()
        
        print(isConnected ? print("Internet connection is available.") : print("No internet connection."))
        return isConnected
    }
}

