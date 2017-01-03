//
//  LLZGuideView.m
//  Smart_DEMO
//
//  Created by locklight on 17/1/2.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "LLZGuideView.h"
#import "Masonry.h"

@interface LLZGuideView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation LLZGuideView

#pragma mark  重写set方法设置滚动视图子控件
- (void)setImageNames:(NSArray *)imageNames{
    //将控制器传入的数据赋值给属性
    _imageNames = imageNames;
    
    //定义滚动视图的宽高
    CGFloat scrollViewW = self.bounds.size.width;
    CGFloat scrollViewH = self.bounds.size.height;
    
    //for循环创建滚动条子控件imageView
    for (NSInteger i = 0; i < imageNames.count; i++) {
        //创建imageView
        UIImageView *imageView= [[UIImageView alloc]init];
        //根据控制器传来的图片名称获取图片文件路径
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNames[i] ofType:@"jpg"];
        //通过路径加载图片
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        //给图窗设置图片
        imageView.image = image;
        
        //设置imageView的大小及位置
        imageView.frame = CGRectMake(scrollViewW * i, 0, scrollViewW, scrollViewH);
        //添加到滚动视图上
        [_scrollView addSubview:imageView];
        
        //将按钮添加到imageView上
        [self makeMoreBtn:imageView];
        
        //设置imageView可交互
        imageView.userInteractionEnabled = YES;
    }
        //设置scrollView滚动范围
        _scrollView.contentSize = CGSizeMake((imageNames.count +1) * scrollViewW, 0);
        //设置分页指示器点个数
        _pageControl.numberOfPages = imageNames.count;
    
}

//重写控件初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        //添加scrollView
        [self makeScrollView];
        
        //创建分页显示器
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        _pageControl = pageControl;
        //添加至父控件(与scrollView同级关系)
        [self addSubview:pageControl];
        //默认第一页
        pageControl.currentPage = 0;
        //设置当前页点颜色
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        //设置非当前页点颜色
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        
        //设置分页显示器约束
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-20);
            make.centerX.offset(0);
        }];
        //设置分页显示器交互
        pageControl.enabled = NO;
    }
    return self;
}


- (void)makeScrollView{
    //创建SrocllView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    //赋值给控件属性
    _scrollView = scrollView;
    //添加到父控件
    [self addSubview:scrollView];
    //添加约束
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).offset(0);
    }];
    
    //设置分页
    _scrollView.pagingEnabled = YES;
    //禁用bounces;
    _scrollView.bounces = NO;
    //关闭滚动条显示
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    
    //给滚动条设置代理监听事件
    _scrollView.delegate = self;
}

- (void)makeMoreBtn:(UIImageView *)imageView{
    //创建按钮
    UIButton *btn = [[UIButton alloc]init];
    //设置按钮图片
    [btn setImage:[UIImage imageNamed:@"common_more_black"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"common_more_white"] forState:UIControlStateHighlighted];
    //添加按钮到imageView
    [imageView addSubview:btn];
    //设置按钮大小
    [btn sizeToFit];
    //设置按钮位置
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_right).offset(-20);
        make.bottom.equalTo(imageView.mas_bottom).offset(-50);
    }];
    //给按钮添加监听事件
    [btn addTarget:self action:@selector(loadMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadMoreBtnClick:(UIButton *)btn{
    //隐藏当前点击按钮
    btn.hidden = YES;
    //点击方法按钮的父控件,并慢慢透明
    [UIView animateWithDuration:1.0 animations:^{
        btn.superview.transform =  CGAffineTransformMakeScale(2, 2);
        btn.superview.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark 代理方法 响应滚动条的操作
//滚动时调用方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //新页面 = 当前视图偏移X是否超过自身的一半
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width  + 0.4999999 ;
    _pageControl.currentPage = page;
    //显示页超出当前滚动视图contentsize,隐藏分页显示器
    _pageControl.hidden = (_imageNames.count == page);
    
    scrollView.tag = page;
}
//滚动停止调用方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == _imageNames.count) {
        [self removeFromSuperview];
    }
}
@end
