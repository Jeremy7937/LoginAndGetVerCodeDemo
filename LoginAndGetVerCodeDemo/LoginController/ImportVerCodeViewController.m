//
//  ImportVerCodeViewController.m
//  LoginAndGetVerCodeDemo
//
//  Created by 郭凯 on 2017/12/19.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import "ImportVerCodeViewController.h"
#import "ImportVerCodeView.h"
#import "Define.h"
#import <Masonry.h>

@interface ImportVerCodeViewController ()
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) ImportVerCodeView *verCodeView;
@end

NSString *const ImportVerCodeVcChangeMobileNotification = @"ImportVerCodeVcChangeMobileNotification";

@implementation ImportVerCodeViewController

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [_backBtn setTitle:@"返回修改手机号" forState:UIControlStateNormal];
        [_backBtn setTitleColor:kSetRGBColor(74, 74, 74) forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (ImportVerCodeView *)verCodeView {
    if (!_verCodeView) {
        _verCodeView = [[ImportVerCodeView alloc] initWithFrame:CGRectMake(30, 200, self.view.bounds.size.width-60, 40)];
        
    }
    return _verCodeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加View
    [self.view addSubview:self.backBtn];
    //添加输入验证码View
    [self.view addSubview:self.verCodeView];
    //添加约束
    [self addContraints];
}

- (void)addContraints {
    //返回按钮添加约束
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64-37);
        make.left.offset(15);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark -- Clicked Action
- (void)backBtnClicked:(UIButton *)btn {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ImportVerCodeVcChangeMobileNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
