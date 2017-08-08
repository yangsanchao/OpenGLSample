//
//  ViewController.m
//  triangle
//
//  Created by Yangsc on 2017/8/8.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 

@property (nonatomic, strong)  GLKBaseEffect *baseEffect;

@property (nonatomic, assign) GLuint vertexBUfferID;

@end


typedef struct {
    GLKVector3 posionCoords;
} Vertex; 

static const Vertex vertexList[] = {
    {{-0.5,0.5,0.0}},
    {{-0.5,-0.5,0.0}},
    {{0.5,-0.5,0.0}}
};

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupOpenGL];
}


- (void)setupOpenGL {

    GLKView *glkView = (GLKView *)self.view;
    if (![glkView isKindOfClass:[GLKView class]]) {
        NSAssert(1, @" glkView is not KindOfClass:GLKView!!");
    }
    
    glkView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glkView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    glClearColor(0.0f,0.0f,0.0f,0.0f);
    
    glGenBuffers(1, &_vertexBUfferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBUfferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexList), vertexList, GL_STATIC_DRAW);
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
