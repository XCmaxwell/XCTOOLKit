//
//  XCPanDirectionGestureRecognizer.m
//  XCTOOLKit
//
//  Created by MINI-01 on 2021/11/29.
//

#import "XCPanDirectionGestureRecognizer.h"

@implementation XCPanDirectionGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action direction:(XCPanDirection)panDirection {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.panDirection = panDirection;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity =  [self velocityInView:self.view];
        switch (_panDirection) {
            case XCPanDirectionHorizontal:
                if (fabs(velocity.y) > fabs(velocity.x)) {
                    self.state = UIGestureRecognizerStateCancelled;
                }
                break;
            case XCPanDirectionVertical:
                if (fabs(velocity.x) > fabs(velocity.y)) {
                    self.state = UIGestureRecognizerStateCancelled;
                }
                break;
            default:
                break;
        }
    }

}

@end
