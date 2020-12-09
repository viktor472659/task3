//
//  DetailsViewController.swift
//  task2.1
//
//  Created by Viktor on 01.12.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var votedLabel: UILabel!
    
    @IBOutlet weak var circleView: CircleProgressBar!
    private var movie: Movie?
    private let fetcher = MovieStore.shared
    public var idOfMovie: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
             
        fetcher.fetchMovie(id: idOfMovie ?? -1) { (result) in
           switch result {
           case .success(let response):
            self.setup(with: response)
           case .failure(let error):
            
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            self.present(alert, animated: true)
           }
        }
    }
    
  
    
    private func setup(with model: Movie) {
        
        self.titleLabel.text = model.title
        self.yearLabel.text = model.yearText
        
        let data = try! Data(contentsOf: model.posterURL)
        self.imageView?.image = UIImage(data: data)

        circleView.progressLvl = model.rating
        circleView.animate(toValue: CGFloat( model.rating) / 100)

        self.votedLabel.text = "Проголосували: \(model.voteCount)"
        self.descLabel.text = model.overview

    }

}
