
#import "CMTipDismissBackgroundButton.h"

@implementation CMTipDismissBackgroundButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self setTitle:@"" forState:UIControlStateNormal];
    self.toolTipTarget = NULL;
}

// in case user clicked the toolTipTarget we need to propagate that event further
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([super pointInside:point withEvent:event]) {
        if (self.toolTipTarget == NULL) {
            return TRUE;
        } else {
            CGPoint transformedPoint = [self convertPoint:point toView:self.toolTipTarget];
            if ( [self.toolTipTarget pointInside:transformedPoint withEvent:nil] ) {
                // we have to hide the toolTip anyway
                [self sendActionsForControlEvents: UIControlEventTouchUpInside];
                return FALSE;
            } else {
                return TRUE;
            }
            
        }
    } else {
        return FALSE;
    }
    
    
}

@end
