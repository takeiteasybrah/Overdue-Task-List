//
//  CKAddTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTaskObject.h"

@protocol CKAddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(CKTaskObject *)task;

@end
@interface CKAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDetailsTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskDatePicker;

@property (weak, nonatomic) id <CKAddTaskViewControllerDelegate> delegate;

@end
