// Copyright (c) 2015 WillMahRyan. All rights reserved.

#import "ViewController.h"
#import "RequestHandler.h"

@interface ViewController () <RequestHandlerDelegate>

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *budgetLabel;
@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UITextField *budgetField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation ViewController {
    RequestHandler *_requestHandler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestHandler = [[RequestHandler alloc] init];
        [_requestHandler setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    _priceLabel = [UILabel new];
    [_priceLabel setText:@"Price of Item (in cents)"];
    [_priceLabel setFont:[UIFont systemFontOfSize:18.f]];
    [_priceLabel sizeToFit];
    [self.view addSubview:_priceLabel];

    _priceField = [UITextField new];
    [_priceField setBorderStyle:UITextBorderStyleRoundedRect];
    [_priceField setKeyboardType:UIKeyboardTypeNumberPad];
    [_priceField setPlaceholder:@"ex. 1200"];
    [self.view addSubview:_priceField];

    _budgetLabel = [UILabel new];
    [_budgetLabel setText:@"How much money do you have? (in cents)"];
    [_budgetLabel setFont:[UIFont systemFontOfSize:18.f]];
    [_budgetLabel sizeToFit];
    [self.view addSubview:_budgetLabel];

    _budgetField = [UITextField new];
    [_budgetField setBorderStyle:UITextBorderStyleRoundedRect];
    [_budgetField setKeyboardType:UIKeyboardTypeNumberPad];
    [_budgetField setPlaceholder:@"ex. 1500"];
    [self.view addSubview:_budgetField];

    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setBackgroundColor:[UIColor blueColor]];
    [_submitButton setTitle:@"CAN I HAS THIS?" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];

    _resultLabel = [UILabel new];
    [_resultLabel setFont:[UIFont systemFontOfSize:18.f]];
    [self.view addSubview:_resultLabel];
}

- (void)viewWillLayoutSubviews {
    int topOffset = 100;

    [_priceLabel setFrame:CGRectMake(self.view.center.x - _priceLabel.frame.size.width / 2,
                                     topOffset,
                                     _priceLabel.frame.size.width,
                                     _priceLabel.frame.size.height)];

    [_priceField setFrame:CGRectMake(10, topOffset + 30, self.view.frame.size.width - 20, 30)];

    [_budgetLabel setFrame:CGRectMake(self.view.center.x - _budgetLabel.frame.size.width / 2,
                                      topOffset + 80,
                                      _budgetLabel.frame.size.width,
                                      _budgetLabel.frame.size.height)];

    [_budgetField setFrame:CGRectMake(10, topOffset + 110, self.view.frame.size.width - 20, 30)];

    [_submitButton setFrame:CGRectMake(10, topOffset + 170, self.view.frame.size.width - 20, 30)];

    [_resultLabel sizeToFit];
    [_resultLabel setFrame:CGRectMake(self.view.center.x - _resultLabel.frame.size.width / 2,
                                      topOffset + 220,
                                      _resultLabel.frame.size.width,
                                      _resultLabel.frame.size.height)];

    [_activityIndicator setFrame:CGRectMake(self.view.center.x - 45, topOffset + 250, 90, 90)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Submit

- (void)submit {
    [_priceField resignFirstResponder];
    [_budgetField resignFirstResponder];
    [_requestHandler sendRequestForPrice:[_priceField.text integerValue] budget:[_budgetField.text integerValue]];
    [_resultLabel setText:@""];
    [_activityIndicator startAnimating];
}

#pragma mark - RequestHanderDelegate

- (void)didReceiveError {
    [_activityIndicator stopAnimating];
    [_resultLabel setText:@"I GONE DONE MESSED UP"];
    [_resultLabel sizeToFit];
}

- (void)didTimeout {
    [_activityIndicator stopAnimating];
    [_resultLabel setText:@"THERE BE SOMETHING NOT WORKING"];
    [_resultLabel sizeToFit];
}

- (void)didReceiveResponse:(BOOL)doesHaveEnoughMoney {
    [_activityIndicator stopAnimating];

    NSString *wat = doesHaveEnoughMoney ? @"YOU HAVE ENOUGH MONEY!!!" : @"YOU CAN'T AFFORD THAT";
    [_resultLabel setText:wat];
    [_resultLabel sizeToFit];
}

@end
