//
//  HeroListController.h
//  SuperDB
//
//  Created by Limitation on 6/28/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kSelectedTabDefaultsKey = @"Selected Tab";

typedef NS_ENUM(NSUInteger, SortingType) {
    kByName,
    kBySecretIdentity,
};

@interface HeroListController : UIViewController <UITableViewDataSource, UITabBarDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *heroTableView;
@property (weak, nonatomic) IBOutlet UITabBar *heroTabBar;
- (IBAction)addHero:(UIBarButtonItem *)sender;

@end
