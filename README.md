# YSLGoogleSuggestView

## Demo
![Dome](https://raw.githubusercontent.com/y-hryk/YSLGoogleSuggestView/master/sample.gif)
## Requirement
not support landscape
## Install
#### Manually
 Copy YSLGoogleSuggestView directory to your project.
#### CocoaPods
 Add pod 'YSLGoogleSuggestView' to your Podfile.
 
## Usage
### Delegate
    
    @interface ViewController () <YSLGoogleSuggestViewDelegate>
    
    - (IBAction)searchBtnTap:(id)sender
    {
       YSLGoogleSuggestView *gSuggestView = [[YSLGoogleSuggestView alloc]initWithSaveSearchResult:YES];
        gSuggestView.delegate = self
       [gSuggestView showSuggestView];
    }
    #pragma mark -- YSLGoogleSuggestView Delegate
    - (void)suggestViewSearchResult:(NSString *)word
    {
        NSLog(@"Search Word (delegate) : %@",word);
    }
    
### Blocks
    
    - (IBAction)searchBtnTap:(id)sender
    {
       YSLGoogleSuggestView *gSuggestView = [[YSLGoogleSuggestView alloc]initWithSaveSearchResult:YES];
      [gSuggestView showSuggestViewWithHandler:^(NSString *word) {
          NSLog(@"Search Word (blocks) %@", word);
       }];
    }
    
## Property
    
    gSuggestView.placeholderText = @"Sample";
    gSuggestView.headerBackgroudColor = [UIColor redColor];
    gSuggestView.textFieldBackgroudColor = [UIColor purpleColor];
    gSuggestView.textFieldFont = [UIFont fontWithName:@"Futura-Medium" size:13];
    gSuggestView.textFieldTextColor = [UIColor darkGrayColor];
    
    gSuggestView.tableBackgroudColor = [UIColor yellowColor];
    gSuggestView.tableCellFont = [UIFont fontWithName:@"Futura-Medium" size:13];
    gSuggestView.tableCellTextColor = [UIColor darkGrayColor];
    
## Licence
MIT
