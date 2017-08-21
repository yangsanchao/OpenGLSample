//
//  GLKTextureLoader.h
//  GLKTextureLoader
//
//  Created by Yangsc on 2017/8/21.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLkit.h>

@interface AGLKTextureLoader : NSObject

@property (nonatomic, assign, readonly) GLuint name;
@property (nonatomic, assign, readonly) GLuint target;
@property (nonatomic, assign, readonly) GLuint width;
@property (nonatomic, assign, readonly) GLuint height;

+ (AGLKTextureLoader *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary *)options error:(NSError *)outError;

@end
