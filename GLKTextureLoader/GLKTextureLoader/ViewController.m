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
#import "AGLKTextureLoader.h"

@interface ViewController () 

@property (nonatomic, strong)  GLKBaseEffect *baseEffect;

@property (nonatomic, assign) GLuint vertexBUfferID;

@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end


typedef struct {
    GLKVector3 posionCoords;
    GLKVector2 textureCoords;
} Vertex; 

static const Vertex vertexList[] = {
    {{-0.5,0.5,0.0}, {0.0f, 0.0f}},
    {{-0.5,-0.5,0.0},{1.0f, 0.0f}},
    {{0.5,-0.5,0.0}, {0.0f, 1.0f}}
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
    
    _vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(Vertex) numberOfVertices:sizeof(vertexList) / sizeof(Vertex) data:vertexList usage:GL_STATIC_DRAW];
    
    CGImageRef cgImage = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    
    AGLKTextureLoader *textInfo = [AGLKTextureLoader textureWithCGImage:cgImage options:nil error:nil];
    
    self.baseEffect.texture2d0.name = textInfo.name;
    self.baseEffect.texture2d0.target = textInfo.target;
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    [(AGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    // offsetof，程序语言，该宏用于求结构体中一个成员在该结构体中的偏移量。
    [_vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(Vertex, posionCoords) shouldEnalbe:YES];
    
    [_vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(Vertex, textureCoords) shouldEnalbe:YES];
    
    [_vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
    
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
