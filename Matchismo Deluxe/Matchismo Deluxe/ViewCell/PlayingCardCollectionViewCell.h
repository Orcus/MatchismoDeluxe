//
//  PlayingCardCollectionViewCell.h
//  Matchismo Deluxe
//
//  Created by Kevin Tong on 2/21/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
