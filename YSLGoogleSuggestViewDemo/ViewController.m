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

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // NavigationBar
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    titleView.textColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
    titleView.text = @"Search History";
    [titleView sizeToFit];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    
    
    _resultArray = [NSMutableArray array];
}

- (IBAction)searchBtnTap:(id)sender
{
    YSLGoogleSuggestView *gSuggestView = [[YSLGoogleSuggestView alloc]initWithSaveSearchResult:YES];
//    gSuggestView.delegate = self;
//    [gSuggestView showSuggestView];
    
    [gSuggestView showSuggestViewWithHandler:^(NSString *word) {
        NSLog(@"Search Word (blocks) %@", word);
        [_resultArray addObject:word];
        [_tableView reloadData];
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
    [_resultArray addObject:word];
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"sample_cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = (UITableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Futura-Medium" size:10];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.text = _resultArray[indexPath.row];
    cell.detailTextLabel.text = @"Search Word";
    
    return cell;
}


@end
