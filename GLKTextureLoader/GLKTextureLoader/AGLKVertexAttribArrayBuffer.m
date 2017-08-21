//
//  AGLKVertexAttribArrayBuffer.m
//  AGLKit
//
//  Created by Yangsc on 2017/8/15.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLuint glName;

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;

@property (nonatomic, assign) GLsizeiptr stride;


@end

@implementation AGLKVertexAttribArrayBuffer

- (instancetype)initWithAttribStride:(GLsizeiptr )stride 
                    numberOfVertices:(GLuint)count 
                                data:(const GLvoid *)dataPtr 
                               usage:(GLenum)usage {

    if (self = [super init]) {
        _stride = stride;
        _bufferSizeBytes = count * stride;
        glGenBuffers(1, &_glName);
        glBindBuffer(GL_ARRAY_BUFFER, _glName);
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usage);
        
    }
    return self;
}


- (void)prepareToDrawWithAttrib:(GLuint)index 
            numberOfCoordinates:(GLint)count 
                   attribOffset:(GLsizeiptr)offset 
                   shouldEnalbe:(BOOL)shouldEnalbe {
    
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != _glName, @"Invalid _glName");
    
    glBindBuffer(GL_ARRAY_BUFFER, _glName);
    
    if (shouldEnalbe) {
        glEnableVertexAttribArray(index);
    }
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (GLsizei)self.stride, NULL + offset);

#ifdef DEBUG
    {  // Report any errors 
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

- (void)drawArrayWithMode:(GLenum)mode 
         startVertexIndex:(GLint)first 
         numberOfVertices:(GLsizei)count {
    NSAssert(self.bufferSizeBytes >= (first + count) * self.stride, @"Attempt to draw vertex data than avaiable!!");
    
    glDrawArrays(mode, first, count);
}


- (void)dealloc {
    if (0 != _glName) {
        glDeleteBuffers(1, &_glName);
        _glName = 0;
    }
}

@end
