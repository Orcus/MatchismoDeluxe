//
//  PlayingCardView.m
//  Matchismo Deluxe
//
//  Created by Kevin Tong on 2/16/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

{} // hack to show following pragma mark
#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.80

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) {
        _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Pips

#define PIP_FONT_SCALE_FACTOR   0.20
#define PIP_HOFFSET_PERCENTAGE  0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    // center pip for 1, 3, 5, 9
    if ((self.rank == 1) || (self.rank == 3) ||
        (self.rank == 5) || (self.rank == 9)) {
            [self drawPipsWithHorizontalOffset:0
                                verticalOffset:0
                            mirroredVertically:NO];
    }
    // middle row of pips for 6, 7, 8
    if ((self.rank >= 6) && (self.rank <= 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    // middle column of pips for 2, 3, 7, 8, 10
    // Note: 7 only have one pip in the center column, so don't mirror
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) ||
        (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    // top and bottom row of pips for 4, 5, 6, 7, 8, 9, 10
    if ((self.rank >= 4) && (self.rank <= 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    // middle two rows of pips for 9, 10
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) {
        [self pushContextAndRotateUpsideDown];
    }

    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc]
                                          initWithString:self.suit
                                          attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2.0 - hoffset * self.bounds.size.width,
                                    middle.y - pipSize.height/2.0 - voffset * self.bounds.size.height);
    [attributedSuit drawAtPoint:pipOrigin];

    // there are 2 columns of pips if hoffset is not 0
    if (hoffset) {
        pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }

    if (upsideDown) {
        [self popContext];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];

    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

#pragma mark - Corners

#define CORNER_RADIUS 12.0
#define CORNER_INSET 2.0
#define CORNER_FONT_SCALE_FACTOR 0.2

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * CORNER_FONT_SCALE_FACTOR];

    NSAttributedString *cornerText = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%@\n%@",
                                                      [self rankAsString], self.suit]
                                      attributes:@{ NSParagraphStyleAttributeName : paragraphStyle,
                                                             NSFontAttributeName : cornerFont }];
    CGRect textBounds;
    textBounds.origin = CGPointMake(CORNER_INSET, CORNER_INSET);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];

    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

#pragma mark - Graphics

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:CORNER_RADIUS];
    [roundRect addClip];

    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);

    [[UIColor blackColor] setStroke];
    [roundRect stroke];

    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%d.png",
                                              [self suitSymbolAsString], self.rank]];

    if (self.faceUp) {
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (0.96 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }

        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"card-back.png"] drawInRect:self.bounds];
    }
}

- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Utility


- (NSString *)rankAsString
{
    static NSArray *rankStrings = nil;

    if (!rankStrings) {
        rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    }
    return rankStrings[self.rank];
}

- (NSString *)suitSymbolAsString
{
    static NSDictionary *suitProperty = nil;

    if (!suitProperty) {
        suitProperty = @{ @"♥": @"heart", @"♦": @"diamond", @"♠": @"spade", @"♣": @"club" };
    }

    return [suitProperty objectForKey:self.suit];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}

#pragma mark - Initialization

- (void)setup
{
    // do initialization
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
