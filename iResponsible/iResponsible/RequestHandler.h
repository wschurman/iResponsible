// Copyright (c) 2015 WillMahRyan. All rights reserved.

#import <Foundation/Foundation.h>

@protocol RequestHandlerDelegate

- (void)didReceiveResponse:(BOOL)doesHaveEnoughMoney;
- (void)didReceiveError;
- (void)didTimeout;

@end

@interface RequestHandler : NSObject

@property (nonatomic, weak) id<RequestHandlerDelegate> delegate;

- (void)sendRequestForPrice:(NSInteger)price budget:(NSInteger)budget;

@end
