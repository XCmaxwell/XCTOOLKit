//
//  NSArray+XCSort.h
//  XCTOOLKit
//
//  Created by MINI-01 on 2021/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XCSort)

/// 根据模型的KeyPath字段排序
/// @param sortKeyPath 排序KeyPath
- (NSMutableArray *)sortArrayByNormalKeyPath:(NSString *)sortKeyPath;

/// 根据model的KeyPath字段汉字拼音排序
/// @param sortKeyPath  拼音排序KeyPath
/// @param bFirst 是否是拼音首字母
- (NSMutableArray *)sortArrayByPinyinKeyPath:(NSString *)sortKeyPath bFirstCharactor:(BOOL)bFirst;

@end

NS_ASSUME_NONNULL_END
