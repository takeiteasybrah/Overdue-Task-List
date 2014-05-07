//
//  CKEditTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTaskObject.h"

@protocol CKEditTaskViewControllerDelegate <NSObject>

-(void)updateTaskObject:(CKTaskObject *)taskObject;

@end

@interface CKEditTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

- (IBAction)saveBarButtonItemPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDetailsTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskDatePicker;

@property (strong, nonatomic) CKTaskObject *taskObject;

@property (strong, nonatomic) id <CKEditTaskViewControllerDelegate> delegate;


@end
