//
//  HeroDetailController.h
//  SuperDB
//
//  Created by Serhii K on 6/29/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HeroDetailController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *hero;

@end
