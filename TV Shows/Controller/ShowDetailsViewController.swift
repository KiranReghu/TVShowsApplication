//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Harikrishnan S R on 22/09/21.
//

import UIKit
import Cosmos
import CoreData

class ShowDetailsViewController: UIViewController {

    private var utility = Utility()
    
    private var ShowsDetails: ShowsListModel!
    
    public var showDetailsId: Int!
    
    private var mainStackView: UIStackView!
    
    private var descriptionLabel: UILabel!
    
    private var mainScrollView: UIScrollView = UIScrollView()
    
    private var seasons: [Seasons] = []
    
    public var didTapRating : ((Double) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }
    
    init(showDetailsId: Int) {
        
        super.init(nibName: nil, bundle: nil)
        self.showDetailsId = showDetailsId
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("ShowDetails Deinited")
    }
    
}

//MARK:- View
extension ShowDetailsViewController {
    
    private func setupViewWith(image: UIImage) {
        
        setUpNavigationItems()
        
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        
        setupMainScrollView()
        
        mainStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20)
        
        setBackgroundImage(image: image)
        
        let imageView = getImageView(image)
        
        descriptionLabel = utility.getLabel( UIFont.systemFont(ofSize: 18, weight: .regular), color: .white)
        descriptionLabel.numberOfLines = 0
        
        let summery = ShowsDetails.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

        descriptionLabel.text = summery
       
        mainStackView.addArrangedSubview(imageView)
        
        mainStackView.addArrangedSubview(descriptionLabel)
        
        let line1 = utility.getView(color: .white, width:  Int(view.bounds.width) - 20, height: 3)
        mainStackView.addArrangedSubview(line1)
        
        setDictionaryDetails()
        
        let line2 = utility.getView(color: .white, width:  Int(view.bounds.width) - 20, height: 3)
        mainStackView.addArrangedSubview(line2)
        
        mainStackView.addArrangedSubview( getSeasonView())
        
        let line3 = utility.getView(color: .white, width:  Int(view.bounds.width) - 20, height: 3)
        mainStackView.addArrangedSubview(line3)
        
        mainStackView.addArrangedSubview(getCosmosView())
        
        constrainMainStackView()
        
        setUpBackButton()
        
    }
    
    private func setUpNavigationItems() {
        
        self.navigationItem.title = ShowsDetails.name
      
        self.navigationController?.navigationBar.barTintColor = .black
        
        self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
        
    }
    
    func setBackgroundImage(image: UIImage){
        
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        self.view.insertSubview(backgroundImageView, at: 0)
        
    }
    
    private func getImageView(_ image: UIImage) -> UIImageView{
        
        let imageView = UIImageView(image: image)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
        
    }
    
    private func getSeasonView() -> UIStackView{
        
        let seasonLabel = utility.getLabel( UIFont.systemFont(ofSize: 18, weight: .regular), color: .white)
        seasonLabel.text = "Seasons"
        
        let verticalView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20)
        
        verticalView.addArrangedSubview(seasonLabel)
        verticalView.addArrangedSubview(getRoundedStack(seasons.count))
        
        return verticalView
        
    }
    
    private func getRoundedStack(_ count: Int) -> UIScrollView {
        
        let horizontalView = utility.getStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 20)
        
        for index in 0...count-1 {
            
            let countLabel = utility.getLabel( UIFont.systemFont(ofSize: 14, weight: .regular), color: .white)
            countLabel.text = "\(index + 1)"
            
            let roundedView = utility.getRoundedView(40, radius: 20, view: countLabel)
            horizontalView.addArrangedSubview(roundedView)
            
        }
        
        let scrollView = UIScrollView(frame: .zero)
        
        constrainRoundedView(scrollView, horizontalView)
        
        return scrollView
        
    }
    
    private func constrainRoundedView(_ parentView: UIScrollView, _ childView: UIStackView) {
        
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(childView)
        
        NSLayoutConstraint.activate([
            
            parentView.heightAnchor.constraint(equalToConstant: 50),
            
            childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            childView.topAnchor.constraint(equalTo: parentView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            
        ])
        
    }
    
    private func setUpBackButton() {
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back-button")?.resizeImage(targetSize: CGSize(width: 30, height: 30)),
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(backButtonClick(sender:)))
        newBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    private func getCosmosView() -> UIView{
        
        let cosmoView = CosmosView()
        cosmoView.rating =  Double( (fetchRating(ShowsDetails.id)?.rating ) ?? 0)
        cosmoView.settings.totalStars = 5
        cosmoView.settings.starSize = 40
        cosmoView.settings.starMargin = 5
        cosmoView.settings.fillMode = .full
        cosmoView.settings.textMargin = 10
        cosmoView.settings.textColor = UIColor.yellow
        cosmoView.didTouchCosmos = {[weak self] rating in
            
            guard let `self` = self else {return}
            
            
            self.updateRating(self.ShowsDetails.id, rating: rating)
            
            self.navigationController?.popViewController(animated: true)
            
            self.didTapRating?(rating)
            
        }
        
        cosmoView.settings.textFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        cosmoView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        return cosmoView
        
    }
    
    private func constrainMainStackView() {
        
        mainScrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func setupMainScrollView() {
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
       
        self.view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
    }
    
}

//MARK:- Utility
extension ShowDetailsViewController {
    
    private func loadData() {
        
        getShowDetail(showDetailsId, completion: {  [weak self] response in
            
            switch response {
            
            case .failure(let error):
                
                print(error)
                break
                
            case .success(let details):
                
                self?.getSeasons(details.id, completion: { seasons in
                    
                    self?.seasons = seasons
                    
                    self?.ShowsDetails = details
                   
                if let url = details.image?.original {
                    
                    self?.getImageFromUrl(urlString: url) { [weak self] image in
                            
                            DispatchQueue.main.async {
                                
                               let resizedImage =  image.resizeImage(targetSize: CGSize(width: 200, height: 350))
                                
                                self?.setupViewWith(image: resizedImage)
                                
                            }
                            
                        }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self?.setupViewWith(image: UIImage(named: "dummy")!)
                        
                    }
                
                }
                    
                })
                
               
                
                break
            
            }
            
        })
        
    }
    
    private func getMoviewDetailsDictionary() -> [String : String] {
        
        let details : [String : String] = [
        
            "Status":         ShowsDetails.status.rawValue,
            "Premiered Date": ShowsDetails.premiered ?? "",
            "Run Time":       ShowsDetails.runtime?.description ?? "",
            "Url":            ShowsDetails.url,
            "Rating":         ShowsDetails.rating.average?.description ?? ""
            
        ]
        
        return details
        
    }
    
    private func setDictionaryDetails() {
        
        getMoviewDetailsDictionary().forEach { item in
            
            let keylabel = utility.getLabel(UIFont.systemFont(ofSize: 18, weight: .regular), color: .white, numberOfLines: 0)
            keylabel.textAlignment = .left
            keylabel.text =  item.key
            
            let valuelabel = utility.getLabel(UIFont.systemFont(ofSize: 18, weight: .regular), color: .white, numberOfLines: 0)
            valuelabel.text = ":  " + item.value
            
            let horizontalStackView =  utility.getStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
            horizontalStackView.addArrangedSubview(keylabel)
            horizontalStackView.addArrangedSubview(valuelabel)
            
            mainStackView.addArrangedSubview(horizontalStackView)
            
        }
        
    }
  
}

//MARK:- Targets
extension ShowDetailsViewController {
    
    @objc func backButtonClick(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
//        self.dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK:- APIs
extension ShowDetailsViewController {
    
    private func getShowDetail(_ id: Int, completion : @escaping ((Result<ShowsListModel, Error>) -> ())) {
        
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(id)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let showsInDataFormat = data else {
                completion(.failure(NetworkErrors.wrongUrl))
                return
            }
            
            do {
                
                let datSource = try JSONDecoder().decode(ShowsListModel.self , from: showsInDataFormat)
                
                completion(.success(datSource))
                
            } catch let error {
                
                completion(.failure(error))
                
            }
            
        }.resume()
      
    }
    
    private func getImageFromUrl(urlString: String, completion : @escaping ((UIImage) -> ())) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let imageInDataFormat = data else {
                completion(UIImage(named: "dummyImage")!)
                return
            }
            
            completion(UIImage(data: imageInDataFormat)!)
            
        }.resume()
      
    }
    
    private func getSeasons(_ id: Int, completion : @escaping (([Seasons]) -> () )) {
        
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(id)/seasons") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let showsInDataFormat = data else {
                completion([])
                return
            }
            
            do {
                
                let seasons = try JSONDecoder().decode([Seasons].self , from: showsInDataFormat)
                
                completion(seasons)
                
            } catch  {
                
                completion([])

            }
            
        }.resume()
      
    }
}

//MARK:- CoreData
extension ShowDetailsViewController {
  
    func fetchRating(_ id: Int) ->  RatingEntity?{
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = delegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<RatingEntity> = RatingEntity.fetchRequest()
        
        do {
            
            request.predicate = NSPredicate(format: "id == \(id)")
            let entities =  try context?.fetch(request)
            
            return entities?.first
            
            
        } catch let error {
            print(error)
        }
        
        return nil
        
    }
    
    func updateRating(_ id: Int, rating: Double) {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        let context = delegate?.persistentContainer.viewContext
        
        if let entity = fetchRating(id) {
            
            entity.rating = rating
            
        } else {
            
            let newEntity = RatingEntity(context: context!)
            
            newEntity.id = Int32(id)
            newEntity.rating = rating
            
        }
        
        do {
            
            try context?.save()
            
        } catch let error {
            
            print(error)
            
        }
        
    }
}
