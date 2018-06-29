//
//  SuperDBEditCell.m
//  SuperDB
//
//  Created by Serhii K on 6/29/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import "SuperDBEditCell.h"

#define kLabelTextColor [UIColor colorWithRed:(150.f/255.f) green:0.4f blue:1.f alpha:1.f]

@implementation SuperDBEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellEditingStyleNone;
        self.label = [[UILabel alloc]
                      initWithFrame:CGRectMake(12.f, 15.f, 67.f, 15.f)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.textColor = kLabelTextColor;
        self.label.text = @"label";
        
        [self.contentView addSubview:self.label];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(93.f, 13.f, 170.f, 19.f)];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.enabled = NO;
        self.textField.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        self.textField.text = @"Title";
        
        [self.contentView addSubview:self.textField];
    }
    
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.textField.enabled = editing;
}

@end
