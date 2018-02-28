//
//  MasterViewController.swift
//  Duck Duck Go
//
//  Created by Parthiban on 2/28/18.
//  Copyright © 2018 Ossum. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var results = [SearchResultModel]()

    @IBOutlet var masterTableView: UITableView!
    
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
        
        reloadViewWithSearchResult()

    }

    override func viewWillAppear(_ animated: Bool) {
//        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func switchView(_ sender: Any) {
        
    }
    
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.masterTableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                let result = results[indexPath.row]

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
    // MARK: - Table View


extension MasterViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)

//        let object = objects[indexPath.row] as! NSDate
        
        let object = results[indexPath.row]
        
        if let titlelbl = object.title {
            cell.textLabel!.text = titlelbl
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

