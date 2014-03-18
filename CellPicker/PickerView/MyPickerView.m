//
//  MyPickerView.m
//  CellPicker
//
//  Created by Xchobo on 2014/3/18.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import "MyPickerView.h"

@interface MyPickerView()

@property (nonatomic, retain)NSMutableArray *tables;


- (void)addContent;
- (void)removeContent;

//回傳第 n 個群組
- (NSInteger)componentFromWheelView:(WheelView*)wheelView;

@end

@implementation MyPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        if(loop == nil){
            loop = [[MagnifierView alloc] init];
            loop.viewToMagnify = self;
            [self setBackgroundColor:[UIColor colorWithRed:0.933 green:0.942 blue:0.833 alpha:1.000]];
        }
        // Initialization code
    }
    return self;
}

- (void)addloop
{
    [self.superview addSubview:loop];
    
}

- (void)update{
    
    [self removeContent];
    [self addContent];
    
    [self performSelector:@selector(addloop) withObject:nil afterDelay:0.2];
    loop.touchPoint=CGPointMake(160, 108);
    [loop setNeedsDisplay];
}

#pragma mark - Content

- (void)addContent{
    
    const NSInteger components = [self numberOfComponents];
    
    _tables=[[NSMutableArray alloc] init];
    
    CGRect tableFrame = CGRectMake(0, 0, 0, self.bounds.size.height);
    for (NSInteger i = 0; i<components; ++i) {
        
        tableFrame.size.width = self.frame.size.width/components;
        
        WheelView *wheelview=[[WheelView alloc] initWithFrame: tableFrame];
        wheelview.delegate = self;
        [wheelview reloadData];
        wheelview.idleDuration = 0;
        [self addSubview:wheelview];
        [self.tables addObject:wheelview];
        
        tableFrame.origin.x += tableFrame.size.width;
    }
    
}

- (void)removeContent
{
    for (WheelView *table in self.tables) {
        [table removeFromSuperview];
    }
    self.tables = nil;
    
}

-(void) reloadData{
    
    for (WheelView *table in self.tables) {
        [table reloadData];
    }
}


-(void) reloadDataInComponent:(NSInteger)component{
    
    [[self.tables objectAtIndex:component] reloadData];
}

#pragma mark WheelViewDelegate

- (NSInteger)numberOfRowsOfWheelView:(WheelView *)wheelView{
    NSInteger component = [self componentFromWheelView:wheelView];
    return [self numberOfRowsInComponent:component];
}

- (UIView *)wheelView:(WheelView *)wheelView viewForRowAtIndex:(int)index{
    NSInteger component = [self componentFromWheelView:wheelView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.text=[self setDataForRow:index inComponent:component];
    
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    return label ;
}

- (float)rowWidthInWheelView:(WheelView *)wheelView{
    
    return 300;
}

- (float)rowHeightInWheelView:(WheelView *)wheelView{
    
    return 30;
}

- (void)wheelView:(WheelView *)wheelView didSelectedRowAtIndex:(NSInteger)index
{
    NSInteger component = [self componentFromWheelView:wheelView];
    if([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]){
         [self.delegate pickerView:self didSelectRow:index inComponent:component];
    }
}

#pragma mark 
- (void)wheelViewDidScroller:(WheelView *)wheelView
{
    loop.touchPoint=CGPointMake(160, 108);
    [loop setNeedsDisplay];
}


#pragma mark - get dataSourse;
//
- (NSInteger) numberOfComponents
{
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [self.dataSource numberOfComponentsInPickerView:self];
    }
    return 1;
}
// 群組
- (NSInteger) numberOfRowsInComponent:(NSInteger)component
{
    if ([self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}
// 設定每一行資料
- (NSString *)setDataForRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        return [self.delegate pickerView:self titleForRow:row forComponent:component];
    }
    return @"";
}

#pragma mark - Other methods

// 取得目前群組
- (NSInteger)componentFromWheelView:(WheelView *)wheelView
{
    return [self.tables indexOfObject:wheelView];
}


@end
