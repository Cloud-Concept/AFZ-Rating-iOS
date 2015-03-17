//
//  HelperClass.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/10/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <Foundation/Foundation.h>
/* Production
#define kSurveysWebServiceGet @"https://afza.secure.force.com/AFZSurveysServices/services/apexrest/surveys_webservice?SurveyName=Mobile Rating Survey"
#define kSurveysWebServicePost @"https://afza.secure.force.com/AFZSurveysServices/services/apexrest/surveys_webservice"
//*/

//* Sandbox
#define kSurveysWebServiceGet @"https://mobileapp-afza.cs8.force.com/AFZSurveysServices/services/apexrest/surveys_webservice?SurveyName=Mobile Rating Survey"
 #define kSurveysWebServicePost @"https://mobileapp-afza.cs8.force.com/AFZSurveysServices/services/apexrest/surveys_webservice"
//*/
@class RequestWrapper;

@protocol SurveyQuestionReadyProtocol <NSObject>
- (void) surveyQuestionsReady;
- (void) surveyQuestionsSyncNoInternetFound;
@end

@interface HelperClass : NSObject

+ (NSArray*) getSurveyQuestions;
+ (NSString*) getSurveyLanguage;
+ (NSString*) getSurveyId;
+ (NSString*) surveyLanguageAbbreviation;
+ (void)initSurveyQuestionsWithListener:(id<SurveyQuestionReadyProtocol>)listener AndLanguage:(NSString*)surveyLanguage;
+ (void)submitSurvey:(RequestWrapper*) requestWrapper;
+ (void)copyFileToDocuments:(NSString*) fileName;

@end