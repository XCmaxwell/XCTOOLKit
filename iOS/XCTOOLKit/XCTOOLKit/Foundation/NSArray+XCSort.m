//
//  NSArray+XCSort.m
//  XCTOOLKit
//
//  Created by MINI-01 on 2021/12/2.
//

#import "NSArray+XCSort.h"
#import "NSString+Extension.h"

static NSString *pinyinKey = @"pinyinKey";
static NSString *objectKey = @"objectKey";

@implementation NSArray (XCSort)

- (NSMutableArray *)sortArrayByNormalKeyPath:(NSString *)sortkey {
    if (self.count <= 1) {
        return [self mutableCopy];
    }
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self];
    [tmpArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (sortkey.length == 0) {
            return [obj1 compare:obj2];
        } else {
            return [[obj1 valueForKeyPath:sortkey] compare:[obj2  valueForKeyPath:sortkey]];
        }
    }];
    return tmpArray;
}

- (NSMutableArray *)sortArrayByPinyinKeyPath:(NSString *)sortkey bFirstCharactor:(BOOL)bFirst {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:self.count];
    for (int i = 0; i < self.count; ++i) {
        NSString *chineseString = (sortkey == nil) ? self[i] : [self[i] valueForKeyPath:sortkey];
        chineseString = bFirst?[NSString firstCharactor:chineseString]:[NSString chineseToPinyin:chineseString];
        [tmpArray addObject:@{objectKey: self[i], pinyinKey: chineseString}];
    }
    [tmpArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[pinyinKey] compare:obj2[pinyinKey]];
    }];
    return [tmpArray valueForKey:objectKey];
}

@end
