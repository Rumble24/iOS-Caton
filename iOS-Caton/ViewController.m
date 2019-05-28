//
//  ViewController.m
//  iOS-Caton
//
//  Created by 王景伟 on 2019/5/24.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "ViewController.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    id  str = nil;
    
//    NSDictionary *dic = @{@"11":str};
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *cellText = nil;
    if (indexPath.row%10 == 0)
    {
        usleep(200*1000);
        cellText = @"我需要一些时间";
    }else
    {
        cellText = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    }
    
    cell.textLabel.text = cellText;
    return cell;
}


@end
