//
//  AGLKView.h
//  triangle_2
//
//  Created by Yangsc on 2017/8/13.
//  Copyright © 2017年 Yangsc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Enums for color buffer formats.
 */
typedef NS_ENUM(GLint, AGLKViewDrawableColorFormat)
{
    AGLKViewDrawableColorFormatRGBA8888 = 0,
    AGLKViewDrawableColorFormatRGB565,
    AGLKViewDrawableColorFormatSRGBA8888,
} NS_ENUM_AVAILABLE(10_8, 5_0);

/*
 Enums for depth buffer formats.
 */
typedef NS_ENUM(GLint, AGLKViewDrawableDepthFormat)
{
    AGLKViewDrawableDepthFormatNone = 0,
    AGLKViewDrawableDepthFormat16,
    AGLKViewDrawableDepthFormat24,
} NS_ENUM_AVAILABLE(10_8, 5_0);

/*
 Enums for stencil buffer formats.
 */
typedef NS_ENUM(GLint, AGLKViewDrawableStencilFormat)
{
    AGLKViewDrawableStencilFormatNone = 0,
    AGLKViewDrawableStencilFormat8,
} NS_ENUM_AVAILABLE(10_8, 5_0);

/*
 Enums for MSAA.
 */
typedef NS_ENUM(GLint, AGLKViewDrawableMultisample)
{
    AGLKViewDrawableMultisampleNone = 0,
    AGLKViewDrawableMultisample4X,
} NS_ENUM_AVAILABLE(10_8, 5_0);


#pragma mark -
#pragma mark AGLKViewDelegate
#pragma mark -

@class AGLKView;

@protocol AGLKViewDelegate <NSObject>

@required
/*
 Required method for implementing GLKViewDelegate. This draw method variant should be used when not subclassing GLKView.
 This method will not be called if the GLKView object has been subclassed and implements -(void)drawRect:(CGRect)rect.
 */
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end

@interface AGLKView : UIView

@property (nonatomic, weak)  id <AGLKViewDelegate> delegate;

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;

@property (nonatomic, assign) AGLKViewDrawableColorFormat drawableColorFormat;
@property (nonatomic, assign) AGLKViewDrawableDepthFormat drawableDepthFormat;
@property (nonatomic, assign) AGLKViewDrawableStencilFormat drawableStencilFormat;
@property (nonatomic, assign) AGLKViewDrawableMultisample drawableMultisample;

/*
 -display should be called when the view has been set to ignore calls to setNeedsDisplay. This method is used by
 the GLKViewController to invoke the draw method. It can also be used when not using a GLKViewController and custom
 control of the display loop is needed.
 */
- (void)display;

@end
