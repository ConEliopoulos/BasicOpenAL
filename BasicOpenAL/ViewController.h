//
//  ViewController.h
//  BasicOpenAL
//
//  Created by Con Eliopoulos on 1/08/13.
//  Copyright (c) 2013 Con Eliopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioSamplePlayer.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) AudioSamplePlayer *audioSamplePlayer;

- (IBAction)play:(id)sender;

@end
