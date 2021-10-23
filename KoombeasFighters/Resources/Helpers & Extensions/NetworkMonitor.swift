//
//  NetworkMonitor.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 23/10/21.
//

import Network
import Combine

class NetworkMonitor {
    static let shared = NetworkMonitor()
    var isReachable: Bool { status == .satisfied }
    
    private let monitor = NWPathMonitor()
    private var status = NWPath.Status.requiresConnection
    
    let publisherNetworkAvailable = PassthroughSubject<Bool, Never>()
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.publisherNetworkAvailable.send( path.status == .satisfied )
        }
        
        let queue = DispatchQueue(label: "MonitorQueue")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

