//
//  YSLGoogleSuggestCell.m
//  YSLGoogleSuggestControllerDemo
//
//  Created by yamaguchi on 2015/03/27.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLGoogleSuggestCell.h"

@implementation YSLGoogleSuggestCell

- (void)awakeFromNib {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _wordLabel = [[UILabel alloc]init];
        _wordLabel.frame = CGRectMake(10, 0, self.frame.size.width, 35);
        _wordLabel.font = [UIFont systemFontOfSize:13];
        _wordLabel.textColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
        [self.contentView addSubview:_wordLabel];
    }
    return self;
}

- (void)setLabelTextColor:(UIColor*)color font:(UIFont *)font
{
    if (color) {
        _wordLabel.textColor = color;
    }
    if (font) {
        _wordLabel.font = font;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
