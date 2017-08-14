//
//  ViewController.h
//  triangle_2
//
//  Created by Yangsc on 2017/8/13.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "AGLViewController.h"


@interface ViewController : AGLViewController

@property (nonatomic, strong)  GLKBaseEffect *baseEffect;

@property (nonatomic, assign) GLuint vertexBufferID;

@end

