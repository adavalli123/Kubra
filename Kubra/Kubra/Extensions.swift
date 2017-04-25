//
//  Extensions.swift
//  Kubra
//
//  Created by Srikanth Adavalli on 4/25/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     *  @customNavController :  is used for custom Navigation Bar
     *  barStyle (optional)  :  setting Navigation Bar Style
     *  tintColor(optional)  :  setting tintColor
     */
    
    func customNavController(barStyle: UIBarStyle?, tintColor: UIColor?) {
        let navBar = self.navigationController?.navigationBar
        
        if let barStyle = barStyle {
            navBar?.barStyle = barStyle
        }
        else {
            navBar?.barStyle = UIBarStyle.blackOpaque
        }
        
        if let tintColor = tintColor {
            navBar?.tintColor = tintColor
        }
        else {
            navBar?.tintColor = UIColor.white
        }
    }
    
    func getVC<T>(fromStoryBoardName: String, withIdentifier: String) -> T {
        return UIStoryboard(name: fromStoryBoardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! T
    }
}

extension UITableView {
     func setupTableView() {
        self.tableFooterView = UIView()
    }
}
