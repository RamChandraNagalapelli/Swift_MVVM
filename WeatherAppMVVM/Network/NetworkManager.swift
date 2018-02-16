//
//  NetworkManager.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkManager: NSObject {
    static var isReachable: Bool = false

    class func requestForURL(reqUrl: URL, method: HttpMethod, parameters: [String : Any]?, success: @escaping (_ data: NSDictionary) -> Void, failure: @escaping (_ error: Error?) -> Void) {
//        guard isReachable else {
//            failure("Please check your internet connection.")
//            return
//        }

        // Create request
        let request = NSMutableURLRequest(url: reqUrl)
        request.httpMethod = method.rawValue

        // Set Header
        let headerParameters: [String: Any] = ["Content-Type": "application/json"]
        for obj in headerParameters {
            if let value = obj.value as? String {
                request.setValue(value, forHTTPHeaderField: obj.key)
            }
        }

        // Set Body
        if parameters != nil && method == .post {
            var jsonData: Data = Data()
            do {
                jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            } catch let error as NSError {
                print(error)
            }
            request.httpBody = jsonData
        }

        // Set Session
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            print(response ?? URLResponse())
            if error != nil {
                DispatchQueue.main.async {
                    failure(error)
                }
            } else {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        DispatchQueue.main.async {
                            print(responseDictionary)
                            success(responseDictionary)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        print("JSONSerialization-Failure = \(String(describing: responseString))")
                        success(["msg" : "JSONSerialization Failed", "success": true])
                    }
                }
            }
        }
        task.resume()
    }

    // Checking Network Connection
    @objc class func checkReachability() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            if NetworkManager.isReachable {
                NetworkManager.isReachable = false
            }
            return
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        if NetworkManager.isReachable != (isReachable && !needsConnection) {
            NetworkManager.isReachable = (isReachable && !needsConnection)
        }
        return
    }

    static var timer: Timer? = nil
    class func observeReachability() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkReachability), userInfo: nil, repeats: true)
    }
}
