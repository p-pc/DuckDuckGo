//
//  MasterViewController.swift
//  Duck Duck Go
//
//  Created by Parthiban on 2/28/18.
//  Copyright © 2018 Ossum. All rights reserved.
//

import UIKit
import Kingfisher

class MasterViewController: UIViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var results = [SearchResultModel]() {
        didSet {
            searchResults = results
        }
    }

    var searchResults = [SearchResultModel]()

    @IBOutlet var masterTableView: UITableView!
    
    @IBOutlet weak var masterCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: ., target: self, action: #selector(switchView(_:)))
        
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
            let switchButton = UIBarButtonItem(image: UIImage(named: "gridswitch"), style: .plain, target: self, action: #selector(switchView(_:)))
            navigationItem.rightBarButtonItem = switchButton
        }
        
        self.title = "Seinfeld"
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            detailViewController?.title = ""
        }
        
        masterTableView.isHidden = false
        masterCollectionView.isHidden = true
        
        
        reloadViewWithSearchResult()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MasterViewController.appCameToForeground),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)

    }

    @objc func appCameToForeground(){
        
        reloadViewWithSearchResult()

    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        reloadViewWithSearchResult()
    }
    
    func reloadViewWithSearchResult() {
        
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertActionOK)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }

        let searchText = "seinfeld+characters"
        
        ServiceManager.sharedInstance.getResultsFor(searchText: searchText, completion: { error,response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            func onSuccess(response: [SearchResultModel]) {
                
                self.results = response
                
                DispatchQueue.main.async {
                    
                    self.refreshData()
                    
                }
            }
            
            func onFailure(error: Error) {
                
                self.results = [SearchResultModel]()
                
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(alertActionOK)
                
                DispatchQueue.main.async {
                    
                    self.refreshData()
                    
                    //Comment : alert the user when something fails
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            if let err = error {
                
                onFailure(error: err)
                
            }
            else {
                
                guard let respData = response else {
                    
                    onFailure(error: NSError(domain:"", code:-1, userInfo:["localizedDescription":"Something went wrong"]))
                    
                    return
                }
                
                onSuccess(response: respData)
            }
            
        })
        
    }

    func refreshData() {
        masterTableView.reloadData()
        masterCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func switchView(_ sender: Any) {
        
        if masterTableView.isHidden {
            masterTableView.isHidden = false
            masterCollectionView.isHidden = true
        }
        else {
            masterTableView.isHidden = true
            masterCollectionView.isHidden = false
        }
        
    }
    
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.masterTableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                let result = searchResults[indexPath.row]

                controller.resultItem = result
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                if let resTitle = result.title {
                    controller.title = resTitle
                }
            }
        }
        else if segue.identifier == "showDetailFromCollection" {
            if let indexPath = self.masterCollectionView.indexPathsForSelectedItems?.first {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                let result = searchResults[indexPath.row]
                
                controller.resultItem = result
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                if let resTitle = result.title {
                    controller.title = resTitle
                }
            }
        }

    }
}

// MARK: - UISearchBarDelegate

extension MasterViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searchResults = results
            refreshData()
            return
        }
        
        let searchResultsFiltered = results.filter({($0.text?.localizedCaseInsensitiveContains(searchText))!})

        searchResults = searchResultsFiltered
        
        refreshData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }

    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MasterViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)

//        let object = objects[indexPath.row] as! NSDate
        
        let object = searchResults[indexPath.row]
        
        if let titlelbl = object.title {
            cell.textLabel!.text = titlelbl
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Seinfeld"
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MasterViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellIdentifier", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named:"placeholder")
        
        let resultItem = searchResults[indexPath.row]
        
        if let imageURL = resultItem.iconURL {
            
            let plcHldrImg = UIImage(named: "placeholder")
            
            if let builtUrl = URL.init(string: imageURL) {
                
                let resource = ImageResource(downloadURL: builtUrl, cacheKey: imageURL)
                cell.imageView.kf.setImage(with: resource, placeholder: plcHldrImg, options: [.targetCache(Utility.sharedInstance.userMediaCache),.cacheMemoryOnly], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    
                    if let err = error {
                        dLog("error in downloading profile image : \(err)")
                        
                        DispatchQueue.main.async {
                            cell.imageView.image = UIImage(named: "placeholder")
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                        
                        
                    }
                    
                    
                })
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeaderView", for: indexPath) as! ReusableHeaderView

            headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            
            headerView.titleLabel.text = "Seinfeld"
            
            return headerView
            
        default:
                assert(false, "Unexpected element kind")

        }
    }
    
}

