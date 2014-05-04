//
//  Lemonogin.m
//  PTPayCore
//
//  Created by Pedro Cardoso on 29/04/14.
//  Copyright (c) 2014 Warp. All rights reserved.
//

#import "Lemonogin.h"

NSString *const kLemonoginSchemePrefix = @"lemonogin";

@interface  Lemonogin() <UIWebViewDelegate>
@end

@implementation Lemonogin {
    BOOL presenting;
    UIView *parentView;
    UIView *containingView;
    UIView *innerView;
    void (^returnCallback)(NSString *username, NSString *password, NSString *notes);
}

+ (id)manager
{
    static Lemonogin *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)triggerOnAnchor:(UIView *)anchor view:(UIView *)view callback:(void (^)(NSString *username, NSString *password, NSString *notes))callback
{
    parentView = view;
    returnCallback = callback;

    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(anchorTapped:)];
    [anchor addGestureRecognizer:gr];
}

- (void)anchorTapped:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) return;

    if (presenting) return;
    presenting = YES;

    CGRect frame = CGRectInset(parentView.frame, 10, 50);

    UIView *fullscreenView = [[UIView alloc] initWithFrame:parentView.frame];
    fullscreenView.backgroundColor = [UIColor colorWithRed:0.502 green:1.000 blue:0.000 alpha:.2];
    [parentView addSubview:fullscreenView];
    containingView = fullscreenView;

    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.0 alpha:.3];

    [containingView addSubview:view];
    innerView = view;

    CGRect webViewRect, closeButtonRect, innerFrame = CGRectInset(view.bounds, 5, 5);

    CGRectDivide(innerFrame, &webViewRect, &closeButtonRect, CGRectGetHeight(innerFrame) - 40, CGRectMinYEdge);

    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewRect];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:self.sourceURL]];
    [view addSubview:webView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = closeButtonRect;
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [view addSubview:button];

    // prep for animation
    innerView.frame = CGRectOffset(innerView.frame, 0, CGRectGetHeight(containingView.frame));
    containingView.alpha = 0;

    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         innerView.frame = CGRectOffset(innerView.frame, 0, -CGRectGetHeight(containingView.frame));
                         containingView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                     }];

}

- (void)didReceiveLemonogin:(NSURL *)url
{
    NSString *q = [url query];
    NSArray *pairs = [q componentsSeparatedByString:@"&"];
    NSMutableDictionary *kvPairs = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *bits = [pair componentsSeparatedByString:@"="];
        NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [kvPairs setObject:value forKey:key];
    }

    returnCallback(kvPairs[@"username"], kvPairs[@"password"], kvPairs[@"notes"]);

    [self dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:kLemonoginSchemePrefix]) {
        [self didReceiveLemonogin:request.URL];
        return NO;
    }
    return YES;
}

- (void)closeButtonTapped:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         innerView.frame = CGRectOffset(innerView.frame, 0, CGRectGetHeight(containingView.frame));
                         containingView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [containingView removeFromSuperview];
                         containingView = nil;
                         presenting = NO;
                     }];
}

@end