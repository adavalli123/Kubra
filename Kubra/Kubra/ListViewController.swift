//
//  ListViewController.swift
//  Kubra
//
//  Created by Srikanth Adavalli on 4/25/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [DataModel] = []
    let networkRequestor: NetworkRequestor = NetworkRequestor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setupTableView()
        self.configNavigationBar()
        self.configTableView()
        
        self.title = "List".uppercased()
        self.networkRequest()
    }
    
}
// MARK: - Table view data source

extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LIST_TABLE_VIEW_CELL, for: indexPath) as? ListTableViewCell {
            
            let data = dataSource[indexPath.row]
            if let name = data.name, let userName = data.username, let street = data.address?[STREET], let city = data.address?["city"], let zipcode = data.address?["zipcode"] {
                cell.configure(name: name.uppercased(), userName: "UserName \t\(userName)", address: "Address \t\t\(street) \n \t\t\t\t\(city) \n\t\t\t\t\(zipcode)")
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = getVC(fromStoryBoardName: STORYBOARD_DETAIL, withIdentifier: STORYBOARD_DETAIL) as DetailViewController
        
        if let id = dataSource[indexPath.row].id {
            vc.id = id.int64Value
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension ListViewController {
    fileprivate func configNavigationBar() {
        self.customNavController(barStyle: nil, tintColor: nil)
    }
    
    fileprivate func configTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func networkRequest() {
        networkRequestor.request(url: LIST_BASE_URL, method: GET, params: ["" : ""]) { [weak self](dataModel, error) in
            for model in dataModel {
                if let model = model {
                    self?.dataSource.append(model)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
            
        }
    }
}

