//
//  MultipleObjectiveCViewController.m
//  ZSWTappableLabel
//
//  Created by Zachary West on 12/19/15.
//  Copyright © 2015 Zachary West. All rights reserved.
//

#import "MultipleObjectiveCViewController.h"

@import Masonry;
@import ZSWTappableLabel;
@import ZSWTaggedString;
@import SafariServices;


static NSString *const URLAttributeName = @"URL";

@interface MultipleObjectiveCViewController () <ZSWTappableLabelTapDelegate>
@property (nonatomic) ZSWTappableLabel *label;

@end

@implementation MultipleObjectiveCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = ^{
        ZSWTappableLabel *label = [[ZSWTappableLabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.tapDelegate = self;
        return label;
    }();
    
    ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
    [options setDynamicAttributes:^NSDictionary *(NSString *tagName,
                                                  NSDictionary *tagAttributes,
                                                  NSDictionary *existingStringAttributes) {
        NSURL *URL;
        if ([tagAttributes[@"type"] isEqualToString:@"privacy"]) {
            URL = [NSURL URLWithString:@"http://google.com/search?q=privacy"];
        } else if ([tagAttributes[@"type"] isEqualToString:@"tos"]) {
            URL = [NSURL URLWithString:@"http://google.com/search?q=tos"];
        }
        
        if (!URL) {
            return nil;
        }
        
        return @{
                 ZSWTappableLabelTappableRegionAttributeName: @YES,
                 ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor lightGrayColor],
                 ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor whiteColor],
                 NSForegroundColorAttributeName: [UIColor blueColor],
                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                 @"URL": URL
                 };
    } forTagName:@"link"];
    
    NSString *string = NSLocalizedString(@"View our <link type='privacy'>Privacy Policy</link> or <link type='tos'>Terms of Service</link>", nil);
    self.label.attributedText = [[ZSWTaggedString stringWithString:string] attributedStringWithOptions:options];
    
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - ZSWTappableLabelTapDelegate

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary<NSString *,id> *)attributes {
    NSURL *URL = attributes[URLAttributeName];
    if ([URL isKindOfClass:[NSURL class]]) {
        if ([SFSafariViewController class] != nil) {
            [self showViewController:[[SFSafariViewController alloc] initWithURL:URL] sender:self];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }
}

@end
