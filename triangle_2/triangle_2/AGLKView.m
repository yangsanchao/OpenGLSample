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
@property (nonatomic, assign) GLuint colorRenderBuffer;
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
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    return (NSInteger)height;
}


- (void)setContext:(EAGLContext *)context {

    if (context != _context) {
        [EAGLContext setCurrentContext:context];
        if (_defaultFrameBuffer != 0) {
            glDeleteFramebuffers(1, &_defaultFrameBuffer);
            _defaultFrameBuffer = 0;
        }
        if (_colorRenderBuffer != 0) {
            glDeleteRenderbuffers(1, &_colorRenderBuffer);
            _colorRenderBuffer = 0;
        }
        
        if (0 != _depthRenderBuffer) {
            glDeleteRenderbuffers(1, &_depthRenderBuffer); // Step 7
            _depthRenderBuffer = 0;
        }
        
        _context = context;
        
        if (nil != _context) {
            _context = context;
            [EAGLContext setCurrentContext:_context];
            
            glGenFramebuffers(1, &_defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
            
            glGenRenderbuffers(1, &_colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
            
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
        }
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
    [EAGLContext setCurrentContext:_context];
    glViewport(0, 0, (GLint)self.drawableWidth, (GLint)self.drawableHeight);
    [self drawRect:self.bounds];
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    if (oldEAGLContext != _context) {
        [EAGLContext setCurrentContext:oldEAGLContext];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
        
    [EAGLContext setCurrentContext:_context];
    [self.context renderbufferStorage:GL_RENDERBUFFER 
                         fromDrawable:_eagllayer];
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@" Error status %x",status);
    }
    // Make the Color Render Buffer the current buffer for display
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
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



