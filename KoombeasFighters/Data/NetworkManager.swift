//
//  NetworkManager.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import Foundation

class NetworkManager {
    private let session: URLSession
    
    private var task: URLSessionDataTask?
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(url: String, completion: @escaping (Data) -> Void, failure: @escaping (GeneralError) -> Void) {
        if let url = URL(string: url) {
            task = session.dataTask(with: url) { (data, response, error) in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse
                else {
                    failure(GeneralError.message(string: "Invalid Response"))
                    return
                }
                
                if response.statusCode == 200 {
                    completion(data)
                
                } else {
                    if let error = error {
                        failure(GeneralError.message(string: error.localizedDescription))
                    
                    } else {
                        failure(GeneralError.message(string: "Invalid Response"))
                    }
                }
            }
            
            task?.resume()
        
        } else {
            failure(GeneralError.message(string: "Invalid URL"))
        }
    }
}
