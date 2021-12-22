//
//  Helper.swift
//  MovieBrowser
//
//  Created by Sanketh on 20/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

struct Helper {
    static func getLongFormDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let createdDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: createdDate)
        }
        return ""
    }
    
    static func getShortDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let createdDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: createdDate)
        }
        return ""
    }
}
