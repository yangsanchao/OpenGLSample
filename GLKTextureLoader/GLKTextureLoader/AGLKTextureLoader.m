//
//  GLKTextureLoader.m
//  GLKTextureLoader
//
//  Created by Yangsc on 2017/8/21.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "AGLKTextureLoader.h"

/////////////////////////////////////////////////////////////////
// This data type is used specify power of 2 values.  OpenGL ES 
// best supports texture images that have power of 2 dimensions.
typedef enum
{
    AGLK1 = 1,
    AGLK2 = 2,
    AGLK4 = 4,
    AGLK8 = 8,
    AGLK16 = 16,
    AGLK32 = 32,
    AGLK64 = 64,
    AGLK128 = 128,
    AGLK256 = 256,
    AGLK512 = 512,
    AGLK1024 = 1024,
} 
AGLKPowerOf2;



@interface AGLKTextureLoader ()

@property (nonatomic, assign) GLuint name;
@property (nonatomic, assign) GLuint target;
@property (nonatomic, assign) GLuint width;
@property (nonatomic, assign) GLuint height;

@end

@implementation AGLKTextureLoader

+ (AGLKTextureLoader *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary *)options error:(NSError *)outError  {

    GLsizei width = (GLsizei)CGImageGetWidth(cgImage);
    GLsizei height = (GLsizei)CGImageGetHeight(cgImage);
    
    NSMutableData *mutableData = [[NSMutableData alloc] initWithLength:width * height * sizeof(GLsizei)];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef cgcontext = CGBitmapContextCreate([mutableData mutableBytes],
                                                   width, height,
                                                   8, 
                                                   4 * width, 
                                                   colorSpaceRef,
                                                   kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextTranslateCTM(cgcontext, 1.0, -1.0);
    
    CGContextDrawImage(cgcontext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgcontext);
    NSData *imageData = [NSData dataWithData:mutableData];
   
    GLuint textureBufferID;
    glGenTextures(1, &textureBufferID);
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
    glTexImage2D(GL_TEXTURE_2D, 
                 0, 
                 GL_RGBA, 
                 width, 
                 height, 
                 0, 
                 GL_RGBA, 
                 GL_UNSIGNED_BYTE, 
                 [imageData bytes]
                 );


    glTexParameteri(GL_TEXTURE_2D, 
                    GL_TEXTURE_MIN_FILTER, 
                    GL_LINEAR); 
   
    
    AGLKTextureLoader *textureload = [[AGLKTextureLoader alloc] initWithName:textureBufferID target:GL_TEXTURE_2D width:width height:height];
    
    return textureload;
}

- (instancetype)initWithName:(GLuint)name target:(GLuint)target width:(GLuint)width height:(GLuint)height {

    if (self = [super init]) {
        _name = name;
        _target = target;
        _width = width;
        _height = height;
    }
    return self;
}
@end
