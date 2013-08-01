//
//  ViewController.m
//  BasicOpenAL
//
//  Created by Con Eliopoulos on 1/08/13.
//  Copyright (c) 2013 Con Eliopoulos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _audioSamplePlayer = [[AudioSamplePlayer alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender
{
    [self.audioSamplePlayer playSound];
}
@end
