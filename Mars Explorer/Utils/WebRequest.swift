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
    
    enum RequestMethod: String
    {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    enum WebRequestError
    {
        case noConnection
        case serverError
        case timeout
        case invalidURL
        case other
    }
    
    // MARK:- Properties
    
    // Singleton
    static var shared = WebRequest()
    private init()
    {
        let config = URLSessionConfiguration.default
        
        config.timeoutIntervalForResource = 20
        config.timeoutIntervalForRequest = 20
        config.httpMaximumConnectionsPerHost = 1
        
        self.fileDownloadSession = URLSession(configuration: config)
    }
    
    fileprivate let TIMEOUT_SECONDS: TimeInterval = 20
    
    fileprivate var globalSession = URLSession(configuration: .default)
    fileprivate var fileDownloadSession: URLSession!
    
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
                    if let urlError = error as? URLError
                    {
                        if urlError.code == .timedOut {
                            callback(nil, .timeout)
                        }
                        else {
                            callback(nil, .serverError)
                        }
                        
                        return
                    }
                    
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
    
    // Download data at the given list of urls
    func downloadDataAtURLs(urls: [String], callback: @escaping ([Data]?, WebRequestError?) -> Void)
    {
        var datalist = [Data]()
        let queue = DispatchQueue(label: "Data Download", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        queue.async {
            
            for urlString in urls
            {
                if let url = URL(string: urlString)
                {
                    if let data = try? Data(contentsOf: url) {
                        datalist.append(data)
                    }
                    else {
                        callback(nil, .serverError)
                        return
                    }
                }
                else
                {
                    callback(nil, .serverError)
                    return
                }
            }
            
            callback(datalist, nil)
        }
    }
    
    // Download the files at the given urls
    // Calls the callback with the list of URLs where these files have been written to
    func downloadFilesAtUrls(urls: [String], tempDirectoryFolderName: String, callback: @escaping ([URL]?, WebRequestError?) -> Void)
    {
        var tempLocations = [URL]()
        let filemanager = FileManager.default
        var filesdownloaded = 0
        var expectedTotalFiles = urls.count
        let path = filemanager.temporaryDirectory.appendingPathComponent(tempDirectoryFolderName)
        
        do {
            try filemanager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print("Failed to create directory: \(path.absoluteString)")
        }
        
        for urlString in urls
        {
            if let downloadUrl = URL(string: urlString)
            {
                let task = fileDownloadSession.downloadTask(with: downloadUrl, completionHandler: { [weak self] (tempUrl, response, error) in
                    if error != nil
                    {
                        expectedTotalFiles -= 1
                        print("Error. Could not download: \(downloadUrl.absoluteString)\nMessage:\(error!.localizedDescription)")
                        
                        if filesdownloaded == expectedTotalFiles {
                            callback(tempLocations, nil)
                            return
                        }
                        
                        self?.fileDownloadSession.delegateQueue.cancelAllOperations()
                    }
                    else if let url = tempUrl
                    {
                        // move file to the folder in the temp directory
                        let filename = url.lastPathComponent
                        let extenstion = url.pathExtension
                        let fullpath = path.appendingPathComponent(filename, isDirectory: false).appendingPathExtension(extenstion)
                        
                        do
                        {
                            try filemanager.moveItem(at: url, to: fullpath)
                            filesdownloaded += 1
                            tempLocations.append(fullpath)
                            
                            print("\(filesdownloaded)/\(expectedTotalFiles) files downloaded")
                            
                            if filesdownloaded == expectedTotalFiles {
                                callback(tempLocations, nil)
                                return
                            }
                        }
                        catch {
                            print("Error in moving file \(url) to \(fullpath)")
                            callback(nil, .other)
                        }
                    }
                })
                task.resume()
            }
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


