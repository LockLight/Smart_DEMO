//
//  ViewController.m
//  Smart_DEMO
//
//  Created by locklight on 17/1/2.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LLZGuideView.h"

//新特性图片个数
#define ImageCount 4
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载主界面
    [self setUpUI];
    //是否显示新特性页面
#warning mark 待添加:根据版本号判断是否加载新特性
    BOOL isShow = YES;
    if(isShow){
        [self makeGuideView];
    }
}

- (void)makeGuideView{
     //创建新界面(自定义构造)
    LLZGuideView *guideView = [[LLZGuideView alloc]initWithFrame:self.view.bounds];
    //加载图片传递给视图属性
    guideView.imageNames = [self loadData];
    //添加滚动视图到父控件
    [self.view addSubview:guideView];
}

- (NSArray *)loadData{
    //创建可变数组保存图片
    NSMutableArray *arrM = [[NSMutableArray alloc]initWithCapacity:ImageCount];
    //拼接图片名称
    for (NSInteger i = 0; i < ImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"common_h%zd",i+1];
        [arrM addObject:imageName];
    }
    return arrM.copy;
}

- (void)setUpUI{
    //创建主界面图片
    UIImageView *imageView = [[UIImageView alloc]init];
    //设置视图image
    imageView.image = [UIImage imageNamed:@"cozy-control-car"];
    //添加imageView至父控件
    [self.view addSubview:imageView];
    
    //设置图片填充模式
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //添加imageView约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
}

@end
