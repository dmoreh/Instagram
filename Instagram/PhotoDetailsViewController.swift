//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Daniel Moreh on 2/15/16.
//  Copyright © 2016 Daniel Moreh. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!

    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageURL = imageURL, url = NSURL(string: imageURL) {
            photoImageView.setImageWithURL(url)
        }
    }
}
