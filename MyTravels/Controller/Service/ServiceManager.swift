//
//  ServiceManager.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 09/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class ServiceManager {
    
    // MARK: - Init
    class func sharedInstance() -> ServiceManager {
        struct Singleton {
            static var sharedInstance = ServiceManager()
        }
        return Singleton.sharedInstance
    }

    // MARK:- Methods

    func request (url: String,
                  method: HTTPMethod,
                  parameters: [String: Any]? = nil,
                  headers: [String: String]? = nil,
                  success: @escaping (_ data: Data) -> Void,
                  failure: @escaping (_ response: ServiceError) -> Void,
                  completion: @escaping () -> Void) {
        guard let urlRequest =  URL(string: url) else { return }
        let request = NSMutableURLRequest(url: urlRequest)
        
        //creating request
        request.httpMethod = method.rawValue
        
        //parsing values
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        if let parameters = parameters {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch {
                    let error = ServiceError(code: "", error: "Parsin Error")
                    failure(error)
                    completion()
                }
        }
        
        //session
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                let erro = ServiceError(code: "404", error: error.debugDescription)
                failure(erro)
                completion()
            }
            guard let code = (response as? HTTPURLResponse)?.statusCode,
                code >= 200 &&  code <= 299 else {
                    if let data = data {
                        let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
                        let parsedResult = JSONResponse.deserialize(data: newData) as? [String:AnyObject]
                        let errorResponse = ServiceError(dictionary: parsedResult!)
                        failure(errorResponse)
                    } else {
                        let errorResponse = ServiceError(code: "", error: "Unexpected error")
                        failure(errorResponse)
                    }
                    return
            }
            guard let data = data else { return }
            success(data)
        }
        dataTask.resume()
    }
    
}
