//
//  ViewController.m
//  triangle
//
//  Created by Yangsc on 2017/8/8.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLContext.h"

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID 
                   value:(GLint)value;

@end


@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID 
                   value:(GLint)value {
    glBindTexture(self.target, self.name);
    glTexParameterf(self.target, parameterID, value);
    
}

@end



@interface ViewController () 

@property (nonatomic, strong)  GLKBaseEffect *baseEffect;

@property (nonatomic, assign) GLuint vertexBUfferID;

@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic, strong) GLKTextureInfo *textInfo;

@property (nonatomic, strong) GLKTextureInfo *textInfo2;

@end


typedef struct {
    GLKVector3 posionCoords;
    GLKVector2 textureCoords;
} Vertex; 

static Vertex vertexList[] = {
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupOpenGL];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self cleanOpenGL];
}



- (void)setupOpenGL {

    self.preferredFramesPerSecond = 60;

    GLKView *glkView = (GLKView *)self.view;
    if (![glkView isKindOfClass:[GLKView class]]) {
        NSAssert(1, @" glkView is not KindOfClass:GLKView!!");
    }
    
    glkView.context = [[AGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLContext setCurrentContext:glkView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    glClearColor(0.0f,0.0f,0.0f,0.0f);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft,nil];
    
    _vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(Vertex) numberOfVertices:sizeof(vertexList) / sizeof(Vertex) data:vertexList usage:GL_STATIC_DRAW];
    
    CGImageRef cgImage = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    
    _textInfo = [GLKTextureLoader textureWithCGImage:cgImage options:nil error:nil];
    
    
    CGImageRef cgImage2 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    
    _textInfo2 = [GLKTextureLoader textureWithCGImage:cgImage2 options:options error:nil];

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [(AGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    // offsetof，程序语言，该宏用于求结构体中一个成员在该结构体中的偏移量。
    [_vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(Vertex, posionCoords) shouldEnalbe:YES];
    
    [_vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(Vertex, textureCoords) shouldEnalbe:YES];
    
    
    [self.baseEffect prepareToDraw];
    self.baseEffect.texture2d0.name = _textInfo2.name;
    self.baseEffect.texture2d0.target = _textInfo2.target;
    [_vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertexList) / sizeof(Vertex)];
    
    
    [self.baseEffect prepareToDraw];
    self.baseEffect.texture2d0.name = _textInfo.name;
    self.baseEffect.texture2d0.target = _textInfo.target;
    [_vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertexList) / sizeof(Vertex)];
    
    
}


- (void)updateTextureParameters
{
    [self.baseEffect.texture2d0 
     aglkSetParameter:GL_TEXTURE_WRAP_S
     value:(GL_REPEAT)];
    
    [self.baseEffect.texture2d0 
     aglkSetParameter:GL_TEXTURE_MAG_FILTER
     value:(GL_NEAREST)];
}

- (void)update
{
    [self updateTextureParameters];
    [_vertexBuffer reInitWithAttribStride:sizeof(Vertex) numberOfVertices:sizeof(vertexList) / sizeof(Vertex) data:vertexList];
    
}


- (void)cleanOpenGL {
    // recode currentContext
    EAGLContext *currentContext = EAGLContext.currentContext;

    GLKView *glkView = (GLKView *)self.view;
    [EAGLContext setCurrentContext:glkView.context];
    
    if (_vertexBUfferID != 0) {
        _vertexBUfferID = 0;
    }
    
    if ((AGLContext *)glkView.context != nil) {
        glkView.context = nil;
    }
    // recover currentContext
    [EAGLContext setCurrentContext:currentContext];
    
}

@end
