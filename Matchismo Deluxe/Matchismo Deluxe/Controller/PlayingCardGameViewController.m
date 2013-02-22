//
//  PlayingCardGameViewController.m
//  Matchismo Deluxe
//
//  Created by Kevin Tong on 2/15/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

#define PLAYING_START_CARDS 22
#define PLAYING_MATCH_CARDS 2

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (NSUInteger) startingCardCount
{
    return PLAYING_START_CARDS;
}

- (NSUInteger) numberCardsToMatch
{
    return PLAYING_MATCH_CARDS;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
