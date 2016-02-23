//
//  RootViewController.h
//  UITableView-test
//
//  Created by 符现超 on 14-5-16.
//  Copyright (c) 2014年 符现超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_keys;
    NSDictionary *_dic;


    NSMutableArray *_showArray;
    
    UITableView *_tableView;
}


@end
