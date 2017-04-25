//
//  DetailViewController.swift
//  Kubra
//
//  Created by Srikanth Adavalli on 4/25/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [DataModel] = []
    var id: Int64?
    var networkRequestor: NetworkRequestor = NetworkRequestor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail".uppercased()
        self.tableViewSetUp()
        self.networkRequest()
    }
}

extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DETAIL_TABLE_VIEW_CELL, for: indexPath) as? DetailTableviewCell {
            
            let data = dataSource[indexPath.row]
            
            if let title = data.title, let body = data.body {
                cell.configure(title: title, body: body)
            }
            return cell
        }
        
        return UITableViewCell()
    }
}

extension DetailViewController {
    fileprivate func tableViewSetUp() {
        self.tableView.setupTableView()
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
    }
    
    fileprivate func networkRequest() {
        networkRequestor.request(url: DETAIL_BASE_URL, method: GET, params: ["id" : String(describing: id)]) { [weak self](dataModel, error) in
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
