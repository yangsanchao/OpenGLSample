//
//  AGLKContext.m
//  AGLKit
//
//  Created by Yangsc on 2017/8/15.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "AGLContext.h"

@implementation AGLContext

@synthesize clearColor = _clearColor;

- (void)setClearColor:(GLKVector4)clearColor {
    _clearColor = clearColor;
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (GLKVector4)clearColor {
    return _clearColor;
}

- (void)clear:(GLbitfield )mask {
    glClear(mask);
}


@end
