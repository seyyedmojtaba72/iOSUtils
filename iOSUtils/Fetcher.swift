//
//  Fetcher.swift
//  DeveloParsUtils
//
//  Created by Mojtaba on 3/15/17.
//  Copyright © 2017 DeveloPars. All rights reserved.
//

import Foundation

public class Fetcher {
    
    public static func fetchURLAsync(urlAddress: String, completion: ((_ status: Bool, _ result: String)->())? = nil) {
        print("[fetchURLAsync] Fetching \(urlAddress)")
        
        guard let url = URL(string: urlAddress) else {
            print("[fetchURLAsync] Error: \(urlAddress) doesn't seem to be a valid URL")
            DispatchQueue.main.sync(execute: {
                completion!(false, "url is invalid")
            })
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("[fetchURLAsync] Error: \(error.debugDescription)")
                DispatchQueue.main.sync(execute: {
                    completion!(false, error.debugDescription)
                })
                return
            }
            guard let data = data else {
                print("[fetchURLAsync] Error! Data is nil!")
                DispatchQueue.main.sync(execute: {
                    completion!(false, "data in nil")
                })
                return
            }
            
            if let result = String(data: data, encoding: .utf8) {
                //print("[fetchURLAsync] Fetching done. result: \(result)")
                DispatchQueue.main.sync(execute: {
                    completion!(true, result)
                })
                return
            }
            
            print("[fetchURLAsync] Fetching done with empty response")
            DispatchQueue.main.sync(execute: {
                completion!(false, "")
            })
        }
        
        task.resume()
    }
    
    public static func fetchURL(urlAddress: String) -> String {
        print("[fetchURL] Fetching \(urlAddress)")
        
        guard let url = URL(string: urlAddress) else {
            print("[fetchURL] Error: \(urlAddress) doesn't seem to be a valid URL")
            return ""
        }
        
        do {
            let result = try String(contentsOf: url, encoding: String.Encoding.utf8)
            //print("[fetchURL] Fetching done. result: \(result)")
            return result
        } catch let error {
            print("[fetchURL] Error: \(error)")
        }
        
        print("[fetchURL] Fetching done with empty response")
        return ""
    }
    
    
    public static func uploadFile(urlAddress: String, fileAddress: String, completion: ((_ status: Bool, _ result: String) -> Void)? = nil) {
        print("[uploadFile] Uploading \(fileAddress) to \(urlAddress)")
        
        if (!FileManager.default.fileExists(atPath: fileAddress)) {
            print("[uploadFile] File Not Found!")
            completion!(false, "file not found")
        }
        
        let fileUrl = URL(string: fileAddress)
        let fileName = (fileAddress as NSString).lastPathComponent
        let fileData = NSData(contentsOf: fileUrl!)
        
        let url = URL(string: urlAddress)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let body = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type:multipart/form-data; boundary=\(boundary)\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"uploaded_file\"; filename=\(fileName)\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append(fileData! as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        request.httpBody = body as Data
        
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard ((data) != nil), let _:URLResponse = response, error == nil else {
                print("[uploadFile] Error: \(error.debugDescription)")
                DispatchQueue.main.sync(execute: {
                    completion!(false, "fail")
                })
                return
            }
            
            if let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                print("[uploadFile] Upload Completed. Result: \(result)")
                DispatchQueue.main.sync(execute: {
                    completion!(true, result as String)
                })
                return
            }
            
        })
        
        task.resume()
    }
    
    
    public static func uploadFile(urlAddress: String, fileData: Data?, fileName: String, completion: ((_ status: Bool, _ result: String) -> Void)? = nil) {
        print("[uploadFile] Uploading \(fileName) to \(urlAddress)")
        
        if (fileData == nil) {
            print("[uploadFile] File Data is Nil!")
            completion!(false, "data is nil")
        }
        
        let url = URL(string: urlAddress)
        
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let body = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type:multipart/form-data; boundary=\(boundary)\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"uploaded_file\"; filename=\(fileName)\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append(fileData! as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        request.httpBody = body as Data
        
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard ((data) != nil), let _:URLResponse = response, error == nil else {
                print("[uploadFile] Error: \(error.debugDescription)")
                DispatchQueue.main.sync(execute: {
                    completion!(false, "fail")
                })
                return
            }
            
            if let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                print("[uploadFile] Upload Completed. Result: \(result)")
                DispatchQueue.main.sync(execute: {
                    completion!(true, result as String)
                })
                return
            }
            
        })
        
        task.resume()
    }
    
    
    
    public static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}
