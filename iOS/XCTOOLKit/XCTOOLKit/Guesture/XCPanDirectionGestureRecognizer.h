//
//  XCPanDirectionGestureRecognizer.h
//  XCTOOLKit
//
//  Created by MINI-01 on 2021/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    XCPanDirectionVertical,
    XCPanDirectionHorizontal
} XCPanDirection;

@interface XCPanDirectionGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) XCPanDirection panDirection;

/// 自定义pan手势
/// @param target target
/// @param action action
/// @param panDirection 只允滑动的方向
- (instancetype)initWithTarget:(id)target action:(SEL)action direction:(XCPanDirection)panDirection;

@end

NS_ASSUME_NONNULL_END
