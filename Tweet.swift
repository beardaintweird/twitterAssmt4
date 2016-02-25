//
//  Tweet.swift
//  TwitterForeal
//
//  Created by Samee Khan on 2/18/16.
//  Copyright © 2016 Samee Khan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var finalTimeStamp: NSTimeInterval?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
    
        return tweets
    }
    
    func getProperTimeStamp() -> (String) {
        var minutes: Int?
        var seconds: Int?
        var hours: Int?
        var days: Int?
        
        let elapsedTime = NSDate().timeIntervalSinceDate(timestamp!)
        let convertedElapsedTime = Int(elapsedTime)
        var time: String = ""
        
        seconds = convertedElapsedTime
        
        if seconds < 60 {
            time = String(convertedElapsedTime)
        } else if seconds > 60 {
            minutes = seconds! / 60
            time = String(minutes)
        } else if minutes > 60 {
            hours = minutes! / 60
            time = String(hours)
        } else if hours > 24 {
            days = hours! / 24
            time = String(days)
        }
        
        return time
    }

}
