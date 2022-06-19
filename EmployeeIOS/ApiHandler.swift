//
//  ApiHandler.swift
//  EmployeeIOS
//
//  Created by eldhose mathai on 19/06/22.
//  Copyright © 2022 eldhose mathai. All rights reserved.
//

import Foundation

class ApiHandler{
    
    public static var sharedAPIService = ApiHandler()
    
    class func shared() -> ApiHandler {
        return sharedAPIService
    }

    lazy var networkSessionHandler = NetworkSessionHandler()
    
    lazy var sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 90
        configuration.timeoutIntervalForResource = 90
 
        return URLSession(configuration: configuration, delegate: networkSessionHandler, delegateQueue: .main)
    }()
    
    func downloadImage(from url: URL, imageResponseHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        ApiHandler.shared().sessionManager.dataTask(with: url) { data, urlResponse, error in
            if (error == nil && data != nil && data != Data()), let imageData = data {
                imageResponseHandler(imageData, urlResponse, error)
            }else{
                imageResponseHandler(nil, nil, nil)
            }
        }.resume()
    }
    
    enum HTTPMethod: String {
        case get = "GET", post = "POST", delete = "DELETE", patch = "PATCH"
    }
    
    static func createRequest(apiURL: String, httpMethod: HTTPMethod) ->  URLRequest{
        
        var request = URLRequest(url: URL(string: apiURL)!,timeoutInterval: Double.infinity)
        
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    struct APIResponse : Codable {
        var errorCode : String?
        var errorDescription : String?
        
        enum CodingKeys: String, CodingKey {
            case errorCode = "ErrorCode"
            case errorDescription = "ErrorDescription"
        }
        
        init(from decoder: Decoder) throws {
            let values = try? decoder.container(keyedBy: CodingKeys.self)
            errorCode = try? values?.decodeIfPresent(String.self, forKey: .errorCode)
            errorDescription = try? values?.decodeIfPresent(String.self, forKey: .errorDescription)
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        if let data = jsonString.data(using: .utf8) {
            guard let modelObj = try? JSONDecoder().decode(T.self, from: data) else { return nil}
            return modelObj
        }
        return nil
    }

    func callAPI(callURl: String, httpMethod: HTTPMethod = .get,  completionHandler: @escaping (_ responseString: String?, _ reponseError: Bool?, _ errorMessage: String?) -> ()) {
        
        let request = ApiHandler.createRequest(apiURL: callURl, httpMethod: httpMethod)
    
        ApiHandler.shared().sessionManager.dataTask(with: request) { (resData, urlRes, error) in
   
            DispatchQueue.main.async {
    
                if(error == nil && resData != nil)
                {
                    
                    let responseString = String(decoding: resData!, as: UTF8.self)
                    
                    completionHandler(responseString, false, nil)                    
                }
            }
        }.resume()
    }
}

class NetworkSessionHandler: NSObject, URLSessionDelegate {
    
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        // Indicate network status, e.g., offline mode
        print("taskIsWaitingForConnectivity")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest: URLRequest, completionHandler: (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        // Indicate network status, e.g., back to online
        print("willBeginDelayedRequest")
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("didBecomeInvalidWithError")
    }
    
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("urlSessionDidFinishEvents-forBackgroundURLSession", session)
    }
}



