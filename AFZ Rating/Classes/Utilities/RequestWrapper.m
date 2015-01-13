//
//  RequestWrapper.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 1/30/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "RequestWrapper.h"

@implementation RequestWrapper

- (id) init
{
	if (!(self = [super init]))
		return nil;
	
	_surveyTaker = [[NSMutableDictionary alloc] init];
	_surveyQuestionResponseList = [[NSMutableArray alloc] init];
	
	return self;
}

- (id) initWithRequestWrapper:(RequestWrapper *) request
{
	if (!(self = [super init]))
		return nil;
	
	self.surveyTaker = [[NSMutableDictionary alloc] initWithDictionary:request.surveyTaker];
	self.surveyQuestionResponseList = [[NSMutableArray alloc] initWithArray:request.surveyQuestionResponseList copyItems:YES];
	
	return self;
}

- (NSDictionary *) getWrapperToConvertToJSON
{
	return [NSDictionary dictionaryWithObjectsAndKeys:self.surveyTaker, @"surveyTaker", self.surveyQuestionResponseList, @"SurveyQuestionResponseList", self.licenseNumber, @"LicenseNumber", nil];
}

@end
