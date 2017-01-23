//
//  Asset.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/21/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

struct Asset {
    var name = ""
    var detail = ""
    var imageData = Data()
    var date = Date()
    var favorite = false
}

extension Asset {
    
    func toDictionary() -> [String:AnyObject] {
        return ["name":name as NSString,
                "detail":detail as NSString,
                "date":date as NSDate,
                "imageData":imageData as NSData,
                "favorite":favorite as NSNumber
        ]
    }

    init!(dictionary: [String:AnyObject]) {
        guard
            let name = dictionary["name"] as? String,
            let detail = dictionary["detail"] as? String,
            let imageData = dictionary["imageData"] as? Data,
            let date = dictionary["date"] as? Date,
            let favorite = dictionary["favorite"] as? Bool
        else {
            return nil
        }
        self.init(name:name, detail:detail, imageData:imageData, date:date, favorite:favorite)
    }
}

