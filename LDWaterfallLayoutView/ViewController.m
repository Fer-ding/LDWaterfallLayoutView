//
//  ViewController.m
//  LDWaterfallLayoutView
//
//  Created by YueHui on 17/1/3.
//  Copyright © 2017年 LeapDing. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "LDWaterfallLayoutView.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) LDWaterfallLayoutView *ld_WaterfallLayoutView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"瀑布流";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 透明时用这个属性(保证collectionView 不会被遮挡, 也不会向下移)
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 不透明时用这个属性
    //self.extendedLayoutIncludesOpaqueBars = YES;
    
    //http://image.baidu.com/channel/listjson?pn=0&rn=30&tag1=美女&tag2=全部&ie=utf8
    [self.view addSubview:self.ld_WaterfallLayoutView];
    
//    [self.ld_WaterfallLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
//    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [@"http://image.baidu.com/channel/listjson?pn=0&rn=50&tag1=美女&tag2=全部&ie=utf8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *array = [responseObject[@"data"] mutableCopy];
        [array removeLastObject];
        
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            LDCellModel *model = [[LDCellModel alloc]init];
            model.imgURL = dic[@"image_url"];
            model.imgWidth = [dic[@"image_width"] floatValue];
            model.imgHeight = [dic[@"image_height"] floatValue];
            model.title = dic[@"abs"];
            
            [modelArray addObject:model];
        }
        
        self.ld_WaterfallLayoutView.dataArray = modelArray;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LDWaterfallLayoutView *)ld_WaterfallLayoutView {
    if (!_ld_WaterfallLayoutView) {
        _ld_WaterfallLayoutView = [[LDWaterfallLayoutView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
//        _ld_WaterfallLayoutView = [[LDWaterfallLayoutView alloc] init];
        _ld_WaterfallLayoutView.colCount = 2;//列数
        _ld_WaterfallLayoutView.colSpacing = 5;//列间距
        _ld_WaterfallLayoutView.rowSpacing = 5;//行间距
        _ld_WaterfallLayoutView.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _ld_WaterfallLayoutView;
}

@end
