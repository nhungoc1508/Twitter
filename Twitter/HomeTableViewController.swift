//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ngoc Hoang on 02/10/2021.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetsArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    var currentUser = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ADDITIONAL UI MODIFICATIONS
        tableView.rowHeight = 130
        
        // loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
        self.loadUser()
    }
    
    @objc func loadTweets(){
        numberOfTweets = 10
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
//            print("Could not retrieve tweets!")
            print(Error)
        })
    }
    
    func loadMoreTweets() {
        numberOfTweets = numberOfTweets + 10
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
//            print(Error)
        })
    }
    
    func loadUser() {
        TwitterAPICaller.client?.getCurrentUser(success: { (user: NSDictionary) in
            self.currentUser = user
        }, failure: { Error in
            print(Error)
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetsArray.count {
            loadMoreTweets()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetsArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetsArray[indexPath.row]["text"] as? String
        
        let handle = user["screen_name"] as! String
        let handleLabel = "@" + handle
        cell.handleLabel.text = handleLabel
        
        let favorited = tweetsArray[indexPath.row]["favorited"] as! Bool
        cell.setFavorited(favorited)
        
        let tweetId = tweetsArray[indexPath.row]["id"] as! Int
        cell.tweetId = tweetId
        
        let retweeted = tweetsArray[indexPath.row]["retweeted"] as! Bool
        cell.setRetweeted(retweeted)
        
        let likeCount = tweetsArray[indexPath.row]["favorite_count"] as! Int
        cell.setLikeCount(likeCount)

        let retweetCount = tweetsArray[indexPath.row]["retweet_count"] as! Int
        cell.setRetweetCount(retweetCount)
        
        let imageUrlStr = user["profile_image_url_https"] as! String
        let imageUrlBigger = imageUrlStr.replacingOccurrences(of: "_normal", with: "_bigger")
        let imageUrl = URL(string: imageUrlBigger)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
            // Source: https://www.appcoda.com/ios-programming-circular-image-calayer/
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
            cell.profileImageView.clipsToBounds = true
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
