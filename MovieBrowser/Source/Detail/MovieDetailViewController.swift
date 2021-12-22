//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    
    // Outlets
    @IBOutlet weak var txtMovieTitle: UILabel!
    @IBOutlet weak var txtReleaseDate: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var txtDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        txtMovieTitle.text = movie.title
        if let releaseDate = movie.releaseDate {
            txtReleaseDate.text = Helper.getShortDate(dateString: releaseDate)
        }
        txtDescription.text = movie.description
        ImageManager.shared.loadImage(at: movie.posterPath ?? "") { [weak self] image in
            self?.imgPoster.image = image
        }
    }
}
