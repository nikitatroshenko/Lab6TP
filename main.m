//
//  main.m
//  TPLab6.1
//
//  Created by fpmi on 20.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableDictionary *statistics = [[NSMutableDictionary alloc] init];
        NSArray *words;
        NSString *nsstr_input = @"foo bar foo bar";
        
        words = [nsstr_input componentsSeparatedByString:@" "];
        for (NSString *word in words) {
            NSNumber *count = [statistics valueForKey:word];
            
            if(count == nil) {
                [statistics setValue: [NSNumber numberWithLong:1] forKey:word];
            } else {
                [statistics setValue: [NSNumber numberWithLong:([count integerValue] + 1)] forKey:word];
            }
        }
        
        NSArray *uniqueWords = [[statistics allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *a_cnt = [statistics valueForKey:a];
            NSNumber *b_cnt = [statistics valueForKey:b];
            
            return [b_cnt compare:a_cnt];
        }];
        
        NSUInteger top_cnt = 5;
        if (top_cnt > [uniqueWords count]) {
            top_cnt = [uniqueWords count];
        }
        
        NSString *word;
        for (int i = 0; i < top_cnt; i++) {
            word = [uniqueWords objectAtIndex:i];
            NSLog(@"%@:%ld", word, [[statistics valueForKey:word] integerValue]);
        }
    }
    return 0;
}
