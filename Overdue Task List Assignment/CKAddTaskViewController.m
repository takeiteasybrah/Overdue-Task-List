//
//  CKAddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import "CKAddTaskViewController.h"

@interface CKAddTaskViewController ()

@end

@implementation CKAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.taskDetailsTextView.delegate = self;
    self.taskNameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions
- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    CKTaskObject *newTaskObject = [self createTaskObject];
    [self.delegate didAddTask:newTaskObject];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}

#pragma mark - Helper Methods
-(CKTaskObject *)createTaskObject
{
    CKTaskObject *newTaskObject = [[CKTaskObject alloc] init];
    newTaskObject.title = self.taskNameTextField.text;
    newTaskObject.detail = self.taskDetailsTextView.text;
    newTaskObject.date  = self.taskDatePicker.date;
    newTaskObject.completion = NO;
    
    return newTaskObject;
}

#pragma mark - UITextViewDelgate method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.taskDetailsTextView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UITextFieldDelgate method

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//Remove keyboard if users touches background.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.taskDetailsTextView resignFirstResponder];
    [self.taskNameTextField resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

@end
