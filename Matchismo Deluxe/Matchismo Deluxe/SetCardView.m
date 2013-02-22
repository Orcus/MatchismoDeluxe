//
//  SetCardView.m
//  Super Card
//
//  Created by Kevin Tong on 2/17/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGFloat shapeScaleFactor;
@end

@implementation SetCardView

{} // hack to show following pragma mark
#pragma mark - Properties

#define SET_SYMBOL_DIAMOND  1
#define SET_SYMBOL_SQUIGGLE 2
#define SET_SYMBOL_OVAL     3
#define SET_NUMBER_ONE   1
#define SET_NUMBER_TWO   2
#define SET_NUMBER_THREE 3
#define SET_SHADING_SOLID   1
#define SET_SHADING_STRIPED 2
#define SET_SHADING_OPEN    3
#define SET_COLOR_RED    1
#define SET_COLOR_GREEN  2
#define SET_COLOR_PURPLE 3

#define DEFAULT_SHAPE_SCALE_FACTOR 1.0

@synthesize shapeScaleFactor = _shapeScaleFactor;

- (CGFloat)shapeScaleFactor
{
    if (!_shapeScaleFactor) {
        _shapeScaleFactor = DEFAULT_SHAPE_SCALE_FACTOR;
    }
    return _shapeScaleFactor;
}

- (void)setShapeScaleFactor:(CGFloat)shapeScaleFactor
{
    _shapeScaleFactor = shapeScaleFactor;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setHinted:(BOOL)hinted
{
    _hinted = hinted;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Graphics

#define CORNER_RADIUS 12.0
#define SELECTED_INSET 3.0
#define SELECTED_LIGHT_PERCENT 0.5

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:CORNER_RADIUS];
    [roundRect addClip];

    // draw background
    if (self.isHinted) {
        // light yellow
        [[UIColor colorWithRed:1.0 green:1.0 blue:SELECTED_LIGHT_PERCENT alpha:1.0] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    
    UIRectFill(self.bounds);

    // draw outline
    if (self.isSelected) {
        roundRect.lineWidth = 2 * SELECTED_INSET;
        [[UIColor blueColor] setStroke];
        [roundRect stroke];
    }
    
    [[UIColor blackColor] setStroke];
    roundRect.lineWidth = 1.0;
    [roundRect stroke];
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, self.shapeScaleFactor, self.shapeScaleFactor);

    [self drawSymbols];
}

#define SET_SHAPE_LINE_WIDTH 2.0

#define SET_SHAPE_HALF_WIDTH_PERCENT  0.0929
#define SET_SHAPE_HALF_HEIGHT_PERCENT 0.3

#define SET_HOFFSET2_PERCENT 0.1286
#define SET_HOFFSET3_PERCENT 0.2857

- (void)drawSymbols
{
    UIBezierPath *symbolPath = [self symbolPath];
    symbolPath.lineWidth = SET_SHAPE_LINE_WIDTH;
    [[self colorValue] setStroke];
    [self drawNumberWithPath:symbolPath];
}

- (void)drawNumberWithPath:(UIBezierPath *)path
{
    // draw middle symbol
    if (self.number == SET_NUMBER_ONE || self.number == SET_NUMBER_THREE) {
        [self drawShadingWithPath:path];
    }

    if (self.number == SET_NUMBER_TWO || self.number == SET_NUMBER_THREE) {
        CGFloat hoffset;

        hoffset = self.bounds.size.width * ((self.number == SET_NUMBER_TWO) ?
                                            SET_HOFFSET2_PERCENT : SET_HOFFSET3_PERCENT);
        // draw left symbol
        [self pushContextAndTranslateWithX:-hoffset y:0];
        [self drawShadingWithPath:path];
        [self popContext];
        // draw right symbol
        [self pushContextAndTranslateWithX:hoffset y:0];
        [self drawShadingWithPath:path];
        [self popContext];
    }
}

- (void)drawShadingWithPath:(UIBezierPath *)path
{
    [path stroke];

    if (self.shading == SET_SHADING_SOLID) {
        [[self colorValue] setFill];
        [path fill];
    } else if (self.shading == SET_SHADING_STRIPED) {
        UIBezierPath *strips = [self stripsPath];
        [self pushContext];
        [path addClip];
        [strips stroke];
        [self popContext];
    }
}

#define SET_SQUIG_POINT_Y_PERCENT 0.1111
#define SET_SQUIG_CONTROL_Y_PERCENT 0.3667
#define SET_SQUIG_CONTROL_MIN_X_PERCENT 0.0214
#define SET_SQUIG_CONTROL_MAX_X_PERCENT 0.1286

- (UIBezierPath *)squigglePath
{
    CGFloat cx = self.bounds.size.width / 2.0;
    CGFloat cy = self.bounds.size.height / 2.0;
    CGFloat halfWidth = self.bounds.size.width * SET_SHAPE_HALF_WIDTH_PERCENT;
    CGFloat pointY = self.bounds.size.height * SET_SQUIG_POINT_Y_PERCENT;
    CGFloat controlMaxY = self.bounds.size.height * SET_SQUIG_CONTROL_Y_PERCENT;
    CGFloat controlMinX = self.bounds.size.width * SET_SQUIG_CONTROL_MIN_X_PERCENT;
    CGFloat controlMaxX = self.bounds.size.width * SET_SQUIG_CONTROL_MAX_X_PERCENT;
    
    UIBezierPath *squiggle = [[UIBezierPath alloc] init];
    [squiggle moveToPoint:CGPointMake(cx - halfWidth, cy + pointY)];
    // left side "S" curve
    [squiggle addCurveToPoint:CGPointMake(cx - halfWidth, cy - pointY * 2)
                controlPoint1:CGPointMake(cx - halfWidth, cy)
                controlPoint2:CGPointMake(cx - controlMinX, cy)];
    // top curve
    [squiggle addCurveToPoint:CGPointMake(cx + halfWidth, cy - pointY)
                controlPoint1:CGPointMake(cx - controlMaxX, cy - controlMaxY)
                controlPoint2:CGPointMake(cx + halfWidth, cy - controlMaxY)];
    // right side "S" curve
    [squiggle addCurveToPoint:CGPointMake(cx + halfWidth, cy + pointY * 2)
                controlPoint1:CGPointMake(cx + halfWidth, cy)
                controlPoint2:CGPointMake(cx + controlMinX, cy)];
    // bottom curve
    [squiggle addCurveToPoint:CGPointMake(cx - halfWidth, cy + pointY)
                controlPoint1:CGPointMake(cx + controlMaxX, cy + controlMaxY)
                controlPoint2:CGPointMake(cx - halfWidth, cy + controlMaxY)];
    [squiggle closePath];
    return squiggle;
}

#define SET_OVAL_CONTROL_Y_PERCENT 0.3556

- (UIBezierPath *)ovalPath
{
    CGFloat cx = self.bounds.size.width / 2.0;
    CGFloat cy = self.bounds.size.height / 2.0;
    CGFloat halfWidth = self.bounds.size.width * SET_SHAPE_HALF_WIDTH_PERCENT;
    CGFloat halfHeight = self.bounds.size.height * SET_SHAPE_HALF_HEIGHT_PERCENT;
    CGFloat pointY = halfHeight / 2.0;
    CGFloat controlY = self.bounds.size.height * SET_OVAL_CONTROL_Y_PERCENT;
        
    UIBezierPath *oval = [[UIBezierPath alloc] init];

    [oval moveToPoint:CGPointMake(cx - halfWidth, cy + pointY)];
    // left side line
    [oval addLineToPoint:CGPointMake(cx - halfWidth, cy - pointY)];
    // top curve
    [oval addCurveToPoint:CGPointMake(cx + halfWidth, cy - pointY)
                controlPoint1:CGPointMake(cx - halfWidth, cy - controlY)
                controlPoint2:CGPointMake(cx + halfWidth, cy - controlY)];
    // right side line
    [oval addLineToPoint:CGPointMake(cx + halfWidth, cy + pointY)];
    // bottom curve
    [oval addCurveToPoint:CGPointMake(cx - halfWidth, cy + pointY)
            controlPoint1:CGPointMake(cx + halfWidth, cy + controlY)
            controlPoint2:CGPointMake(cx - halfWidth, cy + controlY)];
    [oval closePath];
    return oval;
}

- (UIBezierPath *)diamondPath
{
    CGFloat cx = self.bounds.size.width / 2.0;
    CGFloat cy = self.bounds.size.height / 2.0;
    CGFloat halfWidth = self.bounds.size.width * SET_SHAPE_HALF_WIDTH_PERCENT;
    CGFloat halfHeight = self.bounds.size.height * SET_SHAPE_HALF_HEIGHT_PERCENT;

    UIBezierPath *diamond = [[UIBezierPath alloc] init];
    [diamond moveToPoint:CGPointMake(cx - halfWidth, cy)];
    // top left diagonal
    [diamond addLineToPoint:CGPointMake(cx, cy - halfHeight)];
    // top right diagonal
    [diamond addLineToPoint:CGPointMake(cx + halfWidth, cy)];
    // bottom right diagonal
    [diamond addLineToPoint:CGPointMake(cx, cy + halfHeight)];
    [diamond closePath];
    return diamond;
}

#define SET_SHADING_STRIPED_DY 4.0

- (UIBezierPath *)stripsPath
{
    CGFloat cx = self.bounds.size.width / 2.0;
    CGFloat cy = self.bounds.size.height / 2.0;
    CGFloat halfWidth = self.bounds.size.width * SET_SHAPE_HALF_WIDTH_PERCENT;
    CGFloat halfHeight = self.bounds.size.height * SET_SHAPE_HALF_HEIGHT_PERCENT;

    CGFloat left  = cx - halfWidth;
    CGFloat right = cx + halfWidth;
    CGFloat top = cy - halfHeight;
    CGFloat bottom = cy + halfHeight;

    UIBezierPath *strips = [[UIBezierPath alloc] init];

    for (CGFloat y = top; y <= bottom; y += SET_SHADING_STRIPED_DY) {
        [strips moveToPoint:CGPointMake(left, y)];
        [strips addLineToPoint:CGPointMake(right, y)];
    }
    return strips;
}

- (void)pushContextAndTranslateWithX:(CGFloat)dx y:(CGFloat) dy
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, dx, dy);
}

- (void)pushContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Utilities

- (UIColor *)colorValue
{
    UIColor *color;
    
    switch (self.color) {
        case SET_COLOR_RED:
            color = [UIColor redColor];
            break;
        case SET_COLOR_GREEN:
            color = [UIColor greenColor];
            break;
        case SET_COLOR_PURPLE:
            color = [UIColor purpleColor];
            break;
        default:
            color = [UIColor grayColor];
            break;
    }
    return color;
}

- (UIBezierPath *)symbolPath
{
    UIBezierPath *symbol;

    switch (self.symbol) {
        case SET_SYMBOL_DIAMOND:
            symbol = [self diamondPath];
            break;
        case SET_SYMBOL_SQUIGGLE:
            symbol = [self squigglePath];
            break;
        case SET_SYMBOL_OVAL:
            symbol = [self ovalPath];
            break;
        default:
            break;
    }
    return symbol;
}

#pragma mark - Gestures

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.shapeScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}
@end
