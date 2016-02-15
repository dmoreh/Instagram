//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Daniel Moreh on 2/10/16.
//  Copyright © 2016 Daniel Moreh. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    var photosDictionary: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.photosDictionary = responseDictionary
                    }
                }
        });
        task.resume()

    }

}

