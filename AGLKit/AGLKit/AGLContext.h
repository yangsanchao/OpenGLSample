//
//  AGLKContext.h
//  AGLKit
//
//  Created by Yangsc on 2017/8/15.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLContext : EAGLContext

@property (nonatomic, assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield )mask;

@end
