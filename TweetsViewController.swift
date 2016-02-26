//
//  TweetsViewController.swift
//  TwitterForeal
//
//  Created by Samee Khan on 2/22/16.
//  Copyright © 2016 Samee Khan. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        TwitterClient.sharedInstance.rateLimit()
                // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Tweet Cell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets![indexPath.row]
        
        cell.tweet = tweet
 
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
