//
//  HelperClass.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/10/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "HelperClass.h"
#import "SurveyQuestion.h"
#import "RequestWrapper.h"
#import "Reachability.h"
#import "AppDelegate.h"

static NSMutableArray *_surveyQuestionsArray;
static NSMutableData *_responseData;
static NSString *_surveyLanguage;
static id<SurveyQuestionReadyProtocol> _listener;
static NSString *_surveyId;

@implementation HelperClass

+ (NSArray*) getSurveyQuestions
{
	return  _surveyQuestionsArray;
}

+ (NSString*) getSurveyLanguage
{
    return _surveyLanguage;
}

+ (NSString*) getSurveyId
{
    return _surveyId;
}

+ (NSString*) surveyLanguageAbbreviation
{
    NSString* langAbb = @"en";
    
    if ([_surveyLanguage isEqualToString:@"English"]) {
        langAbb = @"en";
    } else if ([_surveyLanguage isEqualToString:@"Arabic"]){
        langAbb = @"ar";
    }
    
    return langAbb;
}

+ (void)initSurveyQuestionsWithListener:(id<SurveyQuestionReadyProtocol>)listener AndLanguage:(NSString*)surveyLanguage {
	
	_listener = listener;
	_responseData = [[NSMutableData alloc] init];
    _surveyLanguage = surveyLanguage;
    
	[self getSurveyQuestionsList];
}

+ (void) updateSurveysList {
	NSURL *url = [NSURL URLWithString:[kSurveysWebServiceGet stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	//Create GET HTTP Method Request
	[request setHTTPMethod:@"GET"];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

+ (void)getSurveyQuestionsList {
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    [HelperClass copyFileToDocuments:@"SurveyQuestionsList.plist"];
    [HelperClass copyFileToDocuments:@"Utilities.plist"];
    
    NSString *surveyQuestionsPlistPath = [homeDir stringByAppendingPathComponent:@"SurveyQuestionsList.plist"];
    
    NSMutableData *surveysData = [NSMutableData dataWithContentsOfFile:surveyQuestionsPlistPath];
    
    BOOL forceSyncSurvey = ((AppDelegate*)[UIApplication sharedApplication].delegate).synchronizeSurvey;
    
    if(surveysData.length < 50 || forceSyncSurvey)
    {
        [self updateSurveysList];
    }
    else
    {
        _responseData = surveysData;
        [self connectionDidFinishLoading:nil];
    }
    
}

+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

+ (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *error = nil;
	NSArray *_jsonArray = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
	
	NSString *surveyId = @"-1";
	
	_surveyQuestionsArray = [[NSMutableArray alloc] init];
	
	if (error != nil) {
		NSLog(@"Error parsing JSON.");
	}
	else {
		NSLog(@"Array: %@", _jsonArray);
		
		for (NSDictionary *questionDict in _jsonArray) {
			NSString *questionId = [questionDict objectForKey:@"Id"];
			NSString *questionText = [questionDict objectForKey:@"Question__c"];
            NSString *questionTextArabic = [questionDict objectForKey:@"Question_Arabic__c"];
			NSString *choicesString = [questionDict objectForKey:@"Choices__c"];
            NSString *choicesStringArabic = [questionDict objectForKey:@"Choices_Arabic__c"];
			NSString *questionTypeString = [questionDict objectForKey:@"Type__c"];
			BOOL isRequired = (BOOL)[[questionDict objectForKey:@"Required__c"] integerValue];
			NSString *questionSurveyId = [questionDict objectForKey:@"Survey__c"];
			surveyId = questionSurveyId;
            _surveyId = surveyId;
			
			NSArray *questionOptions = [choicesString componentsSeparatedByString:@"\r\n"];
            NSArray *questionOptionsArabic = [choicesStringArabic componentsSeparatedByString:@"\r\n"];
			
			QuestionType questionType = SingleSelect;
			if ([questionTypeString rangeOfString:@"Single Select"].location != NSNotFound)
				questionType = SingleSelect;
			else if ([questionTypeString rangeOfString:@"Free Text"].location != NSNotFound)
				questionType = Text;
            
            SurveyQuestion *tempQuestion = [[SurveyQuestion alloc] initWithId:questionId QuestionText:questionText QuestionTextArabic:questionTextArabic Type:questionType Options:questionOptions OptionsArabic:questionOptionsArabic Required:isRequired SurveyId:questionSurveyId];
			
			[_surveyQuestionsArray addObject:tempQuestion];
		}
	}
	
	if(connection != nil)
	{
		NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		
		NSString *surveyQuestionsPlistPath = [homeDir stringByAppendingPathComponent:@"SurveyQuestionsList.plist"];
		
		NSString *utilitiesPlistPath = [homeDir stringByAppendingPathComponent:@"Utilities.plist"];
		NSMutableDictionary *utilitiesDictionary = [NSMutableDictionary dictionaryWithContentsOfFile: utilitiesPlistPath];
		
		[utilitiesDictionary setValue:[NSDate date] forKey:@"Survey_Last_Sync_Date"];
		[utilitiesDictionary setValue:surveyId forKeyPath:@"Synced_Survey_Id"];
		[utilitiesDictionary writeToFile:utilitiesPlistPath atomically:YES];
		
		[_responseData writeToFile:surveyQuestionsPlistPath atomically:YES];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEEE, MMMM dd yyyy, hh:mm a"];//Sunday, April 6 2014, 1:50 PM
		NSString *str_date = [dateFormat stringFromDate:[NSDate date]];
		
		[[NSUserDefaults standardUserDefaults] setObject:str_date forKey:@"survey_last_sync_date_preference"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	[_listener surveyQuestionsReady];
	
}

+ (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"error - read error object for details");
	
	_surveyQuestionsArray = [[NSMutableArray alloc] init];
	
	[_listener surveyQuestionsSyncNoInternetFound];
}

+ (void)submitSurvey:(RequestWrapper*) requestWrapper
{
	NSURL *url = [NSURL URLWithString:kSurveysWebServicePost];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	//Create POST HTTP Method Request
	[request setHTTPMethod:@"POST"];
	
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:[requestWrapper getWrapperToConvertToJSON] forKey:@"requestWrapper"]	options:0 error:&error];
	
	[request setHTTPBody:jsonData];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:nil];
}

+ (void)copyFileToDocuments:(NSString*) fileName
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:fileName];
    
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) {
        NSLog(@"file found in Documents folder");
        return;
    }
    else {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        NSLog(@"file not found in Documents folder.\nCopied to documents folder.");
    }
}

@end
