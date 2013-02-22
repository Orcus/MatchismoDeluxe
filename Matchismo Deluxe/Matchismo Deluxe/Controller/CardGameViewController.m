//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kevin on 1/28/13.
//  Copyright (c) 2013 Kevin Tong. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
        _game.cardsToMatch = self.numberCardsToMatch;
    }
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}

- (void)configureGameWithFlipCost:(NSUInteger) cost
      mismatchPenalty:(NSUInteger) penalty
           matchBonus:(NSUInteger) bonus
{
    self.game.flipCost = cost;
    self.game.mismatchPenalty = penalty;
    self.game.matchBonus = bonus;
}

- (void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d Points ", self.game.score];
}

- (IBAction)deal:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Start a New Game?"
                          message:@"Current game and score will reset!"
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // start a new game
        self.game = nil;
        [self updateUI];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (IBAction)flipCard:(UIButton *)sender
{
    int index = 0;
    [self.game flipCardAtIndex:index];
    [self updateUI];
}

@end
