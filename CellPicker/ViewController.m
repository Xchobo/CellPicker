//
//  ViewController.m
//  CellPicker
//
//  Created by Xchobo on 2014/3/18.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import "ViewController.h"
#import "MyPickerView.h"

// 定義資料筆數
#define DATANUM 5

@interface ViewController ()
<UITableViewDataSource, UITableViewDelegate, MyPickerViewDataSource, MyPickerViewDelegate>
{
    BOOL ShowPicker;
    NSIndexPath *ShowIndex;
    
    UITableView *tableview;
    MyPickerView *typePicker;
    NSMutableArray *sectionName;
    NSInteger cellNumber;  //資料筆數
    
    NSString *getStr;
}

@end


@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellNumber;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ShowPicker && [indexPath isEqual:ShowIndex] ) {
        
        static NSString *Cellid=@"Cell";
        
        UITableViewCell *cell1=[tableview dequeueReusableCellWithIdentifier:Cellid];
        if (cell1==nil) {
            cell1=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellid];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell1.contentView addSubview:typePicker];
        NSLog(@"Cellid");
        return cell1;
        
    }
    else{
        NSString *CELL =[ NSString stringWithFormat:@"cellid %d",(int)indexPath.row];
        
        UITableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:CELL];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.tag=indexPath.row;
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        if (cell.textLabel.text ==nil) {
            cell.textLabel.text = @"點選可設定油品";
        }
        NSLog(@"Cell");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ShowPicker&&[indexPath isEqual:ShowIndex]) {
        return 216.0f;
    }
    return 40.0f;
}


//顯示 pickerView
- (void)insertRow:(NSIndexPath *)indexPath{
    ShowPicker=YES;
    
    [typePicker update];
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
    NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:0];
    ShowIndex=indexPathToInsert;
    
    [rowToInsert addObject:indexPathToInsert];
    
    cellNumber = (DATANUM + 1);
    [tableview beginUpdates];
    
    [tableview insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    [tableview endUpdates];
    
}

// 隱藏 pickerView
- (void)deleteRow:(NSIndexPath *)RowtoDelete{
    ShowPicker=NO;
    NSMutableArray* rowToDelete = [[NSMutableArray alloc] init];
    NSIndexPath* indexPathToDelete = ShowIndex;
    
    [rowToDelete addObject:indexPathToDelete];
    cellNumber = DATANUM;
    
    [tableview beginUpdates];
    [tableview deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationTop];
    [tableview endUpdates];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( !ShowPicker ) {
        [self insertRow:indexPath];
    }
    else if(ShowPicker&&([[NSIndexPath indexPathForRow:(ShowIndex.row-1) inSection:0] isEqual:indexPath])){
        [self deleteRow:indexPath];
    }
    else if ([ShowIndex isEqual:indexPath]&&ShowPicker){
        NSLog(@"點選 picker = %@", getStr);
        
        UITableViewCell *oneCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(ShowIndex.row-1) inSection:0]];
        oneCell.textLabel.text = getStr;
    }
    else if(ShowIndex&&![[NSIndexPath indexPathForRow:(ShowIndex.row-1) inSection:0] isEqual:indexPath]){
        [self deleteRow:indexPath];
    }
}

#pragma mark MyPickerViewDelegate
- (void)pickerView:(MyPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"title:%@", [sectionName objectAtIndex:row]);
    getStr = [sectionName objectAtIndex:row];
}


- (NSInteger)numberOfComponentsInPickerView:(MyPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(MyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [sectionName count];
}

- (NSString *)pickerView:(MyPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [sectionName objectAtIndex:row];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ShowPicker = NO;
    ShowIndex = [NSIndexPath indexPathForRow:100 inSection:100];
    cellNumber = DATANUM;
    sectionName=[[NSMutableArray alloc] initWithObjects:@"椰子油",@"棕櫚油",@"橄欖油",@"芥花油",@"酪梨油",@"米糠油",@"乳木果油",@"蓖麻油",@"可可脂", nil];
    if (typePicker == nil) {
        typePicker = [[MyPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        typePicker.delegate = self;
        typePicker.dataSource=self;
    }
    
    tableview=[[UITableView alloc] initWithFrame:CGRectMake( 0, 0,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    [self.view addSubview:tableview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
