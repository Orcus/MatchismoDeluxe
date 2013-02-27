//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Kevin on 1/28/13.
//  Copyright (c) 2013 Kevin Tong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardCount; // abstract
@property (nonatomic) NSUInteger numberCardsToMatch; // abstract
- (Deck *)createDeck; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
           animate:(BOOL) animate; // abstract

- (void)configureGameWithFlipCost:(NSUInteger) cost
      mismatchPenalty:(NSUInteger) penalty
           matchBonus:(NSUInteger) bonus;
@end
