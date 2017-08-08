//
//  WebRequest.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/7/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Contains static functions for handling web requests and parses responses into JSON
//

import Foundation

class WebRequest
{
    // MARK:- Enums
    
    enum RequestMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    enum WebRequestError {
        case noConnection
        case serverError
        case timeout
        case invalidURL
    }
    
    // MARK:- Properties
    
    // Singleton
    static var shared = WebRequest()
    private init() {}
    
    fileprivate let TIMEOUT_SECONDS: TimeInterval = 10
    
    fileprivate var globalSession = URLSession(configuration: .default)
    
    // MARK:- Public API
    
    // Make a request of the given type with the given parameters. Calls the callback on obtaining the JSON and optional error if the request fails
    func request(urlString: String, method: RequestMethod, parameters: [String: Any]?, callback: @escaping (JSON?, WebRequestError?) -> Void)
    {
        // setup URL request with parameters
        var url: URL? = nil
        
        if parameters != nil {
            url = urlWithParameters(urlString: urlString, parameters: parameters!)
        }
        else {
            url = URL(string: urlString)
        }
        
        if let url = url
        {
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: TIMEOUT_SECONDS)
            urlRequest.httpMethod = method.rawValue
            
            // begin data task
            let task = globalSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if error != nil
                {
                    print("Error in request in WebRequest: \(error!.localizedDescription)")
                    callback(nil, .serverError)
                }
                else if let data = data
                {
                    // attempt to parse json in result
                    if let json = try? JSON(data: data) {
                        callback(json, nil)
                    }
                    else {
                        callback(nil, .serverError)
                    }
                }
                else {
                    callback(nil, .serverError)
                }
            })
            
            task.resume()
        }
        else
        {
            callback(nil, .invalidURL)
        }
    }
    
    // MARK:- Private Functions
    
    // constructs the url based on the given URL and the parameters
    fileprivate func urlWithParameters(urlString: String, parameters: [String: Any]) -> URL?
    {
        if var components = URLComponents(string: urlString)
        {
            var query = ""
            for (key, value) in parameters {
                query += "\(key)=\(value)&"
            }
            
            // remove last & from query
            query.characters.removeLast()
            
            components.query = query
            return components.url
        }
        
        return nil
    }
}


