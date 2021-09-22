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
        
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        mainStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 10)
       
        setUpSearchTextField()
        
        setUpCollectionView()
        
        constrainMainStackView()
        
    }
    
    private func setUpSearchTextField() {
        
        let image =  (UIImage(named: "search")!).resizeImage(targetSize: CGSize(width: 20, height: 20))
        
        image.withTintColor(.lightGray)
        searchTextField = utility.getTextField(height: 40,
                                               placeHolderImage: image,
                                               placeHolderName: "Search Series")
        
//        searchTextField.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: -5)
        
        searchTextField.layer.cornerRadius = 6
        
        searchTextField.backgroundColor = .lightText
        
        mainStackView.addArrangedSubview(searchTextField)
        
    }
    
    private func setUpCollectionView() {
        
        let flowlayout = UICollectionViewFlowLayout()
        
        showsCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        showsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        showsCollectionView.backgroundColor = .black.withAlphaComponent(0.2)
       
        showsCollectionView.register(ShowsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        showsCollectionView.dataSource = self
        showsCollectionView.delegate = self
        mainStackView.addArrangedSubview(showsCollectionView)
        
    }
   
    private func constrainMainStackView() {
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
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
        
        cell.setView(image: UIImage(named: "dummy")!, labelValue: "Loading...")
        
        getImageFromUrl(urlString: imageUrl.medium, completion: { image in
            
            DispatchQueue.main.async {
                
                cell.setView(image: image, labelValue: self.ShowsDataSource[indexPath.row].name)
                
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



