//
//  HeroListController.h
//  SuperDB
//
//  Created by Limitation on 6/28/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroListController : UIViewController <UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *heroTableView;
@property (weak, nonatomic) IBOutlet UITabBar *heroTabBar;
- (IBAction)addHero:(UIBarButtonItem *)sender;

@end
