//
//  TOCropOverlayView.m
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOCropOverlayView.h"

static const CGFloat kTOCropOverLayerCornerWidth = 20.0f;
static const CGFloat kTOCropOverLayerBorderWidth = 4.0f;

@interface TOCropOverlayView ()

@property (nonatomic, strong) NSArray *horizontalGridLines;
@property (nonatomic, strong) NSArray *verticalGridLines;

@property (nonatomic, strong) NSArray *outerLineViews;   //top, right, bottom, left

@property (nonatomic, strong) NSArray *topLeftLineViews; //vertical, horizontal
@property (nonatomic, strong) NSArray *bottomLeftLineViews;
@property (nonatomic, strong) NSArray *bottomRightLineViews;
@property (nonatomic, strong) NSArray *topRightLineViews;

@property (nonatomic, strong) NSArray *topLineViews;
@property (nonatomic, strong) NSArray *bottomLineViews;
@property (nonatomic, strong) NSArray *leftLineViews;
@property (nonatomic, strong) NSArray *rightLineViews;


- (void)setup;
- (void)layoutLines;

@end

@implementation TOCropOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIView *(^newLineView)(void) = ^UIView *(void){
        return [self createNewLineView];
    };

    _outerLineViews     = @[newLineView(), newLineView(), newLineView(), newLineView()];
    
    
    _topLeftLineViews   = @[[self createNewRoundView]];
    _bottomLeftLineViews = @[[self createNewRoundView]];
    _topRightLineViews  = @[[self createNewRoundView]];
    _bottomRightLineViews = @[[self createNewRoundView]];
    
    _topLineViews   = @[[self createNewRoundView]];
    _bottomLineViews = @[[self createNewRoundView]];
    _rightLineViews  = @[[self createNewRoundView]];
    _leftLineViews = @[[self createNewRoundView]];
    
//    _topLeftLineViews   = @[newLineView(), newLineView()];
//    _bottomLeftLineViews = @[newLineView(), newLineView()];
//    _topRightLineViews  = @[newLineView(), newLineView()];
//    _bottomRightLineViews = @[newLineView(), newLineView()];
    
    self.displayHorizontalGridLines = YES;
    self.displayVerticalGridLines = YES;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_outerLineViews)
        [self layoutLines];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_outerLineViews)
        [self layoutLines];
}

- (void)layoutLines
{
    CGSize boundsSize = self.bounds.size;
    
    //border lines
    for (NSInteger i = 0; i < 4; i++) {
        UIView *lineView = self.outerLineViews[i];
        
        CGRect frame = CGRectZero;
        switch (i) {
            case 0: frame = (CGRect){0,-kTOCropOverLayerBorderWidth*0.5,boundsSize.width, kTOCropOverLayerBorderWidth}; break; //top
            case 1: frame = (CGRect){boundsSize.width-kTOCropOverLayerBorderWidth*0.5,0.0f,kTOCropOverLayerBorderWidth,boundsSize.height}; break; //right
            case 2: frame = (CGRect){0,boundsSize.height,boundsSize.width,kTOCropOverLayerBorderWidth}; break; //bottom
            case 3: frame = (CGRect){-kTOCropOverLayerBorderWidth*0.5,0,kTOCropOverLayerBorderWidth,boundsSize.height}; break; //left
        }
        
        lineView.frame = frame;
    }
    
    //corner liness
    NSArray *cornerLines = @[self.topLeftLineViews, self.topRightLineViews, self.bottomRightLineViews, self.bottomLeftLineViews,self.topLineViews, self.bottomLineViews, self.leftLineViews,self.rightLineViews];
    for (NSInteger i = 0; i < 8; i++) {
        NSArray *cornerLine = cornerLines[i];
        
        CGPoint origin = CGPointZero;
        switch (i) {
            case 0: //top left
                origin = CGPointMake(-kTOCropOverLayerCornerWidth*0.5, -kTOCropOverLayerCornerWidth*0.5);
                break;
            case 1: //top right
                origin = CGPointMake(boundsSize.width-kTOCropOverLayerCornerWidth*0.5, -kTOCropOverLayerCornerWidth*0.5);
                break;
            case 2: //bottom right
                origin = CGPointMake(boundsSize.width-kTOCropOverLayerCornerWidth*0.5, boundsSize.height-kTOCropOverLayerCornerWidth*0.5);
                break;
            case 3: //bottom left
                origin = CGPointMake(-kTOCropOverLayerCornerWidth*0.5, boundsSize.height-kTOCropOverLayerCornerWidth*0.5);
                break;
            case 4: //top
                origin = CGPointMake(boundsSize.width*0.5-kTOCropOverLayerCornerWidth*0.5, -kTOCropOverLayerCornerWidth*0.5);
                break;
            case 5: //bottom
                origin = CGPointMake(boundsSize.width*0.5-kTOCropOverLayerCornerWidth*0.5, boundsSize.height-kTOCropOverLayerCornerWidth*0.5);
                break;
            case 6: //left
                origin = CGPointMake(-kTOCropOverLayerCornerWidth*0.5, boundsSize.height*0.5-kTOCropOverLayerCornerWidth*0.5);
                break;
            case 7: //right
                origin = CGPointMake(boundsSize.width-kTOCropOverLayerCornerWidth*0.5, boundsSize.height*0.5-kTOCropOverLayerCornerWidth*0.5);
                break;
        }
        UIView *view = ((UIView *)cornerLine[0]);
        CGRect frame = view.frame;
        frame.origin = origin;
        view.frame = frame;
        
//        CGRect verticalFrame = CGRectZero, horizontalFrame = CGRectZero;
//        switch (i) {
//            case 0: //top left
//                verticalFrame = CGRectMake(0, 0, 10, 10);
//                //verticalFrame = (CGRect){-3.0f,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
//                horizontalFrame = (CGRect){0,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
//                break;
//            case 1: //top right
//                verticalFrame = (CGRect){boundsSize.width,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
//                horizontalFrame = (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
//                break;
//            case 2: //bottom right
//                verticalFrame = (CGRect){boundsSize.width,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth+3.0f};
//                horizontalFrame = (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,boundsSize.height,kTOCropOverLayerCornerWidth,3.0f};
//                break;
//            case 3: //bottom left
//                verticalFrame = (CGRect){-3.0f,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth};
//                horizontalFrame = (CGRect){-3.0f,boundsSize.height,kTOCropOverLayerCornerWidth+3.0f,3.0f};
//                break;
//        }
//        [cornerLine[0] setFrame:verticalFrame];
//        [cornerLine[1] setFrame:horizontalFrame];
        
        
    }
    
    //grid lines - horizontal
    CGFloat thickness = 1.0f / [[UIScreen mainScreen] scale];
    NSInteger numberOfLines = self.horizontalGridLines.count;
    CGFloat padding = (CGRectGetHeight(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
    for (NSInteger i = 0; i < numberOfLines; i++) {
        UIView *lineView = self.horizontalGridLines[i];
        CGRect frame = CGRectZero;
        frame.size.height = thickness;
        frame.size.width = CGRectGetWidth(self.bounds);
        frame.origin.y = (padding * (i+1)) + (thickness * i);
        lineView.frame = frame;
    }
    
    //grid lines - vertical
    numberOfLines = self.verticalGridLines.count;
    padding = (CGRectGetWidth(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
    for (NSInteger i = 0; i < numberOfLines; i++) {
        UIView *lineView = self.verticalGridLines[i];
        CGRect frame = CGRectZero;
        frame.size.width = thickness;
        frame.size.height = CGRectGetHeight(self.bounds);
        frame.origin.x = (padding * (i+1)) + (thickness * i);
        lineView.frame = frame;
    }
}

- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated
{
    _gridHidden = hidden;
    
    if (animated == NO) {
        for (UIView *lineView in self.horizontalGridLines) {
            lineView.alpha = hidden ? 0.0f : 1.0f;
        }
        
        for (UIView *lineView in self.verticalGridLines) {
            lineView.alpha = hidden ? 0.0f : 1.0f;
        }
    
        return;
    }
    
    [UIView animateWithDuration:hidden?0.35f:0.2f animations:^{
        for (UIView *lineView in self.horizontalGridLines)
            lineView.alpha = hidden ? 0.0f : 1.0f;
        
        for (UIView *lineView in self.verticalGridLines)
            lineView.alpha = hidden ? 0.0f : 1.0f;
    }];
}

#pragma mark - Property methods

- (void)setDisplayHorizontalGridLines:(BOOL)displayHorizontalGridLines {
    _displayHorizontalGridLines = displayHorizontalGridLines;
    
    [self.horizontalGridLines enumerateObjectsUsingBlock:^(UIView *__nonnull lineView, NSUInteger idx, BOOL * __nonnull stop) {
        [lineView removeFromSuperview];
    }];
    
    if (_displayHorizontalGridLines) {
        self.horizontalGridLines = @[[self createNewLineView], [self createNewLineView]];
    } else {
        self.horizontalGridLines = @[];
    }
    [self setNeedsDisplay];
}

- (void)setDisplayVerticalGridLines:(BOOL)displayVerticalGridLines {
    _displayVerticalGridLines = displayVerticalGridLines;
    
    [self.verticalGridLines enumerateObjectsUsingBlock:^(UIView *__nonnull lineView, NSUInteger idx, BOOL * __nonnull stop) {
        [lineView removeFromSuperview];
    }];
    
    if (_displayVerticalGridLines) {
        self.verticalGridLines = @[[self createNewLineView], [self createNewLineView]];
    } else {
        self.verticalGridLines = @[];
    }
    [self setNeedsDisplay];
}

- (void)setGridHidden:(BOOL)gridHidden
{
    [self setGridHidden:gridHidden animated:NO];
}

#pragma mark - Private methods

- (nonnull UIView *)createNewLineView {
    UIView *newLine = [[UIView alloc] initWithFrame:CGRectZero];
    newLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:newLine];
    return newLine;
}

- (nonnull UIView *)createNewRoundView {
    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTOCropOverLayerCornerWidth, kTOCropOverLayerCornerWidth)];
    roundView.layer.cornerRadius = kTOCropOverLayerCornerWidth*0.5;
    roundView.layer.masksToBounds = YES;
    roundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:roundView];
    return roundView;
}
@end
