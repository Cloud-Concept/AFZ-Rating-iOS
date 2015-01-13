//
//  HomeScreenViewController.h
//  AFZ Rating
//
//  Created by Mina Zaklama on 11/4/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"

@interface HomeScreenViewController : UIViewController <SurveyQuestionReadyProtocol>

@property (strong, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) IBOutlet UITextView *questionArabicTextView;

@property (strong, nonatomic) IBOutlet UIView *loadingView;


- (IBAction)answerButtonClicked:(id)sender;

@end
