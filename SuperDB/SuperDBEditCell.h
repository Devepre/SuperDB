//
//  SuperDBEditCell.h
//  SuperDB
//
//  Created by Serhii K on 6/29/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperDBEditCell : UITableViewCell

@property (strong, nonatomic) UILabel       *label;
@property (strong, nonatomic) UITextField   *textField;
@property (strong, nonatomic) NSString      *key;
@property (strong, nonatomic) id            value;

@end
