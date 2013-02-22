//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Kevin on 1/28/13.
//  Copyright (c) 2013 Kevin Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic) NSUInteger startingCardCount; // abstract
@property (nonatomic) NSUInteger numberCardsToMatch; // abstract
- (Deck *)createDeck; // abstract

- (void)configureGameWithFlipCost:(NSUInteger) cost
      mismatchPenalty:(NSUInteger) penalty
           matchBonus:(NSUInteger) bonus;
@end
