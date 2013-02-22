//
//  SetCardView.h
//  Super Card
//
//  Created by Kevin Tong on 2/17/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;


@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic, getter = isHinted) BOOL hinted;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
