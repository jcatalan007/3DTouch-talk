//
//  DetailViewController.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/22/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var favorite: UILabel!

    var asset = Asset()
    var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let index = index {
            asset = AssetStorage.sharedStorage.asset(atIndex: index)
            name.text = asset.name
            detail.text = asset.detail
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            date.text = dateFormatter.string(from: asset.date)
            if asset.favorite {
                favorite.text = "❤️"
                favorite.isHidden = false
            } else {
                favorite.isHidden = true
            }
            thumbnail.image = UIImage(data: asset.imageData)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let indentifier = segue.identifier,
            indentifier == "EditAssetSegue",
            segue.destination.isKind(of: EditViewController.self)
        else {
            return
        }
        let dvc = segue.destination as! EditViewController
        dvc.index = index
    }

    @IBAction func cancelFromEdit(segue: UIStoryboardSegue) {}
    
    @IBAction func saveFromEdit(segue: UIStoryboardSegue) {
        if segue.source.isKind(of: EditViewController.self) {
            let svc = segue.source as! EditViewController
            asset = svc.asset
            AssetStorage.sharedStorage.update(asset, atIndex: index!)
        }
    }

}
