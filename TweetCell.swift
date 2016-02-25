//
//  TweetCell.swift
//  TwitterForeal
//
//  Created by Samee Khan on 2/23/16.
//  Copyright © 2016 Samee Khan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var tweetTimeStamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    var user: User!
    
    var tweet: Tweet! {
        didSet {
            name.text = user.name as? String
            profilePic.setImageWithURL(user.profilePictureURL!)
            tweetText.text = tweet.text as? String
            tweetTimeStamp.text = tweet.getProperTimeStamp()
            twitterHandle.text = user.screenname as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
