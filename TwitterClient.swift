//
//  TwitterClient.swift
//  TwitterForeal
//
//  Created by Samee Khan on 2/20/16.
//  Copyright © 2016 Samee Khan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "DbJIoPmuKsrXfd7mRqldVDpOW", consumerSecret: "xD5AtI9Ou0uwiVnGc2YYofX464MQ3FyufLVLaoqXXVTQV6beh5")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "beardstwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("got access token")
            
            self.currentUser({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
            }) { (error: NSError!) -> Void in
                print("error \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func homeTimeline(  success: ([Tweet]) -> (), failure: (NSError) -> ()    ) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
//            print(Tweet.tweetsWithArray(dictionaries))
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
                
        })
    }
    
    func currentUser(success: (User) -> (), failure: (NSError) -> ()    ) {
        GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
//            user.dictionary = userDictionary
//            self.userDictionaryForTransport = user.dictionary
            
            
//            print(userDictionary)
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
                
        })
    }
    
    func rateLimit() -> (){
        GET("1.1/application/rate_limit_status.json?", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            print(dictionary)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
            })
    }

    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
}
