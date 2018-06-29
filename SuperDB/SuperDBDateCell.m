//
//  SuperDBTateCell.m
//  SuperDB
//
//  Created by Serhii K on 6/29/18.
//  Copyright © 2018 Limitation. All rights reserved.
//

#import "SuperDBDateCell.h"

static NSDateFormatter *_dateFormatter = nil;

@interface SuperDBDateCell()

@property (strong, nonatomic) UIDatePicker *datePicker;
- (IBAction)datePickerChanged:(id)sender;

@end

@implementation SuperDBDateCell

+ (void)initialize {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self
                            action:@selector(datePickerChanged:)
                  forControlEvents:UIControlEventValueChanged];
        self.textField.inputView = _datePicker;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - SuperDBEditCell Overrides
- (id)value {
    if (self.textField.text == nil || [self.textField.text length] == 0) {
        return nil;
    }
    
    return self.datePicker.date;
}
- (void)setValue:(id)value {
    if (value != nil && [value isKindOfClass:[NSDate class]]) {
        [self.datePicker setDate:value];
        self.textField.text = [_dateFormatter stringFromDate:value];
    }
    else {
        self.textField.text = nil;
    }
}

#pragma mark - (Private) Instance Methods

- (IBAction)datePickerChanged:(id)sender {
    NSDate *date = [self.datePicker date];
    self.value = date;
    self.textField.text = [_dateFormatter stringFromDate:date];
}

@end
