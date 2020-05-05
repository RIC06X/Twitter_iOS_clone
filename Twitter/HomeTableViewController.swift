 //
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Yanjie Xu on 2020/4/25.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    @IBOutlet var tweetTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tweetTable.refreshControl = myRefreshControl
        self.tweetTable.rowHeight = UITableView.automaticDimension
        self.tweetTable.estimatedRowHeight = 150
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        numOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParam = ["count":numOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tweetTable.reloadData()
            self.myRefreshControl.endRefreshing()
            print("loading more")
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    func loadMoreTweet(){
        numOfTweet = numOfTweet + 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParam = ["count":numOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam as [String : Any], success: { (tweets: [NSDictionary]) in
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tweetTable.reloadData()
            self.myRefreshControl.endRefreshing()
            print("loading more")
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweet()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userloggedin")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
    
        cell.usernameLable.text = (user["name"] as! String)
        cell.tweetLable.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        //let data = try? Data(contentsOf: imageUrl!)
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool )
        cell.tweetID = tweetArray[indexPath.row]["id"] as! Int
        cell.profileImageView.af_setImage(withURL: imageUrl!)
        // Configure the cell...
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
