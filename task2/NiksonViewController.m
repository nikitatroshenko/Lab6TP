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
@property (weak, nonatomic) IBOutlet UITextField *tfInput;

@end

@implementation NiksonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblWeather setTextAlignment: NSTextAlignmentCenter];
    [_lblWeatherText setTextAlignment: NSTextAlignmentCenter];
    [_lblDate setNumberOfLines: 0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTfInputEditingDidEnd:(UITextField *)sender {
    
}

- (IBAction) doThis: (id)sender {
    NSURL *getWoeId = [NSURL URLWithString:[[NSString stringWithFormat: @"http://query.yahooapis.com/v1/public/yql?q=select%%20woeid%%20from%%20geo.places%%20where%%20text%%3D%%22%@%%22&format=json",[[_tfInput text] compare: @""] == 0 ? @"minsk" : [_tfInput text]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSData *woeidQuery = [NSData dataWithContentsOfURL: getWoeId];
    NSDictionary *woeidJSONObject = [NSJSONSerialization JSONObjectWithData:woeidQuery options:NSJSONReadingMutableContainers error:nil];
    
    if (woeidJSONObject[@"query"][@"results"] == nil) return; // Avoid null results.
    
    NSString *townWoeId = woeidJSONObject[@"query"][@"results"][@"place"][0][@"woeid"];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=select%%20item%%20from%%20weather.forecast%%20where%%20woeid%%20%%3D%%20%@&format=json", townWoeId]];
    
    NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary *forecast = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
    
    if (forecast[@"query"][@"results"] == nil) return; // Avoid null results.
    
    NSString *weather = forecast[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"];
    long nWeather = [weather intValue];
    
    nWeather -= 32;
    nWeather /= 1.8;
    [_lblWeather setText: [NSString stringWithFormat: @"%ld C", nWeather]];
    if (nWeather < 0) {
        [_lblWeather setTextColor: [UIColor blueColor]];
    } else if (nWeather > 0) {
        [_lblWeather setTextColor: [UIColor redColor]];
    }
    
    [_lblDate setText: [NSString stringWithFormat: @"%@ %@ %@",
                        forecast[@"query"][@"results"][@"channel"][@"item"][@"title"],
                        forecast[@"query"][@"results"][@"channel"][@"item"][@"forecast"][0][@"day"],
                        forecast[@"query"][@"results"][@"channel"][@"item"][@"forecast"][0][@"date"]]];
    [_lblWeatherText setText: forecast[@"query"][@"results"][@"channel"][@"item"][@"forecast"][0][@"text"]];
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
