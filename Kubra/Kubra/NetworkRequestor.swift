//
//  NetworkRequestor.swift
//  Kubra
//
//  Created by Srikanth Adavalli on 4/25/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import Foundation

class NetworkRequestor {
    func request(url:String, method: String, params: [String: String], completion: @escaping ([DataModel?], Error?)->() ){
        if let url = URL(string:url) {
            let request = NSMutableURLRequest(url: url)
            if method == POST {
                // convert key, value pairs into param string
                let postString = params.map { "\(String(describing: $0.0))=\(String(describing: $0.1))" }.joined(separator: AND)
                request.httpMethod = POST
                request.httpBody = postString.data(using: String.Encoding.utf8)
            }
            else if method == GET {
                _ = params.map { "\(String(describing: $0.0))=\(String(describing: $0.1))" }.joined(separator: "")
                request.httpMethod = GET
            }
            else if method == PUT {
                let putString = params.map { "\(String(describing: $0.0))=\(String(describing: $0.1))" }.joined(separator: AND)
                request.httpMethod = PUT
                request.httpBody = putString.data(using: String.Encoding.utf8)
            }
            // Add other verbs here
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do {
                    
                    // what happens if error is not nil?
                    // That means something went wrong.
                    
                    // Make sure there really is some data
                    if let data = data {
                        let response = try JSONSerialization.jsonObject(with: data, options:  JSONSerialization.ReadingOptions.mutableContainers)
                        let resultsData = (response as AnyObject)                         
                        if let responseArray = resultsData as? [[String: AnyObject]] {
                            var modelData: [DataModel] = [DataModel]()
                            
                            for model in responseArray {
                                
                                let dataModel = DataModel(dict: model)
                                modelData.append(dataModel)
                                
                            }
                            completion(modelData, nil)
                        }
                    }
                    else {
                        // Data is nil.
                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        else{
            // Could not make url. Is the url bad?
            // You could call the completion handler (callback) here with some value indicating an error
        }
    }
}
