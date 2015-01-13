//
//  SurveyQuestion.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/11/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "SurveyQuestion.h"

@implementation SurveyQuestion

- (id) initWithId:(NSString*)Id QuestionText:(NSString*)text QuestionTextArabic:(NSString*)textArabic Type:(QuestionType)type Options:(NSArray*)options OptionsArabic:(NSArray*)optionsArabic Required:(BOOL)required SurveyId:(NSString*) surveyId
{
	if (!(self = [super init]))
		return nil;
	
	self.questionId = Id;
	self.questionText = text;
    self.questionTextArabic = textArabic;
	
	NSMutableArray *optionsMutableArray = [[NSMutableArray alloc] init];
	NSMutableArray *optionsWeightMutableArray = [[NSMutableArray alloc] init];
	NSMutableArray *optionsColorMutableArray = [[NSMutableArray alloc] init];
	
	for (NSString *option in options) {
		NSArray *chunks = [option componentsSeparatedByString: @"|"];
		
		[optionsMutableArray addObject:[chunks objectAtIndex:0]];
		
		if([chunks count] > 1) {
			[optionsWeightMutableArray addObject:[chunks objectAtIndex:1]];
			[optionsColorMutableArray addObject:[chunks objectAtIndex:2]];
		}
	}
	self.questionOptionsArray = [[NSArray alloc] initWithArray:optionsMutableArray];// options;
	self.questionOptionsWeightArray = [[NSArray alloc] initWithArray:optionsWeightMutableArray];
	self.questionOptionsColorArray = [[NSArray alloc] initWithArray:optionsColorMutableArray];
	
    self.questionOptionsArrayArabic = optionsArabic;
    
	self.questionType = type;
	self.isRequired = required;
	self.questionSurveyId = surveyId;
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	SurveyQuestion *copy = [[[self class] allocWithZone:zone] init];
	copy.questionId = [_questionId copyWithZone:zone];
	copy.questionText = [_questionText copyWithZone:zone];
	copy.questionOptionsArray = [_questionOptionsArray copyWithZone:zone];
	copy.questionType = _questionType;
	copy.isRequired = _isRequired;
	
	return copy;
}

@end
