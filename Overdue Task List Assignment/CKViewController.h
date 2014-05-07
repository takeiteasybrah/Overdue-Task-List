//
//  CKViewController.h
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKAddTaskViewController.h"

@interface CKViewController : UIViewController <CKAddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)addTaskBarButtonItemPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reorderBarButtonItem;

//tableView model.
@property (strong, nonatomic) NSMutableArray *taskObjects;

@end
