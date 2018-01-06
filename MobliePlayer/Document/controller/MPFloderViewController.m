//
//  MPFloderViewController.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/24.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPFloderViewController.h"
#import "UIViewController+YYAdd.h"
#import "MPPlayerController.h"

@interface MPFloderViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;
/** <#name#> */
@property (strong,nonatomic) NSMutableArray *dataArray;
@end

@implementation MPFloderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}  //关闭自动偏移
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];

    if (_locationStr.length > 0) {
        [self add_navigation_back_button];
        
        [self setCustomNavigationTitle:[_locationStr componentsSeparatedByString:@"/"].lastObject];
    }
    [self.tableView reloadData];
}
- (NSString *)dataFilePath{
    if (_locationStr.length == 0 || _locationStr == nil) {
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        _locationStr = NSHomeDirectory();
                _locationStr = [paths firstObject];
    }
    return _locationStr;
}
#pragma mark - 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSError *error = nil;
        NSFileManager* fm= [NSFileManager defaultManager];
        NSArray *files = [fm contentsOfDirectoryAtPath:[self dataFilePath] error:&error];//[fm subpathsAtPath: [self dataFilePath]];
        _dataArray = [NSMutableArray arrayWithArray:files];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        //        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    if ([self isDir:indexPath.row]) {
        cell.imageView.image = [UIImage imageNamed:@"Folder"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@""];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDir:indexPath.row]) {
        MPFloderViewController * vc = [[MPFloderViewController alloc]init];
        NSString * str = [[self dataFilePath]stringByAppendingPathComponent:self.dataArray[indexPath.row]];
        vc.locationStr = str;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString * str = [[self dataFilePath]stringByAppendingPathComponent:self.dataArray[indexPath.row]];
        NSString *string = @"//.rmvb//.asf//.avi//.divx//.dv//.flv//.gxf//.m1v//.m2v//.m2ts//.m4v//.mkv//.mov//.mp2//.mp4//.mpeg//.mpeg1//.mpeg2//.mpeg4//.mpg//.mts//.mxf//.ogg//.ogm//.ps//.ts//.vob//.wmv//.a52//.aac//.ac3//.dts//.flac//.m4a//.m4p//.mka//.mod//.mp1//.mp2//.mp3//.ogg";
        NSArray * arr = [string componentsSeparatedByString:@"//"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([str containsString:obj]) {
                MPPlayerController * player = [[MPPlayerController alloc]init];
                player.videoPath = str;
                player.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:player animated:YES];
            }
        }];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (BOOL)isDir:(NSInteger)count{
    NSFileManager* fm= [NSFileManager defaultManager];
    NSString * str = [[self dataFilePath]stringByAppendingPathComponent:self.dataArray[count]];
    BOOL isDir,valid;
    valid = [fm  fileExistsAtPath:str isDirectory:&isDir];
    NSLog(@"%d   %d  %@",YES,isDir,str);
    return isDir;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
