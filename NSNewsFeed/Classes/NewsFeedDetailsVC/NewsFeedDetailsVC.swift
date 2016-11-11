//
//  NewsFeedDetailsVC.swift
//  NSNewsFeed
//
//  Created by Spaculus MM on 26/08/15.
//  Copyright (c) 2015 Spaculus MM. All rights reserved.
//

import UIKit

class NewsFeedDetailsVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    let cellIdentifierCodingCell = "CodingCell"
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.register(UINib(nibName: cellIdentifierCodingCell, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifierCodingCell)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UItableViewMethods
    // MARK: - UITableView Delegates -
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: cellIdentifierCodingCell, for: indexPath) as! CodingCell
        
        
        
        return cell
    }
    // MARK:  UITableView Height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 145
    }

}
