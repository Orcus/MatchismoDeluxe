//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Kevin Tong on 2/9/13.
//  Copyright (c) 2013 Kevin Tong. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

#define SET_START_CARDS 12
#define SET_MATCH_CARDS 3
#define SET_COST 1
#define SET_PENALTY 2
#define SET_BONUS 6

@interface SetGameViewController()
@property (weak, nonatomic) IBOutlet UIButton *hintButton;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
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

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;

            // animate only if the card is freshly drawn
            if (animate && !setCard.isInPlay) {
                [UIView transitionWithView:setCardView
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionFlipFromBottom
                                animations:^{ setCard.inPlay = YES; }
                                completion:NULL];
            }            
            setCardView.symbol   = setCard.symbol;
            setCardView.number   = setCard.number;
            setCardView.shading  = setCard.shading;
            setCardView.color    = setCard.color;
            setCardView.hinted   = setCard.isHinted;
            setCardView.selected = setCard.isFaceUp;
            setCardView.inPlay   = setCard.isInPlay;
            setCardView.alpha    = setCard.isUnplayable ? 0.3 : 1.0;

            if (setCard.isUnplayable) {
                setCardView.selected = NO;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super configureGameWithFlipCost:SET_COST
                     mismatchPenalty:SET_PENALTY
                          matchBonus:SET_BONUS];
    // draw hint button with round corners
    self.hintButton.layer.borderColor  = [UIColor blackColor].CGColor;
    self.hintButton.layer.borderWidth  = 1.0;
    self.hintButton.layer.cornerRadius = 8.0;
}

@end
