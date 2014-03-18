//
//  WheelView.m
//  CellPicker
//
//  Created by Xchobo on 2014/3/18.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import "WheelView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WheelView

@synthesize delegate=_delegate;
@synthesize idleDuration=_idleDuration;

- (void)initialize{
    
    self.layer.masksToBounds = YES;
    
    self.layer.opaque = NO;
    
    currentIndex=0;
    
    CATransform3D theTransform = self.layer.sublayerTransform;
    
    theTransform.m34 = -0.001;
    
    self.layer.sublayerTransform = theTransform;
    
    _views = [[NSMutableArray alloc] init];
    
    _viewsAngles = [[NSMutableArray alloc] init];
    
    _originalPositionedViews = [[NSMutableArray alloc] init];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panwheel:)];
    
    gesture.delegate = self;
    
    [self addGestureRecognizer:gesture];
    
    [self loadViews];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;{
    
    return NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initialize];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self initialize];
        
    }
    return self;
    
    
}

- (void)reloadData{
    
    [self loadViews];
}

- (void)loadViews{
    
    [_views removeAllObjects];
    
    [_viewsAngles removeAllObjects];
    
    for (UIView *__view in self.subviews) {
        
        [__view removeFromSuperview];
    }
    
    viewsNum = [_delegate numberOfRowsOfWheelView:self];
    
    for (int index = 0; index < viewsNum; index++) {
        
        UIView *__view = [_delegate wheelView:self viewForRowAtIndex:index];
        
        [self addSubview:__view];
        
        [_views addObject:__view];
        
        [_originalPositionedViews addObject:__view];
        
        float rowWidth = [_delegate rowWidthInWheelView:self];
        
        float rowHeight = [_delegate rowHeightInWheelView:self];
        
        __view.frame = CGRectMake((self.bounds.size.width - rowWidth) / 2.0, 0, rowWidth, rowHeight);
        
        [self layoutView:__view atIndex:index animated:NO duration:0];
        
    }
    
}


// view 的相關排列組合
- (void)layoutView:(UIView *)__view atIndex:(int)index animated:(BOOL)animated duration:(double)duration{
    
    
    const double dAngle = M_PI / 9;
    
    NSInteger _index = [_originalPositionedViews indexOfObject:__view];
    
    double angle = 0.0;
    
    
    angle=(index - currentIndex)*dAngle;
    
    if (fabs(angle)<M_PI/2.0) {
        __view.hidden=NO;
    }
    else{
        
        __view.hidden=YES;
    }
    
    if (_index< [_viewsAngles count]) {
        
        [_viewsAngles replaceObjectAtIndex:_index withObject:[NSNumber numberWithDouble:angle]];
        
    }else{
        
        [_viewsAngles addObject:[NSNumber numberWithDouble:angle]];
    }
    
    double y = 0.0;
    y = self.bounds.size.height / 2.0 + self.bounds.size.height / 2 * sin(angle);
    
    void(^changeLayerLayout)(void) = ^(void) {
        __view.layer.position = CGPointMake(__view.layer.position.x,y);
        __view.layer.transform=CATransform3DMakeRotation(-angle, 1.0, 0.0, 0.0);
        
        if (index == currentIndex) {
            
            if ([_delegate respondsToSelector:@selector(wheelView:didSelectedRowAtIndex:)]) {
                
                [_delegate wheelView:self didSelectedRowAtIndex:[_originalPositionedViews indexOfObject:__view]];
            }
            
        }
        else{
            
        }
        
    };
    
    if (animated) {
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:changeLayerLayout completion:^(BOOL finished){}];
        
        CABasicAnimation *theAnimation;
        theAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
        theAnimation.duration = duration;
        theAnimation.removedOnCompletion = YES;
        [__view.layer addAnimation:theAnimation forKey:@"theAnimation"];
        
    }else{
        
        changeLayerLayout();
        
    }
}

- (void)layoutView:(UIView *)__view byAngle:(double)angle animated:(BOOL)animated duration:(double)duration{
    
    
    NSInteger _index = [_originalPositionedViews indexOfObject:__view];
    
    double _angle = [[_viewsAngles objectAtIndex:_index] doubleValue] +angle;
    if (fabs(_angle)<M_PI/2.0) {
        __view.hidden=NO;
    }
    else{
        
        __view.hidden=YES;
    }
    
    [_viewsAngles replaceObjectAtIndex:_index withObject:[NSNumber numberWithDouble:_angle]];
    
    double z = -self.bounds.size.height / 2.0 + self.bounds.size.height / 2.0 * cos(fabs(_angle));
    
    
    double y = self.bounds.size.height / 2.0 + self.bounds.size.height / 2.0 * sin(_angle);
    
    
    void(^changeLayerLayout)(void) = ^(void) {
        
        __view.layer.position = CGPointMake(__view.layer.position.x,y);
        
        __view.layer.zPosition = z;
        
        __view.layer.transform=CATransform3DMakeRotation(-_angle, 1.0, 0.0, 0.0);
        
    };
    
    if (animated) {
        
        NSLog(@"111");
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:changeLayerLayout completion:^(BOOL finished){}];
        
        CABasicAnimation *theAnimation;
        theAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
        theAnimation.duration = duration;
        theAnimation.removedOnCompletion = YES;
        [__view.layer addAnimation:theAnimation forKey:@"theAnimation"];
        
    }else{
        
        changeLayerLayout();
        
    }
    
}

#pragma mark 开始拖动；
- (void)panwheel:(UIPanGestureRecognizer *)gesture{
    
    UIGestureRecognizerState state = [gesture state];
    CGPoint velocity = [gesture velocityInView:self];
    toDescelerate = state == UIGestureRecognizerStateEnded && fabs(velocity.y) > 950;
    toRearrange = state==UIGestureRecognizerStateEnded && fabs(velocity.y) < 950;
    
    if ([_views count] > 0) {
        
        [self animateViewsWithVelocity:[NSNumber numberWithDouble:velocity.y]];
    }
}

- (void)animateViewsWithVelocity:(NSNumber *)velocity{
    
    if ([_delegate respondsToSelector:@selector(wheelViewDidScroller:)]) {
        [_delegate wheelViewDidScroller:self];
    }
    
    if ([velocity doubleValue] != 0) {
        
        static double angle = 0;
        
        double _dAngle = [velocity doubleValue] * M_PI / 9 / self.bounds.size.height / 10;
        
        angle += _dAngle;
        
        const double dAngle = M_PI / 9;
        
        double duration = 0;
        
        BOOL rearrange = toRearrange || (toDescelerate && fabs([velocity doubleValue]) <= 1);
        
//        NSLog(@"rearrange:%d",rearrange);
        
        if (fabs(angle / dAngle) >0.9 || rearrange) {
            
            if (fabs(angle / dAngle) >0.9 ) {
                
//                NSLog(@"fab:%f",angle / dAngle);
                duration = rearrange ? 0.25 * (1.0 - fabs(angle / dAngle)) : 0;
                
                if ([velocity doubleValue]<0) {
                    
                    if (currentIndex<viewsNum-1) {
                        
                        currentIndex=currentIndex + 1;
                        
                    }
                }
                else
                {
                    if (currentIndex>0) {
                        
                        currentIndex=currentIndex -1;
                    }
                }
            }
            
//            NSLog(@"currentindex:%d",(int)currentIndex);
            if (rearrange) {
                for (int index = 0; index < viewsNum; index++) {
                    
                    UIView *__view = [_views objectAtIndex:index];
                    
                    [self layoutView:__view atIndex:index animated:rearrange  duration:duration];
                }
                
            }
            
            angle = 0;
            
        }else {
            
            duration = 0;
            
            for (int index = 0; index < viewsNum; index++) {
                
                UIView *__view = [_views objectAtIndex:index];
                
                [self layoutView:__view byAngle:_dAngle animated:NO duration:duration];
            }
            
        }
        
        if(toDescelerate && fabs([velocity doubleValue]) > 1){
            [self performSelector:@selector(animateViewsWithVelocity:) withObject:[NSNumber numberWithDouble:[velocity doubleValue] / 2.9] afterDelay:duration];
        }
    }
}


@end


