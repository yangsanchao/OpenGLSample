//
//  AGLKVertexAttribArrayBuffer.h
//  AGLKit
//
//  Created by Yangsc on 2017/8/15.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>

@interface AGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, assign, readonly) GLuint glName;

@property (nonatomic, assign, readonly) GLsizeiptr bufferSizeBytes;

@property (nonatomic, assign, readonly) GLsizeiptr stride;


- (instancetype)initWithAttribStride:(GLsizeiptr )stride 
                    numberOfVertices:(GLuint)count 
                                data:(const GLvoid *)dataPtr 
                               usage:(GLenum)usage;


- (void)prepareToDrawWithAttrib:(GLuint)index 
            numberOfCoordinates:(GLint)count 
                   attribOffset:(GLsizeiptr)offset 
                   shouldEnalbe:(BOOL)shouldEnalbe;

- (void)drawArrayWithMode:(GLenum)mode 
         startVertexIndex:(GLint)first 
         numberOfVertices:(GLsizei)count;


- (void)reInitWithAttribStride:(GLsizeiptr )stride 
              numberOfVertices:(GLuint)count 
                          data:(const GLvoid *)dataPtr;

@end
