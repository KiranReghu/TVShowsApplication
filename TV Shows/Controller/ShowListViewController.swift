//
//  ViewController.swift
//  TV Shows
//
//  Created by Kiran R on 22/09/21.
//

import UIKit

class ShowListViewController: UIViewController {

    var utility = Utility()
    var mainStackView: UIStackView!
    var searchTextField: UITextField!
    var showsCollectionView: UICollectionView!
    
    var ShowsDataSource: [ShowsListModel] = []
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        setupView()
        
        getShows { [weak self] response in
            
            switch response {
            
            case .failure(let error):
                print(error)
                break
                
            case .success(let showsList):
                
                DispatchQueue.main.async {
                    
                    self?.ShowsDataSource.append(contentsOf: showsList)
                    self?.showsCollectionView.reloadData()
                    
                }
                
                break
            
            }
            
        }
        
    }
    
    override func viewWillLayoutSubviews() {
     
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = showsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
        
    }

    deinit {
        print("ShowList DeInited")
    }

}

//MARK:- View
extension ShowListViewController {
    
    private func setupView() {
        
        setNavigationView()
        
        mainStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 15)
       
        setUpSearchTextField()
        
        setUpCollectionView()
        
        constrainMainStackView()
        
    }
    
    private func setNavigationView() {
        
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 36/255, alpha: 1)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern: 2.0,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .semibold)
        ]
        
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    private func setUpSearchTextField() {
        
        let image =  (UIImage(named: "search")!).resizeImage(targetSize: CGSize(width: 20, height: 20))
        
        image.withTintColor(.darkGray)
        searchTextField = utility.getTextField(height: 40,
                                               placeHolderImage: image,
                                               placeHolderName: "Search Series")
        
        let searchPlaceholderText = NSAttributedString(string: "Search Series",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                
        searchTextField.attributedPlaceholder = searchPlaceholderText
        
        searchTextField.textColor = .white
        searchTextField.layer.cornerRadius = 6
        
        searchTextField.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        
        mainStackView.addArrangedSubview(searchTextField)
        
    }
    
    private func setUpCollectionView() {
        
        let flowlayout = UICollectionViewFlowLayout()
        
        showsCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        showsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        showsCollectionView.backgroundColor =  UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        
        showsCollectionView.register(ShowsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        showsCollectionView.dataSource = self
        showsCollectionView.delegate = self
        mainStackView.addArrangedSubview(showsCollectionView)
        
    }
   
    private func constrainMainStackView() {
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
        
    }
    
}

//MARK:- CollectionView Delegate
extension ShowListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShowsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = showsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowsCollectionViewCell
        cell.backgroundColor = .darkGray
        let imageUrl = ShowsDataSource[indexPath.row].image
        
        cell.imageView.image = UIImage(named: "dummy")!
        cell.showName.text = "Loading..."
        cell.labelRating.text = "0.0"
        
        getImageFromUrl(urlString: imageUrl.medium, completion: { image in
            
            DispatchQueue.main.async {
                
                cell.imageView.image = image
                cell.showName.text = self.ShowsDataSource[indexPath.row].name
                cell.labelRating.text = self.ShowsDataSource[indexPath.row].rating.average?.rounded().description ?? "0.0"
                
            }
            
        })
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ShowDetailsViewController(showDetailsId: ShowsDataSource[indexPath.row].id)
        
        vc.didTapRating = { (rating : Double) in
            
            let alert = UIAlertController(title: "TV show", message: "Your rating is \(rating.rounded()) ", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
          
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .fullScreen
        
        nav.navigationBar.backgroundColor = .black
   
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.bounds.width/2
        let height = self.view.bounds.height/3
        
       return CGSize(width: width - 10, height: height)
        
    }
    
}

//MARK:- APIs
extension ShowListViewController {
    
    private func getShows(completion : @escaping ((Result<[ShowsListModel], Error>) -> ())) {
        
        guard let url = URL(string: "https://api.tvmaze.com/shows?page=1") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let showsInDataFormat = data else {
                completion(.failure(NetworkErrors.wrongUrl))
                return
            }
            
            do {
                
                let datSource = try JSONDecoder().decode([ShowsListModel].self , from: showsInDataFormat)
                
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



