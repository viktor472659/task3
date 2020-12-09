//
//  ViewController.swift
//  task3
//
//  Created by Viktor on 08.12.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var topRated: UIStackView!
    @IBOutlet weak var popularScrollView: UIScrollView!
    
    private var page_index = 1;
    private var flag  = true

    private let fetcher = MovieStore.shared
    private var topRatedMovies = [Movie]()
    private var popularMovies = [Movie]()

    private var yPosition: CGFloat = 0
    private var scrollViewContentSize: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularScrollView.delegate = self

        fetchTopRated()
        fetchPopular()
    }
    
    
    private func fetchTopRated(){
        fetcher.fetchMovies(from: .topRated) { (result) in
                
            switch result {
            case .success(let response):
                self.topRatedMovies = response.results
                
                self.setupTopRatedMovies()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func fetchPopular(){
        fetcher.fetchMovies(from: .popular, page_index: page_index){(result) in
            switch result {
            case .success(let response):
                self.popularMovies = response.results
                
                self.setupPopularMovies()
                
                self.page_index += 1
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.flag = true
        }
    }
    
    private func setupTopRatedMovies(){

            self.topRatedMovies.forEach { (Movie) in
            do {
                let data = try Data(contentsOf: Movie.posterURL)
                let myImg:UIImage = UIImage(data: data)!
                
                if let containerView = Bundle.main.loadNibNamed("ContainerView", owner: nil, options: nil)!.first as?
                    ContainerView {
                                containerView.translatesAutoresizingMaskIntoConstraints = false
                    containerView.widthAnchor.constraint(equalToConstant:       self.topRated.frame.height).isActive = true
                                containerView.label.text = Movie.title
                                containerView.image.image = myImg
                                let gesture = MyTapGesture(target: self, action:  #selector (self.onMovieClick (_:)))
                                gesture.id = Movie.id
                                containerView.addGestureRecognizer(gesture)
                    self.topRated.addArrangedSubview(containerView)
                                }
                
            }catch {
                let alert = UIAlertController(title: "Error", message: "Setup Top Rated movies error occured", preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setupPopularMovies(){
        
        let containerHeight: CGFloat  = 300
        let containerWidth: CGFloat  = popularScrollView.frame.width
        DispatchQueue.global(qos: .userInitiated).async() {

            self.popularMovies.forEach{ (Movie) in
            do {
                let data = try Data(contentsOf: Movie.posterURL)
                let myImg:UIImage = UIImage(data: data)!
                DispatchQueue.main.async() {

                if let bigContainerView = Bundle.main.loadNibNamed("BigContainerView", owner: nil, options: nil)!.first as?
                    BigContainerView {
                    
                    bigContainerView.frame.size.width = containerWidth
                    bigContainerView.frame.size.height = containerHeight
                    bigContainerView.frame.origin.x = 0
                    bigContainerView.frame.origin.y = self.yPosition

                    bigContainerView.title.text = Movie.title
                    bigContainerView.year.text = Movie.yearText
                    bigContainerView.imageView.image = myImg

                    
                    let gesture = MyTapGesture(target: self, action:  #selector (self.onMovieClick (_:)))
                    gesture.id = Movie.id
                    bigContainerView.addGestureRecognizer(gesture)
                    
                    let spacer:CGFloat = 20
                    
                    self.yPosition+=spacer + containerHeight
                    self.scrollViewContentSize+=spacer+containerHeight

                    self.popularScrollView.contentSize=CGSize(width: containerWidth, height: self.scrollViewContentSize)
                    
                        bigContainerView.progressBar.progressLvl = Movie.rating

                        self.popularScrollView.addSubview(bigContainerView)
                    }
                }
                
            }catch{
                let alert = UIAlertController(title: "Error", message: "Setup Popular movies error occured", preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        }
        }
    }
    
    @objc private func onMovieClick(_ sender:MyTapGesture){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
               detailsViewController.idOfMovie = sender.id
               
        self.navigationController?.pushViewController(detailsViewController, animated: true)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentSize.height - scrollView.contentOffset.y < 1500 && self.flag){
            self.flag = false
            self.fetchPopular()
           }
    }
    
}

class MyTapGesture: UITapGestureRecognizer {
    var id = Int()
}
