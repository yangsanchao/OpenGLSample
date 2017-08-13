//
//  AGLViewController.m
//  triangle_2
//
//  Created by Yangsc on 2017/8/13.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "AGLViewController.h"


@interface AGLViewController ()

@property (nonatomic, strong) CADisplayLink *disPlaylink;

@end

static const NSInteger kAGLKDefaultFramesPerSecond = 30;

@implementation AGLViewController

- (void)setPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond {
    _preferredFramesPerSecond = preferredFramesPerSecond;
    _disPlaylink.preferredFramesPerSecond = MAX(1, 60 / preferredFramesPerSecond);
}

- (NSInteger)framesPerSecond {
    return (NSInteger)(60 / _preferredFramesPerSecond);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AGLKView *view = (AGLKView *)self.view;
    NSAssert([view isKindOfClass:[AGLKView class]],
             @"View controller's view is not a AGLKView");
    
    view.opaque = YES;
    view.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.paused = NO;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.paused = YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        _disPlaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
        _disPlaylink.preferredFramesPerSecond = kAGLKDefaultFramesPerSecond;
        _preferredFramesPerSecond = kAGLKDefaultFramesPerSecond;
        [_disPlaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.paused = NO;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _disPlaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
        _disPlaylink.preferredFramesPerSecond = kAGLKDefaultFramesPerSecond;
        _preferredFramesPerSecond = kAGLKDefaultFramesPerSecond;
        [_disPlaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}



- (void)drawView {
    [(AGLKView *)self.view display];
}


- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect {
    
}

@end
