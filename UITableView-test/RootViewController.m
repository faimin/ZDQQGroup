//
// RootViewController.m
// UITableView-test
//
// Created by 符现超 on 14-5-16.
// Copyright (c) 2014年 符现超. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 解析数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListData" ofType:@"plist"];

    _dic  = [[NSDictionary alloc] initWithContentsOfFile:path];

    _keys = [_dic allKeys];

    // 排序
    _keys = [_keys sortedArrayUsingSelector:@selector(compare:)];

    // 创建表视图
    _tableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.rowHeight  = 44;
    [self.view addSubview:_tableView];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dic = NSDictionaryOfVariableBindings(_tableView);
    NSString *vf1 = @"H:|[_tableView]|";
    NSString *vf2 = @"V:|[_tableView]|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vf1 options:0 metrics:nil views:dic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vf2 options:0 metrics:nil views:dic]];
    
    _tableView.tableFooterView = [UIView new];

    // 创建好友列表状态数组
    _showArray = [[NSMutableArray alloc] initWithCapacity:_keys.count];

    for (int i = 0; i < _keys.count; i++)
    {
        _showArray[i] = @NO;
    }
} /* viewDidLoad */

#pragma mark -- UITableViewDelegate
// 一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _keys.count;
}

// 每组的行数
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
// NSString *key=[_keys objectAtIndex:section];
// NSArray *values=[_dic objectForKey:key];
// return [values count];

    BOOL isShow = [[_showArray objectAtIndex:section] boolValue];

    if (isShow)
    {
        NSString *key   = _keys[section];
        NSArray  *array = [_dic objectForKey:key];
        return array.count;
    }
    else
    {
        return 0;
    }
} /* tableView */

// 每行的内容
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == Nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }


    NSString *key   = [_keys objectAtIndex:indexPath.section];
    NSArray  *array = [_dic objectForKey:key];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    // 每行右边的图标
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;

    UIImageView *imageView = [[UIImageView alloc] init];
    [cell addSubview:imageView];

    return cell;
} /* tableView */

// 设置组标题的高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

// 设置组标题
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_keys objectAtIndex:section];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.frame           = CGRectMake(0, 2, 320, 40);
    button.backgroundColor = [UIColor purpleColor];

    // 设置标题
    NSString *title = [_keys objectAtIndex:section];
    [button setTitle:title forState:UIControlStateNormal];


    // 设置点击事件
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    button.tag = section;

    return button;
} /* tableView */

#pragma mark - UIButton Action

- (void)buttonAction:(UIButton*)button
{
    BOOL isShow = [[_showArray objectAtIndex:button.tag] boolValue];

    // 改变原有的状态
    _showArray[button.tag] = [NSNumber numberWithBool:!isShow];

    // 刷新表视图
    [_tableView reloadData];
}

// ------------------------------设置右侧滑动条------------------------------
// 右侧要显示的内容
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return _keys;
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    NSInteger count = 0;

    for (NSString *key in _keys)
    {
        if ([key isEqualToString:title])
        {
            return count;
        }
        count++;
    }
    return count;
} /* tableView */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
