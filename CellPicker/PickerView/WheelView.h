//
//  WheelView.h
//  CellPicker
//
//  Created by Xchobo on 2014/3/18.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WheelViewDelegate;

@interface WheelView : UIView <UIGestureRecognizerDelegate>{
    
    NSMutableArray *_views;                      //儲存 view 的順序；
    NSMutableArray *_viewsAngles;                //儲存 view 的角度；
    NSMutableArray *_originalPositionedViews;    //儲存資料，後續讀取時使用；
    NSInteger viewsNum;                       //view的數量；
        
    BOOL toDescelerate;
    
    BOOL toRearrange;
    
    NSInteger currentIndex;
}

@property (nonatomic,assign) NSObject<WheelViewDelegate> *delegate;
@property (nonatomic) int idleDuration;


- (void)reloadData;

@end

@protocol WheelViewDelegate

@required

- (NSInteger)numberOfRowsOfWheelView:(WheelView *)wheelView;
- (UIView *)wheelView:(WheelView *)wheelView viewForRowAtIndex:(int)index;
- (float)rowWidthInWheelView:(WheelView *)wheelView;
- (float)rowHeightInWheelView:(WheelView *)wheelView;

@optional

- (void)wheelViewDidScroller:(WheelView *)wheelView;
- (void)wheelView:(WheelView *)wheelView didSelectedRowAtIndex:(NSInteger)index;

@end