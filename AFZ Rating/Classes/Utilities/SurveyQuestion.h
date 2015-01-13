//
//  SurveyQuestion.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/11/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyQuestion : NSObject <NSCopying>

typedef enum {
    Text,
	SingleSelect
} QuestionType;

@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong) NSString *questionTextArabic;
@property (nonatomic, strong) NSArray *questionOptionsArray;
@property (nonatomic, strong) NSArray *questionOptionsArrayArabic;
@property (nonatomic, strong) NSArray *questionOptionsColorArray;
@property (nonatomic, strong) NSArray *questionOptionsWeightArray;
@property (nonatomic) QuestionType questionType;
@property (nonatomic) BOOL isRequired;
@property (nonatomic, strong) NSString *questionSurveyId;

- (id) initWithId:(NSString*)Id QuestionText:(NSString*)text QuestionTextArabic:(NSString*)textArabic Type:(QuestionType)type Options:(NSArray*)options OptionsArabic:(NSArray*)optionsArabic Required:(BOOL)required SurveyId:(NSString*) surveyId;

@end
