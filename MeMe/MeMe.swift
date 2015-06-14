//
//  MeMe.swift
//  MeMe
//
//  Created by Andreas Pfister on 12/06/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import UIKit

struct MeMe {
    
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var meMeImage : UIImage
    
    init (topText : String, bottomText : String, originalImage : UIImage, meMeImage : UIImage){
        self.bottomText = bottomText
        self.topText = topText
        self.originalImage = originalImage
        self.meMeImage = meMeImage
    }
    
}