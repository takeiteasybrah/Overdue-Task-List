//
//  CKTaskObject.m
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import "CKTaskObject.h"

@implementation CKTaskObject

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.title = data[TITLE];
    self.detail = data[DETAIL];
    self.date = data[DATE];
    
    //Convert NSNumber object to BOOL
    NSNumber *boolNumber = data[COMPLETION];
    self.completion = [boolNumber boolValue];
    
    return self;
}

-(id)init
{
    self = [self initWithData:nil];
    
    return self;
}

@end
