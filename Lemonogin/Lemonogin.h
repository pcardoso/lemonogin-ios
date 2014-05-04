//
//  Lemonogin.h
//  PTPayCore
//
//  Created by Pedro Cardoso on 29/04/14.
//  Copyright (c) 2014 Warp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lemonogin : NSObject

@property (nonatomic, strong) NSURL *sourceURL;

+ (id)manager;

- (void)triggerOnAnchor:(UIView *)anchor view:(UIView *)view callback:(void (^)(NSString *username, NSString *password, NSString *notes))callback;

@end
