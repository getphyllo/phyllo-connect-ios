//
//  NetworkHandler.swift
//  phyllo_sdk
//
//  Created by Sanket on 10/08/21.
//

import UIKit
import PhylloConnect

class NetworkHandler: NSObject {
    static var localhost: Bool = false
    static let imageCache = NSCache<NSString,NSData>(), viewCache=NSCache<NSString,NSData>();
    static var newToken = "";static var updatingRemoteToken = false

    static func post(suffix : String,mapData: [String:Any],env:PhylloEnvironment, completion handler: @escaping (_ response: [String: Any], _ error: Error?) -> Void) {
        var request = URLRequest(url: URL(string: env.rawValue+suffix)!)
        request.httpMethod="POST"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        let postData: Data? = try? JSONSerialization.data(withJSONObject: mapData, options: [])
        request.httpBody = postData
        request.setValue("\(UInt((postData?.count)!))", forHTTPHeaderField: "Content-Length")
        request.addValue(G.authHeader, forHTTPHeaderField: "Authorization")
        request.addValue(G.sdkType, forHTTPHeaderField: G.sdkTypeHeaderKey)
        request.addValue(G.sdkVersion, forHTTPHeaderField: G.sdkVersionHeaderKey)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { (data, response, error) -> Void in
            var resp: [String:Any]?
            if let data = data {
                if error == nil {
                    resp = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                }
            }
            if resp == nil {resp=["status":"fail"];}
            DispatchQueue.main.async(execute: {
                handler(resp!, error as Error?)
            })
        }.resume()
    }
    
    static func get(suffix : String,env:PhylloEnvironment, completion handler: @escaping (_ response: [String: Any], _ error: Error?) -> Void) {
        var request = URLRequest(url: URL(string: env.rawValue + suffix)!)
        request.httpMethod="GET"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.addValue(G.sdkToken, forHTTPHeaderField: "Authorization")
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { (data, response, error) -> Void in
            var resp: [String:Any]?
            if let data = data {
                if error == nil {
                    resp = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                }
            }
            if resp == nil {resp=["status":"fail"];}
            DispatchQueue.main.async(execute: {
                handler(resp!, error as Error?)
            })
        }.resume()
    }
    
    static func getImage(_ url:String, _ cache:Int, handler: @escaping (_ image:UIImage?, _ error: Error?, _ url:String)->Void) {
        let origUrl = url;
        let key = getKeyFromUrl(url);
        if let d = imageCache.object(forKey: key as NSString){
            handler(UIImage(data: d as Data) ,nil, origUrl);
            return;
        }
        if let d = viewCache.object(forKey: key as NSString){
            handler(UIImage(data: d as Data) ,nil, origUrl);
            return;
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        if FileManager.default.fileExists(atPath: dir.appendingPathComponent(key).path){
            let img = UIImage(contentsOfFile: dir.appendingPathComponent(key).path);
            handler(img,nil, origUrl);
            if img != nil && cache == 1 {
                let imgData = img!.jpegData(compressionQuality: 1)! as NSData;
                imageCache.setObject(imgData, forKey: url as NSString, cost: imgData.length);
            }
            return;
        }
        if let imgUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                DispatchQueue.main.async(execute: {() -> Void in
                    if error != nil {handler(nil,error, origUrl);return;}
                    if let img = UIImage(data: data!) {
                        handler(img,nil, origUrl);
                        let key = getKeyFromUrl(url);
                        let imgData = img.jpegData(compressionQuality: 1)! as NSData;
                        if cache == 1 {addImageToCache(img, key);}
                        else if cache == 2 {
                            viewCache.removeObject(forKey: "small_\(key)" as NSString);
                            viewCache.setObject(imgData, forKey: key as NSString, cost: imgData.length);
                        }else {
                            viewCache.setObject(imgData, forKey: key as NSString, cost: imgData.length);
                        }
                    }else {handler(nil,error, origUrl);}
                })
                }.resume();
        }
    }
    
    class func addImageToCache(_ img:UIImage, _ key: String){
        let imgData = img.jpegData(compressionQuality: 1)! as NSData;
        imageCache.setObject(imgData, forKey: key as NSString, cost: imgData.length);
        do {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
            try img.jpegData(compressionQuality: 1.0)!.write(to: dir.appendingPathComponent("\(key)"), options: .atomic)
        } catch { }
    }
    
    private class func getKeyFromUrl(_ url:String)->String{
        var url = url;
        return url.replace("[^a-z,0-9]", replaceWith: "");
    }
    
    class func onLowMemory(){
        viewCache.removeAllObjects();
        imageCache.removeAllObjects();
    }
    
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
