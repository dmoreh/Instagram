//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Daniel Moreh on 2/10/16.
//  Copyright © 2016 Daniel Moreh. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var photosTableView: UITableView!

    var photosArray: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()


        self.photosTableView.delegate = self
        self.photosTableView.dataSource = self
        self.photosTableView.rowHeight = 320

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        self.photosTableView.insertSubview(refreshControl, atIndex: 0)

        self.refreshControlAction(refreshControl)
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
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
                            self.photosArray = responseDictionary["data"] as? NSArray
                            self.photosTableView.reloadData()
                    }
                    refreshControl.endRefreshing()
                }
        });
        task.resume()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = self.photosTableView.indexPathForCell(sender as! UITableViewCell)
        vc.imageURL = self.photosArray![indexPath!.row].valueForKeyPath("images.standard_resolution.url") as? String
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
        let imageURL = photosArray![indexPath.row].valueForKeyPath("images.standard_resolution.url") as! String
        cell.photoImageView.setImageWithURL(NSURL(string: imageURL)!)

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosArray = self.photosArray else {
            return 0
        }

        return photosArray.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
