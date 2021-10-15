//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ngoc Hoang on 09/10/2021.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
//    var currentUser = NSDictionary()
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
//        loadUser()

        // Do any additional setup after loading the view.
//        let imageUrlStr = user["profile_image_url_https"] as! String
//        let imageUrlBigger = imageUrlStr.replacingOccurrences(of: "_normal", with: "_bigger")
//        let imageUrl = URL(string: imageUrlBigger)
//        let data = try? Data(contentsOf: imageUrl!)
//        if let imageData = data {
//            cell.profileImageView.image = UIImage(data: imageData)
//            // Source: https://www.appcoda.com/ios-programming-circular-image-calayer/
//            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
//            cell.profileImageView.clipsToBounds = true
//        }
//        print(currentUser)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                                                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
//    func loadUser() {
//        TwitterAPICaller.client?.getCurrentUser(success: { (user: NSDictionary) in
//            self.currentUser = user
//        }, failure: { Error in
//            print(Error)
//        })
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
