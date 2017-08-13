//
//  AGLViewController.h
//  triangle_2
//
//  Created by Yangsc on 2017/8/13.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGLKView.h"


@interface AGLViewController : UIViewController <AGLKViewDelegate>

@property (nonatomic, assign) NSInteger preferredFramesPerSecond;

@property (nonatomic, readonly) NSInteger framesPerSecond;

@property (nonatomic, getter=isPaused) BOOL paused;


@end
