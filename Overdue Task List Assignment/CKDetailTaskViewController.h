//
//  CKDetailTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTaskObject.h"
#import "CKEditTaskViewController.h"

@interface CKDetailTaskViewController : UIViewController <CKEditTaskViewControllerDelegate>

- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailsLabel;


@property (strong, nonatomic) CKTaskObject *taskObject;
@property (strong, nonatomic) NSIndexPath *path;

@end
