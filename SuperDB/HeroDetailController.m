//
//  HeroDetailController.m
//  SuperDB
//
//  Created by Serhii K on 6/29/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import "HeroDetailController.h"
#import "SuperDBEditCell.h"

@interface HeroDetailController ()

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

- (void)save;
- (void)cancel;

@end

//static NSString *cellIdentifier = @"SuperDBEditCell";

@implementation HeroDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.saveButton = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                       target:self
                       action:@selector(save)];
    
    self.backButton = self.navigationItem.leftBarButtonItem;
    self.cancelButton = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                         target:self
                         action:@selector(cancel)];
    
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"HeroDetailConfiguration"
                                              withExtension:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    self.sections = [plist valueForKey:@"sections"];
    NSAssert(self.sections != nil, @"Sections shouldn't be nil");
    
//    [self.tableView registerClass:SuperDBEditCell.class forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [self.sections count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSDictionary *sections = [self.sections objectAtIndex:section];
//    NSArray *rows = [sections objectForKey:@"rows"];
//    return [rows count];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionIndex = [indexPath section];
    NSInteger rowIndex = [indexPath row];
    
    NSDictionary *section = [self.sections objectAtIndex:sectionIndex];
    NSArray *rows = [section objectForKey:@"rows"];
    NSDictionary *row = [rows objectAtIndex:rowIndex];
    
    NSString *cellClassString = [row valueForKey:@"class"];

    SuperDBEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassString];
    
    if (!cell) {
        Class cellClass = NSClassFromString(cellClassString);
        cell = [[cellClass alloc]
                initWithStyle:UITableViewCellStyleValue2
                reuseIdentifier:cellClassString];
    }

    cell.key = [row objectForKey:@"key"];
    cell.value = [self.hero valueForKey:cell.key];
    cell.label.text = [row objectForKey:@"label"];

    // For setting Sex possible values
    NSArray *values = [row valueForKey:@"values"];
    if (values) {
        // TODO clean this up - ugh
        [cell performSelector:@selector(setValues:) withObject:values];
    }
    
    return cell;
}


// To prevent to show Delete buttons
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.navigationItem.rightBarButtonItem = editing ? self.saveButton : self.editButtonItem;
    self.navigationItem.leftBarButtonItem = editing ? self.cancelButton : self.backButton;
}

#pragma mark - (Private) Instance Methods

- (void)save {
    [self setEditing:NO animated:YES];
    // TODO Visible cells???
    for (SuperDBEditCell *cell in [self.tableView visibleCells]) {
        [self.hero setValue:cell.value
                     forKey:cell.key];
    }
    
    NSError *error = nil;
    if (![self.hero.managedObjectContext save:&error]) {
        NSLog(@"Error saving: %@", error.localizedDescription);
    }
    
    [self.tableView reloadData];
    [self setEditing:NO animated:YES];
}


- (void)cancel {
    [self setEditing:NO animated:YES];
}

@end
