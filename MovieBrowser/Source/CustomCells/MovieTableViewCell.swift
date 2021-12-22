//
//  MovieTableViewCell.swift
//  MovieBrowser
//
//  Created by Sanketh on 20/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtReleaseDate: UILabel!
    @IBOutlet weak var txtRating: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(movie: Movie) {
        txtTitle.text = movie.title
        if let releaseDate = movie.releaseDate {
            txtReleaseDate.text = Helper.getLongFormDate(from: releaseDate)
        } else {
            txtReleaseDate.text = "N/A"
        }
        txtRating.text = "\(movie.rating)"
    }
}
