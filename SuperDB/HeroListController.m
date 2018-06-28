//
//  HeroListController.m
//  SuperDB
//
//  Created by Limitation on 6/28/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import "HeroListController.h"

@interface HeroListController ()

@property (strong, readonly, nonatomic) NSFetchedResultsController *fetchResultsController;

@end

@implementation HeroListController

@synthesize fetchResultsController = _fetchResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Selecting first Tab by default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger selectedTabIndex = [defaults integerForKey:kSelectedTabDefaultsKey];
    UITabBarItem *selectedItem = [self.heroTabBar.items objectAtIndex:selectedTabIndex];
    self.heroTabBar.selectedItem = selectedItem;
    
    // Fetch any existing entities
    NSError *error = nil;
    if (![self.fetchResultsController performFetch:&error]) {
        NSString *message = [NSString
                             stringWithFormat:@"Error was %@: quitting",
                             error.localizedDescription];
        [self showAlert:NSLocalizedString(@"Error fetching entity", @"Error fetching entity")
                message:NSLocalizedString(message, message)
             buttonText:NSLocalizedString(@"Aw, nuts", @"Aw, nuts")
                handler:^(UIAlertAction *alert) {
                    [self dismissButtonOnALertController:alert];
                }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HeroListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *hero = [self.fetchResultsController objectAtIndexPath:indexPath];
    NSUInteger tabIndex = [self.heroTabBar.items indexOfObject:self.heroTabBar.selectedItem];
    
    switch (tabIndex) {
        case kByName:
            cell.textLabel.text = [hero valueForKey:@"name"];
            cell.detailTextLabel.text = [hero valueForKey:@"secretIdentity"];
            break;
        case kBySecretIdentity:
            cell.textLabel.text = [hero valueForKey:@"secretIdentity"];
            cell.detailTextLabel.text = [hero valueForKey:@"name"];
        default:
            break;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *managedObjectContext = [self.fetchResultsController managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [managedObjectContext deleteObject:[self.fetchResultsController
                                            objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSString *message = [NSString
                                 stringWithFormat:@"Error was %@: quitting",
                                 error.localizedDescription];
            [self showAlert:NSLocalizedString(@"Error saving entity", @"Error saving entity")
                    message:NSLocalizedString(message, message)
                 buttonText:NSLocalizedString(@"Aw, nuts", @"Aw, nuts")
                    handler:^(UIAlertAction *alert) {
                        [self dismissButtonOnALertController:alert];
                    }];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

#pragma mark - Actions

- (IBAction)addHero:(UIBarButtonItem *)sender {
    NSManagedObjectContext *managedObjectContext = [self.fetchResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchResultsController fetchRequest] entity];
    [NSEntityDescription insertNewObjectForEntityForName:entity.name
                                  inManagedObjectContext:managedObjectContext];
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSString *message = [NSString
                             stringWithFormat:@"Error was %@: quiting",
                             error.localizedDescription];
        [self showAlert:NSLocalizedString(@"Error saving entity", @"Error saving entity")
                message:NSLocalizedString(message, message)
             buttonText:NSLocalizedString(@"Aw, nuts", @"Aw, nuts")
                handler:^(UIAlertAction *alert) {
                    [self dismissButtonOnALertController:alert];
                }];
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.addButton.enabled = !editing;
    [self.heroTableView setEditing:editing animated:animated];
}

#pragma mark - UITabBarDelegate Methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    [defaults setInteger:tabIndex forKey:kSelectedTabDefaultsKey];
    
    [NSFetchedResultsController deleteCacheWithName:@"Hero"];
    _fetchResultsController.delegate = nil;
    _fetchResultsController = nil;
    
    NSError *error = nil;
    if (![self.fetchResultsController performFetch:&error]) {
        NSLog(@"Error performing fetch: %@", error.localizedDescription);
    }
    
    [self.heroTableView reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate Property

- (NSFetchedResultsController *)fetchResultsController {
    if (_fetchResultsController) {
        return _fetchResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Hero"
                                   inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSUInteger tabIndex = [self.heroTabBar.items indexOfObject:self.heroTabBar.selectedItem];
    if (tabIndex == NSNotFound) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tabIndex = [defaults integerForKey:kSelectedTabDefaultsKey];
    }

    NSString *sectionKey = nil;
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                         initWithKey:@"name"
                                         ascending:YES];;
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                        initWithKey:@"secretIdentity"
                                        ascending:YES];
    NSArray *sortDescriptors = nil;
    switch (tabIndex) {
        case kByName:
            sortDescriptors = @[sortDescriptor1, sortDescriptor2];
            sectionKey = @"name";
            break;
        case kBySecretIdentity:
            sortDescriptors = @[sortDescriptor2, sortDescriptor1];
            sectionKey = @"secretIdentity";
            break;
        default:
            break;
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchResultsController = [[NSFetchedResultsController alloc]
                               initWithFetchRequest:fetchRequest
                               managedObjectContext:managedObjectContext
                               sectionNameKeyPath:sectionKey
                               cacheName:@"Hero"];
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegare Methods

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.heroTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.heroTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.heroTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.heroTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
        default:
            break;
    }
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.heroTableView beginUpdates];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.heroTableView endUpdates];
}

#pragma mark - UIAlertController Handler Method

- (void)dismissButtonOnALertController:(UIAlertAction *)action {
    exit(-1);
}


- (void)showAlert:(NSString *)title
          message:(NSString *)message
       buttonText:(NSString *)buttonText
          handler:(void(^)(UIAlertAction *alert))handler {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:buttonText
                               style:UIAlertActionStyleDefault
                               handler:handler];
    
    [alert addAction:okButton];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
