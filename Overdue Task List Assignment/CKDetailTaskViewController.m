//
//  CKDetailTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import "CKDetailTaskViewController.h"

@interface CKDetailTaskViewController ()

@end

@implementation CKDetailTaskViewController

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
    
    [self updateLabels];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //Resizes taskDetailsLabel to fit its text.  This simulates the text being vertically alligned.
    [self.taskDetailsLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIBarButtonItem class]] && [segue.destinationViewController isKindOfClass:[CKEditTaskViewController class]]) {
        CKEditTaskViewController *editTaskVC = segue.destinationViewController;
        editTaskVC.taskObject = self.taskObject;
        editTaskVC.delegate = self;
    }
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

#pragma mark - Helper method
//Update UILabels using the taskObject property.
-(void)updateLabels
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:self.taskObject.date];
    
    self.taskTitleLabel.text = self.taskObject.title;
    self.taskDateLabel.text = stringFromDate;
    self.taskDetailsLabel.text = self.taskObject.detail;
}

//Convert taskObject to a dictionary
-(NSDictionary *)taskObjectAsAPropertyList:(CKTaskObject *)taskObject
{
    NSNumber *boolNumber = [NSNumber numberWithBool:taskObject.completion];
    
    NSDictionary *taskObjectAsADictionary = @{TITLE : taskObject.title, DETAIL : taskObject.detail, DATE : taskObject.date, COMPLETION : boolNumber};
    
    return taskObjectAsADictionary;
}

#pragma mark - IBActions
- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toEditTaskViewControllerSegue" sender:sender];
}

#pragma mark - CKEditTaskViewController delgate
-(void)updateTaskObject:(CKTaskObject *)taskObject
{
    self.taskObject = taskObject;
    NSDictionary *dictionaryFromTaskObject = [self taskObjectAsAPropertyList:taskObject];
    
    [self updateLabels];
    
    NSMutableArray *arrayFromNSUserDefaults = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_FROM_NSUSERDEFAULTS] mutableCopy];
    [arrayFromNSUserDefaults replaceObjectAtIndex:self.path.row withObject:dictionaryFromTaskObject];
    [[NSUserDefaults standardUserDefaults] setObject:arrayFromNSUserDefaults forKey:ARRAY_FROM_NSUSERDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
