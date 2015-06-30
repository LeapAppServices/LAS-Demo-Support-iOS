//
//  ViewController.m
//  HelpCenterDemo
//
//  Created by Sun Jin on 15/1/9.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import "ViewController.h"
#import <LASHelpCenter/LASHelpCenter.h>

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@end

@implementation ViewController {
    IBOutlet UIScrollView *_scrollView;
    NSArray *_hsFeatures;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initAllFeatures];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Root";
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper"]]];
    __block CGFloat prevHeight = 0;
    [_hsFeatures enumerateObjectsUsingBlock:^(id featuresDict, NSUInteger idx, BOOL *stop) {
        CGSize maxTxtSize = CGSizeMake(_scrollView.frame.size.width - 40,9999);
        CGSize minTxtSize = CGSizeMake(_scrollView.frame.size.width - 40, 120);
        if([[featuresDict valueForKey:@"description"] length] > 1)
        {
            UIFont *labelFont = [UIFont systemFontOfSize:16.0f];
            minTxtSize = [[featuresDict valueForKey:@"description"] sizeWithFont:labelFont constrainedToSize:maxTxtSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        UIView *showSupportView = [[UIView alloc] initWithFrame:CGRectMake(0, prevHeight, _scrollView.frame.size.width, (minTxtSize.height + 100))];
        [showSupportView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [showSupportView setBackgroundColor:[featuresDict valueForKey:@"bgcolor"]];
        showSupportView.tag = idx + 100;
        
        UITextView *descView = [[UITextView alloc] init];
        [descView setScrollEnabled:NO];
        [descView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [descView setBackgroundColor:[UIColor clearColor]];
        [descView setEditable:NO];
        [descView setFont:[UIFont systemFontOfSize:16.0f]];
        [descView setText:[featuresDict valueForKey:@"description"]];
        [descView setTextColor:[featuresDict valueForKey:@"text_color"]];
        [descView setFrame:CGRectMake(10, 10, minTxtSize.width + 20, minTxtSize.height + 20)];
        [showSupportView addSubview:descView];
        
        UIButton *btnShowFeature = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShowFeature setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [btnShowFeature setTag:(idx + 11)];
        [btnShowFeature.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [btnShowFeature setBackgroundColor:[UIColor redColor]];
        [btnShowFeature addTarget:self action:@selector(btnSupportClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnShowFeature setTitle:[featuresDict valueForKey:@"title"] forState:UIControlStateNormal];
        [btnShowFeature setFrame:CGRectMake((_scrollView.frame.size.width/2) - 75, (minTxtSize.height + 40), 150, 40)];
        [showSupportView addSubview:btnShowFeature];
        prevHeight = prevHeight + minTxtSize.height + 100;
        [_scrollView addSubview:showSupportView];
    }];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, prevHeight)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    __block CGFloat prevHeight = 0;
    [_hsFeatures enumerateObjectsUsingBlock:^(id featuresDict, NSUInteger idx, BOOL *stop) {
        CGSize maxTxtSize = CGSizeMake(_scrollView.frame.size.width - 40,9999);
        CGSize minTxtSize = CGSizeMake(_scrollView.frame.size.width - 40, 120);
        if([[featuresDict valueForKey:@"description"] length] > 1)
        {
            UIFont *labelFont = [UIFont systemFontOfSize:16.0f];
            minTxtSize = [[featuresDict valueForKey:@"description"] sizeWithFont:labelFont constrainedToSize:maxTxtSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        UIView *showSupportView = [_scrollView viewWithTag:idx + 100];
        showSupportView.frame = CGRectMake(0, prevHeight, _scrollView.frame.size.width, minTxtSize.height+100);
        
        prevHeight = prevHeight + minTxtSize.height + 100;
        [_scrollView addSubview:showSupportView];
        
        NSLog(@"frame: %@, height: %f", NSStringFromCGRect(showSupportView.frame), prevHeight);
    }];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, prevHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Showing the support screens in app [http://www.helpshift.com/docs/howto/ios/v2.x/#decomposition]
- (void)btnSupportClick:(id)sender {
    UIButton *button = (UIButton *) sender;
    switch (button.tag) {
        case HC_SHOW_HELP:
            [[LASHelpCenter sharedInstance] showFAQs:self];
            break;
        case HC_SHOW_CONTACTUS:
            [[LASHelpCenter sharedInstance] showConversation:self];
            break;
        case HC_SHOW_FAQSECTION:
            //The PUBLISH-ID will be the id of the FAQ section which is shown under FAQs (leap.as/faq/apps/_yourapplicationid_#en/_faqsectionpublishid_).
            [[LASHelpCenter sharedInstance] showFAQSection:@"<PUBLISH-ID>" withController:self];
            break;
        case HC_SHOW_SINGLEFAQ:
            //The PUBLISH-ID will be the id of the FAQ which is shown under FAQs (leap.as/faq/apps/_yourApplicationId_#en/_faqSectionId_/edit/_faqItemId_)
            [[LASHelpCenter sharedInstance] showSingleFAQ:@"<PUBLISH-ID>" withController:self];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 


static NSArray *hsFeatures = nil;

- (void) initAllFeatures {
    if (_hsFeatures == nil) {
        _hsFeatures = @[
                        @{
                            @"title":@"Help",
                            @"description":@"You can use the showFAQs: api call to show the LASHelpCenter screen with only the faq sections with search, you can use this api. This screen will not show the issues reported by the user.",
                            @"bgcolor":UIColorFromRGB(0xA7C5BD),
                            @"text_color":UIColorFromRGB(0x4A4A4A)
                          },
                        @{
                            @"title":@"Contact Us",
                            @"description":@"You can use the showConversation: api call to show the LASHelpCenter conversation screen.",
                            @"bgcolor":UIColorFromRGB(0xE5DDCB),
                            @"text_color":UIColorFromRGB(0x4A4A4A)
                            },
                        @{
                            @"title":@"Show FAQ Section",
                            @"description":@"You can use showFAQSection:withController: api call To show the LASHelpCenter screen for showing a particular faq section you need to pass the publish-id of the faq section and the name of the viewcontroller on which the faq section screen will show up. For example from inside a viewcontroller you can call the LASHelpCenter faq section screen by passing the argument “self” for the viewController parameter.",
                            @"bgcolor":UIColorFromRGB(0x524656),
                            @"text_color":UIColorFromRGB(0xDDDDDD)
                            },
                        @{
                            @"title":@"Show Single FAQ",
                            @"description":@"You can use the showSingleFAQ:withController: api call To show the LASHelpCenter screen for showing a single faq you need to pass the publish-id of the faq and the name of the viewcontroller on which the faq screen will show up. For example from inside a viewcontroller you can call the LASHelpCenter faq section screen by passing the argument “self” for the viewController parameter.",
                            @"bgcolor":UIColorFromRGB(0xA7C5BD),
                            @"text_color":UIColorFromRGB(0x4A4A4A)
                            },
                        ];
    }
}

@end
