//
//  YSLGoogleSuggestCell.h
//  YSLGoogleSuggestControllerDemo
//
//  Created by yamaguchi on 2015/03/27.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSLGoogleSuggestCell : UITableViewCell

@property (nonatomic, strong) UILabel *wordLabel;

- (void)setLabelTextColor:(UIColor*)color font:(UIFont *)font;

@end
