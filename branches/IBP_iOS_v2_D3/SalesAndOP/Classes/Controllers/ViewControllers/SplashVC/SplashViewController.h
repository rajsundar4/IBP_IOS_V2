//
//  SplashViewController.h
//  SalesAndOP
//
//  Created by Mayur Birari on 03/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

/*!
 \internal
 @class SplashViewController
 @abstract This view controller is used for Splash.
 @discussion Splash screen will display for 5 seconds, and Animation will handle
             in this view controller, we integrated video file to show the animation.
 */
@interface SplashViewController : UIViewController

/// Player object to represent for playing Splash Video
@property (nonatomic, strong) MPMoviePlayerController* moviePlayerController;

@end
