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
    
    private var showDetailsId: Int!
    
    private var mainStackView: UIStackView!
    
    private var descriptionLabel: UILabel!
    
    private var mainScrollView: UIScrollView = UIScrollView()
    
    public var didTapRating : ((Double) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getShowDetail(showDetailsId, completion: {  [weak self] response in
            
            switch response {
            
            case .failure(let error):
                
                print(error)
                break
                
            case .success(let details):
                
                    self?.ShowsDetails = details
                   
                    self?.getImageFromUrl(urlString: details.image.original) { [weak self] image in
                        
                        DispatchQueue.main.async {
                            
                           let resizedImage =  image.resizeImage(targetSize: CGSize(width: 200, height: 350))
                            
                            self?.setupViewWith(image: resizedImage)
                            
                        }
                        
                    }
                    
                break
            
            }
            
        })
        
       
    }
    
    init(showDetailsId: Int) {
        
        super.init(nibName: nil, bundle: nil)
        self.showDetailsId = showDetailsId
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ShowDetails Deinited")
    }
    
}

//MARK:- View
extension ShowDetailsViewController {
    
    
    private func setupViewWith(image: UIImage) {
        
        self.navigationItem.title = ShowsDetails.name
      
        self.navigationController?.navigationBar.barTintColor = .black
        
        self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
        
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        
        setupMainScrollView()
        
        mainStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20)
        
        let imageView = UIImageView(image: image)
        
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
        
        mainStackView.addArrangedSubview(getCosmosView())
        
        constrainMainStackView()
        
        setUpBackButton()
        
    }
    
    
    func setUpBackButton() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "\u{276E} Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClick(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func backButtonClick(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
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
            
            self.dismiss(animated: true, completion: nil)
            
            self.didTapRating?(rating)
            
        }
        
        cosmoView.settings.textFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        cosmoView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        return cosmoView
        
    }
    
    private func constrainMainStackView() {
        
        mainScrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 60),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -5)
        ])
        
    }
    
    private func setupMainScrollView() {
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
       
        self.view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
        ])
        
    }
    
}


//MARK:-
extension ShowDetailsViewController {
    
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
//            valuelabel.textAlignment = .left
            
            let horizontalStackView =  utility.getStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
            horizontalStackView.addArrangedSubview(keylabel)
            horizontalStackView.addArrangedSubview(valuelabel)
            
            mainStackView.addArrangedSubview(horizontalStackView)
            
        }
        
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
    
}
