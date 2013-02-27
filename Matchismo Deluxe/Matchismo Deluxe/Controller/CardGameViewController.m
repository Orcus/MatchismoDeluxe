//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kevin on 1/28/13.
//  Copyright (c) 2013 Kevin Tong. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

#define PLAYER_TURN_LABEL_BORDER_SIZE 4.0
#define POPUP_BUTTON_YES 1
#define TWO_PLAYERS_SEGMENT_CONTROL_INDEX 1

@interface CardGameViewController () <UIAlertViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *score1Label;
@property (weak, nonatomic) IBOutlet UILabel *score2Label;
@property (weak, nonatomic) IBOutlet UILabel *playerTurnLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *playerCountSegControl;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) BOOL isTwoPlayers;
@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    //return self.startingCardCount;
    return [self.game cardsInPlay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
           animate:(BOOL)animate
{
    //abstract
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]
                                              isMultiplayer:self.isTwoPlayers];
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
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
    self.score1Label.text = [NSString stringWithFormat:@" P1 Score: %d", self.game.score1];
    self.score2Label.text = [NSString stringWithFormat:@"P2 Score: %d", self.game.score2];

    if (self.game.isMultiplayer) {
        if (self.game.isPlayer2Turn) {
            self.playerTurnLabel.text = @"Player 2 Turn";
            self.playerTurnLabel.textColor = [UIColor blueColor];
            self.playerTurnLabel.layer.borderColor = [UIColor blueColor].CGColor;
        } else {
            self.playerTurnLabel.text = @"Player 1 Turn";
            self.playerTurnLabel.textColor = [UIColor redColor];
            self.playerTurnLabel.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
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
    if (buttonIndex == POPUP_BUTTON_YES) {
        // start a new game
        self.game = nil;
        self.playerCountSegControl.enabled = YES;
        [self updateUI];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (IBAction)changePlayerCount:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == TWO_PLAYERS_SEGMENT_CONTROL_INDEX) {
        self.isTwoPlayers = YES;
        self.score2Label.hidden = NO;
    } else {
        self.isTwoPlayers = NO;
        self.score2Label.hidden = YES;
    }

    self.game = nil;
    [self updateUI];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }
    self.playerCountSegControl.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerTurnLabel.layer.borderWidth = PLAYER_TURN_LABEL_BORDER_SIZE;
    self.playerTurnLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.score2Label.hidden = YES;
}

@end
