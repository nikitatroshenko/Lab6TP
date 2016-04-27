//
//  NiksonViewController.m
//  TPLab6.2
//
//  Created by fpmi on 27.04.16.
//  Copyright (c) 2016 Nikson. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "NiksonViewController.h"

@interface NiksonViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btnDo;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherText;

@end

@implementation NiksonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_lblWeather setText: @""];
//    [_lblDate setText: @""];
//    [_lblWeatherText setText: @""];
//    [_lblWeatherText setTextAlignment: NSTextAlignmentCenter];
    [_lblWeather setTextAlignment: NSTextAlignmentCenter];
    [_lblWeatherText setTextAlignment: NSTextAlignmentCenter];
    [_lblDate setNumberOfLines: 0];
//    [_btnDo setTitle: @"Update" forState: UIControlStateNormal];
//    [_btnDo setTitle: @"Update" forState: UIControlStateSelected];
//    [_btnDo setTitle: @"Update" forState: UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) doThis: (id)sender {
    NSURL *url = [[NSURL alloc] initWithString:@"http://query.yahooapis.com/v1/public/yql?q=select%20item%20from%20weather.forecast%20where%20woeid%20%3D%20834463&format=json"];
    
    NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary *forecasting = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
    NSString *weather = forecasting[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"];
    long nWeather = [weather intValue];
    
    [_lblWeather setText: [NSString stringWithFormat: @"%@ F", weather]];
    if (nWeather < 32) {
        [_lblWeather setTextColor: [UIColor blueColor]];
    } else if (nWeather > 32) {
        [_lblWeather setTextColor: [UIColor redColor]];
    }
    
    [_lblDate setText: [NSString stringWithFormat: @"%@ %@ %@",
                        forecasting[@"query"][@"results"][@"channel"][@"item"][@"title"],
                        forecasting[@"query"][@"results"][@"channel"][@"item"][@"forecast"][0][@"day"],
                        forecasting[@"query"][@"results"][@"channel"][@"item"][@"forecast"][0][@"date"]]];
    [_lblWeatherText setText: forecasting[@"query"][@"results"][@"channel"][@"item"][@"forecast"][0][@"text"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
