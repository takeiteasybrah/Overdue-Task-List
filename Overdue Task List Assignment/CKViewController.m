//
//  CKViewController.m
//  Overdue Task List Assignment
//
//  Created by Devin Medeiros on 5/2/14.
//  Copyright (c) 2014 Cutie Killer Apps. All rights reserved.
//

#import "CKViewController.h"
#import "CKDetailTaskViewController.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *arrayOfDictionaryTaskObjects = [[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_FROM_NSUSERDEFAULTS];
    for (NSDictionary *dictionary in arrayOfDictionaryTaskObjects) {
        //CKTaskObject *taskObject = [self taskObjectFromDictionary:dictionary];
        CKTaskObject *taskObject = [[CKTaskObject alloc] initWithData:dictionary];
        [self.taskObjects addObject:taskObject];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"Testing when viewDidLoad gets called");
}

-(void)viewWillAppear:(BOOL)animated
{
    //Reload tableview everytime view appears.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (self.tableView.isEditing) {
        self.reorderBarButtonItem.title = @"Reorder";
        [self.tableView setEditing:NO animated:YES];
    } else {
        self.reorderBarButtonItem.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)addTaskBarButtonItemPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CKAddTaskViewController class]]) {
        CKAddTaskViewController *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    }
    if ([sender isKindOfClass:[NSIndexPath class]] && [segue.destinationViewController isKindOfClass:[CKDetailTaskViewController class]]) {
        
        NSIndexPath *path = sender;
        CKTaskObject *taskObject = self.taskObjects[path.row];
        
        CKDetailTaskViewController *detailTaskVC = segue.destinationViewController;
        detailTaskVC.taskObject = taskObject;
        detailTaskVC.path = path;

    }
}

#pragma mark - Lazy instantiation
-(NSMutableArray *)taskObjects
{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    
    return _taskObjects;
}

#pragma mark - Helper methods
-(NSDictionary *)taskObjectAsAPropertyList:(CKTaskObject *)taskObject
{
    NSDictionary *taskObjectAsADictionary = @{TITLE : taskObject.title, DETAIL : taskObject.detail, DATE : taskObject.date, COMPLETION : @(taskObject.completion)};
    
    return taskObjectAsADictionary;
}

-(CKTaskObject *)taskObjectFromDictionary:(NSDictionary *)dictionary
{
    CKTaskObject *taskObject = [[CKTaskObject alloc] initWithData:dictionary];
    
    return taskObject;
}

-(BOOL)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate
{
    int timeIntervaldate = [date timeIntervalSince1970];
    int timeIntervalToDate = [toDate timeIntervalSince1970];
    
    if (timeIntervaldate > timeIntervalToDate) {
        return YES;
    } else {
        return NO;
    }
}

-(void)updateCompletionOfTask:(CKTaskObject *)task forIndexPath:(NSIndexPath *)indexPath
{
    //Change the task completion to YES and convert the task to a dictionary object
    task.completion = !task.completion;
    NSDictionary *taskAsDictionary = [self taskObjectAsAPropertyList:task];
    
    //Get the NSMutableArray from NSUserdefaults and remove the dictionary at the selected row.
    NSMutableArray *arrayFromNSUserDefaults = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_FROM_NSUSERDEFAULTS] mutableCopy];
    [arrayFromNSUserDefaults removeObjectAtIndex:indexPath.row];
    
    //Add the updated dictionary back into the MSMutableArray
    [arrayFromNSUserDefaults insertObject:taskAsDictionary atIndex:indexPath.row];
    
    //Save the MSMutableArray back to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:arrayFromNSUserDefaults forKey:ARRAY_FROM_NSUSERDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - CKAddTaskViewController delegate methods
-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)didAddTask:(CKTaskObject *)task
{
    [self.taskObjects addObject:task];
    
    NSMutableArray *arraryFromNSUserDefault = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_FROM_NSUSERDEFAULTS] mutableCopy];
    if (!arraryFromNSUserDefault) {
        arraryFromNSUserDefault = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *dictionaryFromTaskObject = [self taskObjectAsAPropertyList:task];
    [arraryFromNSUserDefault addObject:dictionaryFromTaskObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:arraryFromNSUserDefault forKey:ARRAY_FROM_NSUSERDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskObjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CKTaskObject *taskObject = self.taskObjects[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:taskObject.date];
    
    cell.textLabel.text = taskObject.title;
    cell.detailTextLabel.text = stringFromDate;
    
    if (taskObject.completion) {
        cell.backgroundColor = [UIColor greenColor];
    }
    else if ([self isDateGreaterThanDate:taskObject.date and:[NSDate date]]) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CKTaskObject *taskObject = self.taskObjects[indexPath.row];
    
    [self updateCompletionOfTask:taskObject forIndexPath:indexPath];
    
    [tableView reloadData];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.taskObjects removeObjectAtIndex:indexPath.row];
    
    //Get the NSMutableArray from NSUserdefaults and remove the dictionary at the selected row.
    NSMutableArray *arrayFromNSUserDefaults = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_FROM_NSUSERDEFAULTS] mutableCopy];
    [arrayFromNSUserDefaults removeObjectAtIndex:indexPath.row];
    
    //Save the MSMutableArray back to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:arrayFromNSUserDefaults forKey:ARRAY_FROM_NSUSERDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView reloadData];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This removes the delete icon from appearing when clicking the reorder button.
    if(self.tableView.isEditing) {
        return UITableViewCellEditingStyleNone;
    }else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This stops the row from indenting when clicking the reorder button.
    return NO;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    CKTaskObject *taskObject = self.taskObjects[sourceIndexPath.row];
    
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    
    NSDictionary *dictionaryFromTaskObject = [self taskObjectAsAPropertyList:taskObject];
    NSMutableArray *arrayFromNSUserDefaults = [[[NSUserDefaults standardUserDefaults] arrayForKey:ARRAY_FROM_NSUSERDEFAULTS] mutableCopy];
    [arrayFromNSUserDefaults removeObjectAtIndex:sourceIndexPath.row];
    [arrayFromNSUserDefaults insertObject:dictionaryFromTaskObject atIndex:destinationIndexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:arrayFromNSUserDefaults forKey:ARRAY_FROM_NSUSERDEFAULTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
