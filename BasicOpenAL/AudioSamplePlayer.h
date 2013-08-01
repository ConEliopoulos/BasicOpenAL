//
//  AudioSamplePlayer.h
//  BasicOpenAL
//
//  Created by Con Eliopoulos on 1/08/13.
//  Copyright (c) 2013 Con Eliopoulos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>

@interface AudioSamplePlayer : NSObject

- (void) playSound;

@end
