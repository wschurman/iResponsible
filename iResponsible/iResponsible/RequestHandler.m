// Copyright (c) 2015 WillMahRyan. All rights reserved.

#import "RequestHandler.h"
#import "GCDAsyncUdpSocket.h"

#define kHost @"10.0.1.4"
#define kPort 8000

@interface RequestHandler () <GCDAsyncUdpSocketDelegate>
@end

@implementation RequestHandler {
    dispatch_queue_t _queue;
    GCDAsyncUdpSocket *_socket;
    NSUUID *_currentRequestID;

    NSTimer *_timeoutTimer;
}

- (void)dealloc {
    [_socket close];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("wat", NULL);
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:_queue];
        NSError *error;
        if (![_socket connectToHost:kHost onPort:kPort error:&error]) {
            NSLog(@"I done goofed: %@", error);
        }
        [_socket beginReceiving:&error];
    }
    return self;
}

- (void)sendRequestForPrice:(NSInteger)price budget:(NSInteger)budget {
    if (![_socket isConnected]) {
        [self.delegate didTimeout];
        return;
    }

    _currentRequestID = [NSUUID UUID];

    NSDictionary *wat = @{@"want": [NSNumber numberWithInteger:price],
                          @"have": [NSNumber numberWithInteger:budget],
                          @"client_request_id": [_currentRequestID UUIDString]};
    NSError *error;
    [_socket sendData:[NSJSONSerialization dataWithJSONObject:wat options:0 error:&error] withTimeout:1 tag:1];
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                     target:self
                                                   selector:@selector(timerDidTimeout:)
                                                   userInfo:nil
                                                    repeats:NO];
}

#pragma mark - CGDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSLog(@"CONNECTED: %@", address);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSError *error;
    NSDictionary *wat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    NSString *clientRequestID = [wat objectForKey:@"client_request_id"];
    if (!clientRequestID || ![clientRequestID isEqualToString:[_currentRequestID UUIDString]]) {
        return;
    }

    [_timeoutTimer invalidate];
    _timeoutTimer = nil;

    BOOL ans = [[wat objectForKey:@"answer"] isEqualToString:@"yes"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didReceiveResponse:ans];
    });
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didReceiveError];
    });
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didReceiveError];
    });
}

#pragma mark - NSTimer

- (void)timerDidTimeout:(NSTimer *)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didTimeout];
    });
}

@end
