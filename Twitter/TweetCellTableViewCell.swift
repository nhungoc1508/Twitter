//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Ngoc Hoang on 02/10/2021.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetId:Int = -1
    
    var likes:Int = 0
    var retweets:Int = 0
    
    func setLikeCount(_ count:Int) {
        likes = count
        if likes == 0 {
            likeCount.text = " "
        } else {
            likeCount.text = String(likes)
        }
    }
    
    func setRetweetCount(_ count:Int) {
        retweets = count
        if retweets == 0 {
            retweetCount.text = " "
        } else {
            retweetCount.text = String(retweets)
        }
    }
    
    func setFavorited(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func favTweet(_ sender: Any) {
        let tobeFavorited = !favorited
        if (tobeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
                self.setLikeCount(self.likes + 1)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(false)
                self.setLikeCount(self.likes - 1)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        let tobeRetweeted = !retweeted
        if (tobeRetweeted) {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(true)
                self.setRetweetCount(self.retweets + 1)
            }, failure: { (error) in
                print("Retweet did not succeed: \(error)")
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
