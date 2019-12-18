//
//  Model.swift
//  Practice Second Exam
//
//  Created by Pablo Martín Redondo on 16/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import Foundation
import UIKit

struct Item : Codable, Identifiable {
    let albumId : Int
    let id : Int
    let title: String
    let url : URL
    let thumbnailUrl : URL
}

class ModelItems : ObservableObject{
    @Published var items : [Item] = []
    var surl = "https://jsonplaceholder.typicode.com/photos"
    
    func download(){
        guard let url = URL(string: surl) else{
            return
        }
        DispatchQueue(label: "downloadQueue").async{
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let downloadItems = try decoder.decode([Item].self, from: data)
                DispatchQueue.main.sync {
                    //aqui actualizamos interfaz de usuario
                    self.items = downloadItems
                }
            }catch{
                print("\(error)")
                return
            }
        }
    }
    
}

class ImageDownloader : ObservableObject {
    
    var description: String = ""
    var imageQueue : DispatchQueue
    @Published var dicc : [URL:UIImage] = [:]
    
    init() {
        imageQueue = DispatchQueue(label: "imageQueue")
    }
    
    func image(url : URL) -> UIImage{
        if let val = dicc[url] {
            return val
        } else {
            imageQueue.async{
                //self.method1(url: url)
                self.method2(url: url)
            }
            dicc[url] = UIImage(named: "downloading")
            return dicc[url]!
        }
    }
    //Shared session, data task, completion handler
    func method1(url : URL){
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error : Error?) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200{
                if let img = UIImage(data: data!) {
                    DispatchQueue.main.sync {
                        self.dicc[url] = img
                    }
                } else {
                    print("Error construyendo imagen")
                }
            } else{
                print("Error de descarga")
            }
        }
        
        task.resume()
    }
    //con default session, download task y completion handler
    func method2(url : URL){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.downloadTask(with: url) { (location: URL? , response : URLResponse?, error: Error?) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                do{
                    let data : Data = try Data(contentsOf: location!)
                    if let img = UIImage(data: data) {
                        DispatchQueue.main.sync {
                            self.dicc[url] = img
                        }
                    } else {
                        print("Error construyendo imagen")
                    }
                }catch{}
            } else{
                print("Error de descarga")
            }
        }
        task.resume()
    }
    /* Este es solo para viewcontroller, no vale
    //con default session, download task y download delegate
    func method3(url : URL){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            let data : Data = try Data(contentsOf: location)
            if let img = UIImage(data: data) {
                self.dicc[location] = img
            } else {
                print("Error construyendo imagen")
            }
        }catch{}
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
    }*/
    
}

//Para un array de ints o de strings no haría falta convertirlo a tipo data
//pero UserDefaults no acepta tipos personalizados, asique hay que guardarlo como tipo
//data

class Memory : ObservableObject{
    @Published var items : [Item]
    var jsonEncoder : JSONEncoder = JSONEncoder()
    init(){
        var optional : [Item]? = nil
        if let data = UserDefaults.standard.value(forKey:"items") as? Data {
            optional = try? JSONDecoder().decode([Item].self, from: data)
        }
        items = optional ?? []
    }
    func change(item: Item){
        if(contains(item: item)){
            remove(item: item)
        }else{
            add(item: item)
        }
    }
    
    private func add(item : Item){
        items.append(item)
        UserDefaults.standard.set(try? jsonEncoder.encode(items), forKey: "items")
    }
    
    private func remove(item: Item){
        items.removeAll { (i:Item) -> Bool in
            i.id == item.id
        }
        UserDefaults.standard.set(try? jsonEncoder.encode(items), forKey: "items")
    }
    
    func contains(item: Item)->Bool{
        return items.contains { (i) -> Bool in
            i.id == item.id
        }
    }
    
}
