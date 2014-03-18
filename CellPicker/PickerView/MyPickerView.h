//
//  MyPickerView.h
//  CellPicker
//
//  Created by Xchobo on 2014/3/18.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WheelView.h"           //滾輪
#import "MagnifierView.h"       //放大
@protocol MyPickerViewDataSource;
@protocol MyPickerViewDelegate;

@interface MyPickerView : UIView
<WheelViewDelegate>
{
    
    CGFloat centralRowOffset;
    
    MagnifierView *loop;

}

@property (nonatomic, assign) id<MyPickerViewDelegate> delegate;
@property (nonatomic, assign) id<MyPickerViewDataSource> dataSource;

@property (nonatomic, retain)UIColor *fontColor;

- (void)update;

- (void)reloadData;

- (void)reloadDataInComponent:(NSInteger)component;

@end

@protocol MyPickerViewDataSource <NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(MyPickerView *)pickerView;

- (NSInteger)pickerView:(MyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@protocol MyPickerViewDelegate <NSObject>

@optional

- (CGFloat)pickerView:(MyPickerView *)pickerView widthForComponent:(NSInteger)component;

- (NSString *)pickerView:(MyPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerView:(MyPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


@end


