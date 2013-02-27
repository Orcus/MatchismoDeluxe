//
//  PlayingCardGameViewController.m
//  Matchismo Deluxe
//
//  Created by Kevin Tong on 2/15/13.
//  Copyright (c) 2013 Orcus Maximus. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

#define PLAYING_STARTING_CARDS 22
#define PLAYING_MATCH_CARDS 2

@interface PlayingCardGameViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startingCardTextField;
@end

@implementation PlayingCardGameViewController

- (NSUInteger) startingCardCount
{
    return [self.startingCardTextField.text intValue];
;
}

- (NSUInteger) numberCardsToMatch
{
    return PLAYING_MATCH_CARDS;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;

            if (animate && playingCardView.isFaceUp != playingCard.isFaceUp) {
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:playingCardView.isFaceUp ?
                                        UIViewAnimationOptionTransitionFlipFromRight :
                                        UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{}
                                completion:NULL];
            }
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.faceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

// dismiss when user touches anywhere outside number pad
- (void)touchesEnded: (NSSet *)touches
           withEvent: (UIEvent *)event
{
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]]) {
			[view resignFirstResponder];
        }
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.startingCardTextField.text = [@(PLAYING_STARTING_CARDS) description];
    self.startingCardTextField.text = [NSString stringWithFormat:@"%d", PLAYING_STARTING_CARDS];
    self.startingCardTextField.inputAccessoryView = [self createNumberPadHelperToolbar];
}

-(UIToolbar *)createNumberPadHelperToolbar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc] init];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
       [[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                       style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(cancelNumberPad)],
       [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil action:nil],
       [[UIBarButtonItem alloc]initWithTitle:@"Enter 5 to 52"
                                       style:UIBarButtonItemStylePlain
                                      target:nil action:nil],
       [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil action:nil],
       [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(void)cancelNumberPad{
    [self.startingCardTextField resignFirstResponder];
}

-(void)doneWithNumberPad{
    [self.startingCardTextField resignFirstResponder];
}

@end
