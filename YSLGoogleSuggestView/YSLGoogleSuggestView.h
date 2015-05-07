//
//  YSLGoogleSuggestView.h
//  YSLGoogleSuggestControllerDemo
//
//  Created by yamaguchi on 2015/03/26.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YSLGoogleSuggestViewCallbackHandler)(NSString * word);

@protocol YSLGoogleSuggestViewDelegate <NSObject>

- (void)suggestViewSearchResult:(NSString *)word;

@end

@interface YSLGoogleSuggestView : UIView

@property (nonatomic, weak) id <YSLGoogleSuggestViewDelegate> delegate;
@property (nonatomic, copy) YSLGoogleSuggestViewCallbackHandler callback;

// header or textField
@property (nonatomic, strong) UIColor *headerBackgroudColor;
@property (nonatomic, copy) NSString  *placeholderText;
@property (nonatomic, strong) UIColor *textFieldBackgroudColor;
@property (nonatomic, strong) UIFont  *textFieldFont;
@property (nonatomic, strong) UIColor *textFieldTextColor;
// tableView
@property (nonatomic, strong) UIColor *tableBackgroudColor;
@property (nonatomic, strong) UIColor *tableCellTextColor;
@property (nonatomic, strong) UIFont  *tableCellFont;


/**
 *  init
 *
 *  @param isSaveSearchResult Saved Search History
 *
 *  @return self
 */
- (id)initWithSaveSearchResult:(BOOL)isSaveSearchResult;

/**
 *  show suggestView (Delegate)
 */

- (void)showSuggestView;
/**
 *  show suggestView (blocks)
 *
 *  @param handler search Result callback
 */
- (void)showSuggestViewWithHandler:(YSLGoogleSuggestViewCallbackHandler)handler;

@end
