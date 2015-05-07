//
//  YSLGoogleSuggestView.m
//  YSLGoogleSuggestControllerDemo
//
//  Created by yamaguchi on 2015/03/26.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLGoogleSuggestView.h"
#import "YSLGoogleSuggestCell.h"


static const CGFloat kTopBarHeight = 64;
static NSString *const kUrlGoogleSuggest = @"http://www.google.com/complete/search?";
static NSString *const kUserDefaultKeyLastWord = @"ud_key_last_word";
static NSString *const kUserDefaultKeyLastList = @"ud_key_last_list";

@interface YSLGoogleSuggestView () <UITextFieldDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isSaveSearchResult;
@property (nonatomic, copy) NSString *inputTextString;
@property (nonatomic, strong) NSMutableArray *suggestWordList;

@end

@implementation YSLGoogleSuggestView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.callback = nil;
}

- (id)init
{
    return [self initWithSaveSearchResult:NO];
}

- (id)initWithSaveSearchResult:(BOOL)isSaveSearchResult
{
    self = [super init];
    if (self) {
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        self.backgroundColor = [UIColor clearColor];
        
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        [window addSubview:self];
        
        // back
        _backView = [[UIView alloc]init];
        _backView.frame = self.frame;
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _backView.alpha = 0.0f;
        _backView.userInteractionEnabled = YES;
        [self addSubview:_backView];
        
        UITapGestureRecognizer *backViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endAnimation)];
        [_backView addGestureRecognizer:backViewTapGesture];
        
        // header
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, - kTopBarHeight, self.frame.size.width, kTopBarHeight);
        _headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headerView];
        // header Shadow
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, _headerView.frame.size.height - 0.5, CGRectGetWidth(_headerView.frame), 0.5);
        view.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:view];
        
        // textField
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.frame = CGRectMake(10, 25, self.frame.size.width - 20, 30);
        _textField.backgroundColor = [UIColor colorWithRed:0.966667 green:0.966667 blue:0.966667 alpha:1.0];
        _textField.placeholder = @""@"search word";
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.font = [UIFont systemFontOfSize:13];
        [_headerView addSubview:_textField];
        
        // textField Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_textField];
        
        // tableView
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopBarHeight, self.frame.size.width, 0)
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView registerClass:[YSLGoogleSuggestCell class] forCellReuseIdentifier:@"YSLGoogleSuggestCell"];
        
        _isSaveSearchResult = isSaveSearchResult;
    }
    return self;
}

#pragma mark -- Setter
- (void)setHeaderBackgroudColor:(UIColor *)headerBackgroudColor
{
    if (!headerBackgroudColor) { return; }
    _headerBackgroudColor = headerBackgroudColor;
    _headerView.backgroundColor = _headerBackgroudColor;
}
- (void)setPlaceholderText:(NSString *)placeholderText
{
    if (!placeholderText) { return; }
    _placeholderText = placeholderText;
    _textField.placeholder = _placeholderText;
}
- (void)setTextFieldBackgroudColor:(UIColor *)textFieldBackgroudColor
{
    if (!textFieldBackgroudColor) { return; }
    _textFieldBackgroudColor = textFieldBackgroudColor;
    _textField.backgroundColor = _textFieldBackgroudColor;
}

- (void)setTextFieldFont:(UIFont *)textFieldFont
{
    if (!textFieldFont) { return; }
    _textFieldFont = textFieldFont;
    _textField.font = _textFieldFont;
}

- (void)setTextFieldTextColor:(UIColor *)textFieldTextColor
{
    if (!textFieldTextColor) { return; }
    _textFieldTextColor = textFieldTextColor;
    _textField.textColor = _textFieldTextColor;
}

- (void)setTableBackgroudColor:(UIColor *)tableBackgroudColor
{
    if (!tableBackgroudColor) { return; }
    _tableBackgroudColor = tableBackgroudColor;
    _tableView.backgroundColor = _tableBackgroudColor;
}

#pragma mark -- Public
- (void)showSuggestView
{
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _headerView.frame = CGRectMake(0, 0, self.frame.size.width, kTopBarHeight);
                         _backView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                     }];
    [_textField becomeFirstResponder];
    
    // Load Last Search Result
    if (_isSaveSearchResult) {
        _inputTextString = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyLastWord];
        _textField.text = _inputTextString;
        
        _suggestWordList = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyLastList] mutableCopy];
        [_tableView reloadData];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height = _tableView.contentSize.height;
                         _tableView.frame = frame;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)showSuggestViewWithHandler:(YSLGoogleSuggestViewCallbackHandler)handler
{
    self.callback = handler;
    [self showSuggestView];
}

#pragma mark -- Private

- (void)endAnimation
{
    [_textField resignFirstResponder];
    
    __weak YSLGoogleSuggestView *weakself = self;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _headerView.frame = CGRectMake(0, -kTopBarHeight, self.frame.size.width, kTopBarHeight);
                         _tableView.frame = CGRectMake(0, -_tableView.contentSize.height, self.frame.size.width, _tableView.contentSize.height);
                         _backView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [weakself removeFromSuperview];
                     }];
    // Saved Last Search Result
    if (_isSaveSearchResult) {
        if (_suggestWordList) {
            [[NSUserDefaults standardUserDefaults] setValue:_suggestWordList forKey:kUserDefaultKeyLastList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (_inputTextString) {
            [[NSUserDefaults standardUserDefaults] setValue:_inputTextString forKey:kUserDefaultKeyLastWord];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)searchWord:(NSString *)word
{
    if ([_inputTextString isEqualToString:word]) { return; }
    
    NSString *wordEscape = [self escapeString:word];
    NSString *urlSring = [kUrlGoogleSuggest stringByAppendingString:[NSString stringWithFormat:@"hl=en&output=toolbar&q=%@",wordEscape]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSring]];
    __weak YSLGoogleSuggestView *weakself = self;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
                                   parser.delegate = weakself;
                                   [parser parse];
                               }
                           }];
}
// encode
- (NSString*)escapeString:(NSString*)string
{
    NSString *escapedlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                     (CFStringRef)string,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    return escapedlString;
}

#pragma mark -- XMLParser Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _suggestWordList = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"suggestion"]) {
        if (_suggestWordList.count < 5) {
            [_suggestWordList addObject:attributeDict[@"data"]];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = _tableView.frame;
                             frame.size.height = _tableView.contentSize.height;
                             _tableView.frame = frame;
                         } completion:^(BOOL finished) {
                         }];
    });
}

#pragma mark -- TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) { return NO; }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(suggestViewSearchResult:)]) {
        [self.delegate suggestViewSearchResult:textField.text];
    }
    
    if (self.callback) {
        self.callback(textField.text);
    }
    
    _inputTextString = _textField.text;
    [self endAnimation];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark -- TextField Notificaton
- (void)textFieldDidChange:(NSNotification*)notification
{
    UITextField *textField = (UITextField *)notification.object;

    NSString *text = [textField.text precomposedStringWithCompatibilityMapping];

    [self searchWord:text];
    _inputTextString = [text copy];
}

#pragma mark -- TableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _suggestWordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"YSLGoogleSuggestCell";
    YSLGoogleSuggestCell *cell = (YSLGoogleSuggestCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.wordLabel.text = _suggestWordList[indexPath.row];
    [cell setLabelTextColor:_tableCellTextColor font:_tableCellFont];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(suggestViewSearchResult:)]) {
        [self.delegate suggestViewSearchResult:_suggestWordList[indexPath.row]];
    }
    
    if (self.callback) {
        self.callback(_suggestWordList[indexPath.row]);
    }
    
    _textField.text = _suggestWordList[indexPath.row];
    _inputTextString = _textField.text;
    [self endAnimation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

@end
