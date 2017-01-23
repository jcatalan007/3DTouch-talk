//
//  MainTableViewController.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/21/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssetStorage.sharedStorage.numberOfAssets()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetTableViewCell", for: indexPath) as! AssetTableViewCell
        cell.asset = AssetStorage.sharedStorage.asset(atIndex: indexPath.row)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AssetStorage.sharedStorage.delete(assetAtIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let indentifier = segue.identifier,
            indentifier == "DetailSegue",
            segue.destination.isKind(of: DetailViewController.self)
        else {
            return
        }
        let index = self.tableView!.indexPathForSelectedRow!.row
        let dvc = segue.destination as! DetailViewController
        dvc.index = index
    }
    
    @IBAction func cancelFromEdit(segue: UIStoryboardSegue) {}

    @IBAction func saveFromEdit(segue: UIStoryboardSegue) {
        if segue.source.isKind(of: EditViewController.self) {
            let svc = segue.source as! EditViewController
            let asset = svc.asset
            AssetStorage.sharedStorage.add(asset: asset)
        }
    }
}
