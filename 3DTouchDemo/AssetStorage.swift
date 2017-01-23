//
//  AssetStorage.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/21/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

struct AssetStorage {
    
    static var sharedStorage = AssetStorage()
    var assets = [Asset]()
    var persist = false
    
    init() {
        if let data = NSData(contentsOf: storageURL()) {
            let assetsPlist = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [[String:AnyObject]]
            assets = assetsPlist.flatMap({Asset(dictionary: $0)})
            persist = true
        } else {
            createDummyAssets()
        }
    }
    
    func storageURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storageURL = documentsDirectory.appendingPathComponent("storage.data")
        return storageURL
    }

    func saveAssets() {
        let assetsPlist = assets.map({$0.toDictionary()})
        let data = NSKeyedArchiver.archivedData(withRootObject: assetsPlist) as NSData
        data.write(to: storageURL(), atomically: true)
    }
    
    func retrieveAssets() -> [Asset] {
        return assets
    }
    
    func numberOfAssets() -> Int {
        return assets.count
    }
    
    mutating func deleteAllAssets() {
        assets = [Asset]()
        if persist {
            saveAssets()
        }
    }
    
    func asset(atIndex index: Int) -> Asset {
        return assets[index]
    }
    
    mutating func add(asset:Asset) {
        assets.append(asset)
        if persist {
            saveAssets()
        }
    }
    
    mutating func delete(assetAtIndex index: Int) {
        assets.remove(at: index)
        if persist {
            saveAssets()
        }
    }
    
    mutating func update(_ asset: Asset, atIndex index: Int) {
        assets[index] = asset
        if persist {
            saveAssets()
        }
    }
    
    mutating func createDummyAssets() {
        var image = UIImage(named: "dodge.png")
        var data =  UIImagePNGRepresentation(image!)
        var asset = Asset(name: "My Awesome Car", detail: "Dodge Challenger SXT", imageData: data!, date: Date(timeIntervalSinceNow: -52*24*60*60), favorite: false)
        add(asset: asset)
        image = UIImage(named: "fat-boy-special-2017.png")
        data =  UIImagePNGRepresentation(image!)
        asset = Asset(name: "My Harley", detail: "Fat Boy Special 2017", imageData: data!, date: Date(timeIntervalSinceNow: -100*24*60*60), favorite: true)
        add(asset: asset)
        image = UIImage(named: "tricycle.png")
        data =  UIImagePNGRepresentation(image!)
        asset = Asset(name: "My Tricycle", detail: "26 Schwinn Meridian", imageData: data!, date: Date(timeIntervalSinceNow: -221*24*60*60), favorite: false)
        add(asset: asset)
        image = UIImage(named: "tv.png")
        data =  UIImagePNGRepresentation(image!)
        asset = Asset(name: "My TV", detail: "Haier 65 inch 4K UHD", imageData: data!, date: Date(timeIntervalSinceNow: -112*24*60*60), favorite: false)
        add(asset: asset)
        image = UIImage(named: "Macbook.png")
        data =  UIImagePNGRepresentation(image!)
        asset = Asset(name: "My MacBook", detail: "MacBook Pro Touchbar", imageData: data!, date: Date(timeIntervalSinceNow: -27*24*60*60), favorite: false)
        persist = true
        add(asset: asset)
    }
    
    func mostRecentFavoriteAsset() -> (Asset, Int) {
        let favoriteAssets = assets.filter({ $0.favorite }).sorted { $0.date > $1.date }
        let favoriteAsset = favoriteAssets.first!
        let index = assets.index(of: favoriteAsset)!
        return (favoriteAsset, index)
    }
    
    func mostRecentNonFavoriteAsset() -> (Asset, Int) {
        let nonFavoriteAssets = assets.filter({ !$0.favorite }).sorted { $0.date > $1.date }
        let recentAsset = nonFavoriteAssets.first!
        let index = assets.index(of: recentAsset)!
        return (recentAsset, index)
    }
}
