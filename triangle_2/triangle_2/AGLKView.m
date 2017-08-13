//
//  AGLKView.m
//  triangle_2
//
//  Created by Yangsc on 2017/8/13.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "AGLKView.h"
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>

@interface AGLKView ()

@property (nonatomic, assign) NSInteger drawableWidth;
@property (nonatomic, assign) NSInteger drawableHeight;

@property (nonatomic, strong) CAEAGLLayer *eagllayer;

@property (nonatomic, assign) GLuint defaultFrameBuffer;
@property (nonatomic, assign) GLuint colorRenderBUffer;
@property (nonatomic, assign) GLuint depthRenderBuffer;
@end


@implementation AGLKView

@synthesize context = _context;

- (NSInteger)drawableWidth {
    GLint width;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    return (NSInteger)width;
}

- (NSInteger)drawableHeight {
    GLint height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &height);
    return (NSInteger)height;
}


- (void)setContext:(EAGLContext *)context {
    if (context != _context) {
        [EAGLContext setCurrentContext:context];
        if (_defaultFrameBuffer != 0) {
            glDeleteFramebuffers(1, &_defaultFrameBuffer);
            _defaultFrameBuffer = 0;
        }
        if (_colorRenderBUffer != 0) {
            glDeleteRenderbuffers(1, &_colorRenderBUffer);
            _colorRenderBUffer = 0;
        }
        
        if (0 != _depthRenderBuffer)
        {
            glDeleteRenderbuffers(1, &_depthRenderBuffer); // Step 7
            _depthRenderBuffer = 0;
        }
    }
    _context = context;
    
    if (nil != _context) {
        [EAGLContext setCurrentContext:_context];

        glGenRenderbuffers(1, &_defaultFrameBuffer);
        glBindBuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
        
        glGenRenderbuffers(1, &_colorRenderBUffer);
        glBindBuffer(GL_RENDERBUFFER, _colorRenderBUffer);
        
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_FRAMEBUFFER, _colorRenderBUffer);
    
        // Create any additional render buffers based on the
        // drawable size of defaultFrameBuffer
        [self layoutSubviews];
    }
}

- (EAGLContext *)context {
    return _context;
}

// return CAEAGLLayer
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _eagllayer = (CAEAGLLayer *)self.layer;
        _eagllayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:NO],
                                         kEAGLDrawablePropertyRetainedBacking,
                                         kEAGLColorFormatRGBA8,
                                         kEAGLDrawablePropertyColorFormat,                         
                                         nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        _eagllayer = (CAEAGLLayer *)self.layer;
        _eagllayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:NO],
                                         kEAGLDrawablePropertyRetainedBacking,
                                         kEAGLColorFormatRGBA8,
                                         kEAGLDrawablePropertyColorFormat,                         
                                         nil];  
    }
    return self;
}



- (void)display {
    EAGLContext *oldEAGLContext = EAGLContext.currentContext;
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, (GLint)_drawableWidth, (GLint)_drawableHeight);
    [self drawRect:self.bounds];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    if (oldEAGLContext != _context) {
        [EAGLContext setCurrentContext:oldEAGLContext];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    // Make sure our context is current
    [EAGLContext setCurrentContext:self.context];
    
    // Initialize the current Frame Buffer’s pixel color buffer 
    // so that it shares the corresponding Core Animation Layer’s
    // pixel color storage.
    [self.context renderbufferStorage:GL_RENDERBUFFER 
                         fromDrawable:eaglLayer];
    
    
    if (0 != _depthRenderBuffer)
    {
        glDeleteRenderbuffers(1, &_depthRenderBuffer); // Step 7
        _depthRenderBuffer = 0;
    }
    
    GLint currentDrawableWidth = (GLint)self.drawableWidth;
    GLint currentDrawableHeight = (GLint)self.drawableHeight;
    
    if(self.drawableDepthFormat != 
       AGLKViewDrawableDepthFormatNone &&
       0 < currentDrawableWidth &&
       0 < currentDrawableHeight)
    {
        glGenRenderbuffers(1, &_depthRenderBuffer); // Step 1
        glBindRenderbuffer(GL_RENDERBUFFER,        // Step 2
                           _depthRenderBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER,     // Step 3 
                              GL_DEPTH_COMPONENT16, 
                              currentDrawableWidth, 
                              currentDrawableHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER,  // Step 4 
                                  GL_DEPTH_ATTACHMENT, 
                                  GL_RENDERBUFFER, 
                                  _depthRenderBuffer);
    }
    
    // Check for any errors configuring the render buffer   
    GLenum status = glCheckFramebufferStatus(
                                             GL_FRAMEBUFFER) ;
    
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x", status);
    }
    
    // Make the Color Render Buffer the current buffer for display
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBUffer);

//    
//    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eagllayer];
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBUffer);
//    GLenum status = glCheckFramebufferStatus(_colorRenderBUffer);
//    if (status != GL_FRAMEBUFFER_COMPLETE) {
//        NSLog(@" Error status %x",status);
//    }
    
}

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:rect];
    }
}


- (void)dealloc {
    if (_context) {
        EAGLContext *oldEAGLContext = EAGLContext.currentContext;
        [EAGLContext setCurrentContext:_context];
        if (oldEAGLContext != _context) {
            glFinish();
            [EAGLContext setCurrentContext:oldEAGLContext];
        }
    }
    _context = nil;
}

@end



