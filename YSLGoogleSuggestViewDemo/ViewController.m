//
//  ViewController.m
//  YSLGoogleSuggestViewDemo
//
//  Created by yamaguchi on 2015/04/28.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "ViewController.h"
#import "YSLGoogleSuggestView.h"

@interface ViewController () <YSLGoogleSuggestViewDelegate>

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)searchBtnTap:(id)sender
{
    YSLGoogleSuggestView *gSuggestView = [[YSLGoogleSuggestView alloc]initWithSaveSearchResult:YES];
//    gSuggestView.delegate = self;
//    [gSuggestView showSuggestView];
    
    [gSuggestView showSuggestViewWithHandler:^(NSString *word) {
        NSLog(@"Search Word (blocks) %@", word);
    }];
    
    //    gSuggestView.placeholderText = @"Sample";
    //    gSuggestView.placeholderTextColor = [UIColor greenColor];
    //    gSuggestView.headerBackgroudColor = [UIColor redColor];
    //    gSuggestView.textFieldBackgroudColor = [UIColor purpleColor];
        gSuggestView.textFieldFont = [UIFont fontWithName:@"Futura-Medium" size:13];
    //    gSuggestView.textFieldTextColor = [UIColor darkGrayColor];
    
    //    gSuggestView.tableBackgroudColor = [UIColor yellowColor];
        gSuggestView.tableCellFont = [UIFont fontWithName:@"Futura-Medium" size:13];
    //    gSuggestView.tableCellTextColor = [UIColor darkGrayColor];
    //    gSuggestView.cancelButtonTextColor = [UIColor blueColor];
}

#pragma mark -- YSLGoogleSuggestView Delegate
- (void)suggestViewSearchResult:(NSString *)word
{
    NSLog(@"Search Word (delegate) : %@",word);
}

@end
