//
//  NewsFeedViewController.swift
//  NSNewsFeed
//
//  Created by Naeem Shaikh on 24/08/15.
//  Copyright (c) 2015 Naeem Shaikh. All rights reserved.
//

import UIKit
import LoremIpsum
import SDWebImage
import MBProgressHUD

class NewsFeedVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate,MBProgressHUDDelegate{

    // MARK: - Outlets & Var -
    @IBOutlet var tblView: UITableView!
    let cellIdentifier = "cellIdentifier"
    let cellIdentifierTextAndImage = "TextAndImageCell"
    var aryTableData = [String]()
    var pageTitle:String = ""
    var tableHeaderTitle = ""
    var tableFooterTitle = ""
    
    // MARK: - ViewLifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.regisrCell()
        self.configureTableView()
        //self.configureTableData()
        if(CommonUtil.connected()) {
            self.webService()
        } else {
            CommonUtil.ShowALert(myTitle: AlertTitle, myMessage: ERROR_NO_INTERNET_CONNECTION)
        }
        
        //self.searchItunesFor("Facebook")
    }
    override func viewWillAppear(_ animated: Bool) {
        if pageTitle.isEmpty {
          self.title = "iTunes Store"
        } else {
            self.title = pageTitle
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WebService -
    func webService() {
    
        /*
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeIndeterminate;
        */
        let HUD:MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        HUD.labelText = "Loading..."
        
        let myURL = "https://itunes.apple.com/in/rss/topmovies/limit=5/genre=4401/json"
        let url = URL(string: myURL)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            print("Task Completed")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error != nil) {
                print(error!.localizedDescription)
            }
            let err:NSError?
            
            if let jsonResult = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                
                if(err != nil) {
                    print("JSON Error : \(err!.localizedDescription)")
                }
                //dump(jsonResult["feed"])
                //println(jsonResult["feed"])
                
                if let resultFeed:NSDictionary = jsonResult["feed"] as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.aryTableData = (resultFeed.object(forKey: "entry") as! NSArray) as! [Any] as! [String]
                        self.pageTitle = ((resultFeed.object(forKey: "author")! as AnyObject).object(forKey: "name") as AnyObject).object(forKey: "label") as! String
                        
                        self.tableHeaderTitle = (resultFeed.object(forKey: "title") as AnyObject).object(forKey: "label") as! String
                        self.tableFooterTitle = (resultFeed.object(forKey: "rights") as AnyObject).object(forKey: "label") as! String
                        
                        self.tblView.reloadData()
                        self.viewWillAppear(true)
                    })
                }
            }
        })
        task.resume()
    }

    //http://jamesonquave.com/blog/developing-ios-apps-using-swift-tutorial-part-2/
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = URL(string: urlPath)
            let session = URLSession.shared
            let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
                print("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    print(error!.localizedDescription)
                }
                let err: NSError?
                
                if  let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        print("JSON Error \(err!.localizedDescription)")
                    }
                    if let results: NSArray = jsonResult["results"] as? NSArray {
                        DispatchQueue.main.async(execute: {
                            self.aryTableData = results as! [Any] as! [String]
                            self.tblView!.reloadData()
                        })
                    }
                }
            })
                
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
    
    // MARK: - Configure Methods -
    func regisrCell() {
        self.tblView.register(UINib(nibName: "TextOnlyCell", bundle: Bundle.main), forCellReuseIdentifier: "TextOnlyCell")
        self.tblView.register(UINib(nibName: "TextAndImageCell", bundle: Bundle.main), forCellReuseIdentifier: "TextAndImageCell")
    }
    func configureTableView() {
        tblView.rowHeight = UITableViewAutomaticDimension
    }
    /*
    func configureTableData() {
        aryTableData.append(LoremIpsum.sentencesWithNumber(1))
        aryTableData.append(LoremIpsum.sentencesWithNumber(2))
        aryTableData.append(LoremIpsum.sentencesWithNumber(3))
        aryTableData.append(LoremIpsum.sentencesWithNumber(4))
        aryTableData.append(LoremIpsum.sentencesWithNumber(5))
        dump(aryTableData)
    }
    */
    
    // MARK: - UITableView Delegates -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: cellIdentifierTextAndImage, for: indexPath) as! TextAndImageCell
        
        let dicData = aryTableData[indexPath.row] as! NSDictionary
        let aryImg = dicData.object(forKey: "im:image") as! NSArray
        let imgURL = URL(string: (aryImg.object(at: 2) as AnyObject).value(forKey: "label") as! String)
        cell.imgCellDetail.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "Olympic-logo"))
        
        if let title = (dicData.object(forKey: "im:name") as AnyObject).object(forKey: "label") as? String {
            cell.lblTitle.text = "[\(indexPath.row + 1)] \(title)"
        }
        
        
        if let priceBuy = (dicData.object(forKey: "im:price")! as AnyObject).object(forKey: "label") as? String {
            if let rentBuy = (dicData.object(forKey: "im:rentalPrice") as AnyObject).object(forKey: "label") as? String {
                if let director = (dicData.object(forKey: "im:artist") as AnyObject).object(forKey: "label") as? String {
                    if let category = ((dicData.object(forKey: "category") as AnyObject).object(forKey: "attributes") as AnyObject).object(forKey: "label") as? String {
                        cell.lblDesc.text = "\(priceBuy) Buy HD\n" + "\(rentBuy) Rent HD\n" + "Director : \(director)\n" + "Category : \(category)"
                    } else {
                        cell.lblDesc.text = "\(priceBuy) Buy HD\n" + "\(rentBuy) Rent HD\n" + "Director : \(director)"
                    }
                } else {
                    cell.lblDesc.text = "\(priceBuy) Buy HD\n" + "\(rentBuy) Rent HD\n"
                }
            } else {
                cell.lblDesc.text = "\(priceBuy) Buy HD\n"
            }
        }
        
        return cell
    }
    
    // MARK: UITableView didSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    // MARK:  UITableView Height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    // MARK:  UITableView Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeaderTitle
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if UIView.isKind(of: UITableViewHeaderFooterView.self)
        {
            let headerTitle = UITableViewHeaderFooterView()
            headerTitle.textLabel!.text = headerTitle.textLabel?.text?.lowercased()
        }
    }
    
    // MARK:  UITableView Footer
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "© " + tableFooterTitle
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    

    /*
    // MARK: - Dynamic Height -
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.heightForAnchorFeedCellAtIndexPath(indexPath)
    }
    func heightForAnchorFeedCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        var sizingCell = self.tblView.dequeueReusableCellWithIdentifier(cellIdentifierTextAndImage) as! TextAndImageCell
        return self.calculateHeightForConfiguredSizingCell(sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        
        sizingCell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tblView.frame), CGRectGetHeight(sizingCell.bounds))
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        var size: CGSize = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height + 1.0
    }
*/
    
}
