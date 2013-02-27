//
//  PlayingCardView.h
//  Matchismo Deluxe
//
//  Created by Kevin Tong on 2/16/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
