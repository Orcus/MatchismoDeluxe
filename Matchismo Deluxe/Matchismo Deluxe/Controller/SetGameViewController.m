//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Kevin Tong on 2/9/13.
//  Copyright (c) 2013 Kevin Tong. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"

#define SET_START_CARDS 12
#define SET_MATCH_CARDS 3
#define SET_COST 1
#define SET_PENALTY 2
#define SET_BONUS 6

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (NSUInteger) startingCardCount
{
    return SET_START_CARDS;
}

- (NSUInteger) numberCardsToMatch
{
    return SET_MATCH_CARDS;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super configureGameWithFlipCost:SET_COST
                     mismatchPenalty:SET_PENALTY
                          matchBonus:SET_BONUS];
}

@end
