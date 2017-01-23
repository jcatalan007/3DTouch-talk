//
//  ShortcutHandler.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/23/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

extension AppDelegate {

    func createDynamicShortcuts() {
        
        let application = UIApplication.shared
        
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        
        let (favoriteAsset, indexOfFavorite) = AssetStorage.sharedStorage.mostRecentFavoriteAsset()
        let favoriteShortcut = UIMutableApplicationShortcutItem(
            type: "\(bundleIdentifier).Favorite",
            localizedTitle: favoriteAsset.name,
            localizedSubtitle: favoriteAsset.detail,
            icon: UIApplicationShortcutIcon(type: .love),
            userInfo: ["version": Bundle.main.fullVersionNumber!, "index":indexOfFavorite]
        )
        
        let (recentAsset, indexOfRecent) = AssetStorage.sharedStorage.mostRecentNonFavoriteAsset()
        let recentShortcut = UIMutableApplicationShortcutItem(
            type: "\(bundleIdentifier).Recent",
            localizedTitle: recentAsset.name,
            localizedSubtitle: recentAsset.detail,
            icon: UIApplicationShortcutIcon(type: .task),
            userInfo: ["version": Bundle.main.fullVersionNumber!, "index":indexOfRecent]
        )
        
        application.shortcutItems = [favoriteShortcut, recentShortcut]
        
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handled = handleSortCutItem(shortcutItem)
        completionHandler(handled)
    }
    
    func handleSortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var vcs = (window!.rootViewController as! UINavigationController).viewControllers
        if vcs.count > 1 {
            vcs.last!.performSegue(withIdentifier: "UnwindToMainSegue", sender: nil)
            vcs = (window!.rootViewController as! UINavigationController).viewControllers
        }
        let main = vcs.first as! MainTableViewController
        switch shortcutItem.type {
        case "net.bitcrafters.3DTouchDemo.AddAsset":
            main.performSegue(withIdentifier: "NewAssetSegue", sender: nil)
        case "net.bitcrafters.3DTouchDemo.Favorite":
            main.segueForShortcutToDetail(shortcutItem.userInfo?["index"] as! Int)
        case "net.bitcrafters.3DTouchDemo.Recent":
            main.segueForShortcutToDetail(shortcutItem.userInfo?["index"] as! Int)
        default:
            break
        }
        return true
    }

}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var fullVersionNumber: String? {
        guard
            let _ = releaseVersionNumber,
            let _ = buildVersionNumber
        else {
            return nil
        }
        return "\(releaseVersionNumber!).\(buildVersionNumber!)"
    }
}
