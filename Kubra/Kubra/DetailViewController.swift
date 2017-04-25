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
    weak var actionToEnable : UIAlertAction?
    
    var dataSource: [DataModel] = []
    var id: Int64 = -1
    var networkRequestor: NetworkRequestor = NetworkRequestor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
        self.title = "Detail".uppercased()
        self.tableViewSetUp()
        self.getNetworkRequest()
    }
    
    func addTapped() {
        
        var titleTextField: String = ""
        var bodyTextField: String = ""
        
        let alert = UIAlertController.init(title: "Add Text and Body", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Title"
            textField.addTarget(self, action: #selector(self.textChanged(sender:)), for: .editingChanged)
        }
        
        alert.addTextField { textField2 in
            textField2.placeholder = "Body"
            textField2.addTarget(self, action: #selector(self.textChanged(sender:)), for: .editingChanged)
        }
        
        let addAlertButton = UIAlertAction.init(title: "Save", style: UIAlertActionStyle.default) { [weak alert] (action) -> Void in
            if let textField = alert?.textFields?[0].text {
                
                titleTextField = textField
                self.tableView.reloadData()
            }
            
            if let textField2 = alert?.textFields?[1].text {
                bodyTextField = textField2
                
                self.tableView.reloadData()
            }
            
            self.networkRequestor.request(url: DETAIL_BASE_URL, method: POST, params: ["userId": String(self.id), "title": titleTextField, "body": bodyTextField], completion: {[weak self](dataModel, error) in
                for model in dataModel {
                    if let model = model {
                        if model.userId?.int64Value == self?.id {
                            self?.dataSource.append(model)
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        }
        
        if bodyTextField.characters.count > 0 && titleTextField.characters.count > 0 {
            addAlertButton.isEnabled = true
        } else {
            addAlertButton.isEnabled = false
        }
        
        self.actionToEnable = addAlertButton
        
        let noAlertButton = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(addAlertButton)
        alert.addAction(noAlertButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textChanged(sender:UITextField) {
        if (sender.text?.characters.count)! > 0 {
            self.actionToEnable?.isEnabled = true
        }
            
        else {
            self.actionToEnable?.isEnabled = false
        }
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
    
    fileprivate func getNetworkRequest() {
        networkRequestor.request(url: DETAIL_BASE_URL, method: GET, params: ["userId" : String(describing: id)]) { [weak self](dataModel, error) in
            for model in dataModel {
                if let model = model {
                    if model.userId?.int64Value == self?.id {
                        self?.dataSource.append(model)
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
}
