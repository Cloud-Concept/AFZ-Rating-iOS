//
//  HomeScreenViewController.m
//  AFZ Rating
//
//  Created by Mina Zaklama on 11/4/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "ThankYouViewController.h"
#import "RequestWrapper.h"
#import "SurveyQuestion.h"
#import "AppDelegate.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeAndStartActivityIndicatorSpinner];
    [HelperClass initSurveyQuestionsWithListener:self AndLanguage:@"English"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)answerButtonClicked:(id)sender {
    [self submitRatingSurvey:((UIButton*)sender).tag];
}

- (void)submitRatingSurvey:(NSInteger)buttonIndex {
    
    SurveyQuestion *surveyQuestion = [[HelperClass getSurveyQuestions] objectAtIndex:0];
    
    NSString *answer = [surveyQuestion.questionOptionsArray objectAtIndex:buttonIndex];
    NSString *answerColor = [surveyQuestion.questionOptionsColorArray objectAtIndex:buttonIndex];
    //NSString *answerWeight = [surveyQuestion.questionOptionsWeightArray objectAtIndex:buttonIndex];
    NSString *answerWeight = @"5";
    
    NSDictionary *answerDict = [[NSDictionary alloc] initWithObjects:@[surveyQuestion.questionId, answer, answerColor, answerWeight] forKeys:@[@"Survey_Question__c", @"Response__c", @"Response_Color__c", @"Response_Weight__c"]];
    
    //Adding answer to temp request wrapper before submit.
    RequestWrapper *tempRequestWrapper = [[RequestWrapper alloc] init];
    [tempRequestWrapper.surveyQuestionResponseList addObject:answerDict];
    
    [tempRequestWrapper.surveyTaker setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).surveyOwner forKey:@"Survey_Owner__c"];
    [tempRequestWrapper.surveyTaker setValue:[HelperClass getSurveyId] forKey:@"Survey__c"];
    [tempRequestWrapper.surveyTaker setValue:@"iPad Survey" forKey:@"Process_Type__c"];
    
    [HelperClass submitSurvey:tempRequestWrapper];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ThankYouViewController *thankYouView = [storyBoard instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
    
    [self.navigationController pushViewController:thankYouView animated:YES];
}

- (void)initializeAndStartActivityIndicatorSpinner
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.loadingView setHidden:NO];
}

- (void)stopActivityIndicatorSpinner
{
    [self.loadingView setHidden:YES];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark SurveyQuestionReadyProtocol
- (void)surveyQuestionsReady
{
    [self stopActivityIndicatorSpinner];
    
    if ([[HelperClass getSurveyQuestions] count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"no_questions_error_title", nil) message:NSLocalizedString(@"no_questions_error_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    self.questionTextView.text = ((SurveyQuestion*)[[HelperClass getSurveyQuestions] objectAtIndex:0]).questionText;
    self.questionArabicTextView.text = ((SurveyQuestion*)[[HelperClass getSurveyQuestions] objectAtIndex:0]).questionTextArabic;
    
    [self.questionTextView setEditable:NO];
    [self.questionTextView setSelectable:NO];
    
    [self.questionArabicTextView setEditable:NO];
    [self.questionArabicTextView setSelectable:NO];
}

- (void) surveyQuestionsSyncNoInternetFound {
    [self stopActivityIndicatorSpinner];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error contacting server, please check your internet connection" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
    [alert show];
}

@end
