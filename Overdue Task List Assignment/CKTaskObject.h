//
//  CKTaskObject.h
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTaskObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL completion;

-(id)initWithData:(NSDictionary *)data;

@end
