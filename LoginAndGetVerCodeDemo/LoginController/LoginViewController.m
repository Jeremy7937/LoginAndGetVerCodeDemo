//
//  ViewController.m
//  LoginAndGetVerCodeDemo
//
//  Created by 郭凯 on 2017/12/19.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import "LoginViewController.h"
#import "ImportVerCodeViewController.h"
#import "Define.h"
#import <Masonry.h>

@interface LoginViewController ()
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UILabel *lineLabel;   //手机号 输入框 下方分割线
@property (nonatomic, strong) UIButton *revalidationBtn;  //重新验证按钮

@property (nonatomic, assign) BOOL isChangeMobile;      //是不是修改手机号 标识
@end

@implementation LoginViewController

- (UIButton *)revalidationBtn {
    if (!_revalidationBtn) {
        _revalidationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_revalidationBtn setTitle:@"重新验证" forState:UIControlStateNormal];
        [_revalidationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _revalidationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _revalidationBtn.backgroundColor = kSetRGBColor(48, 155, 242);
        _revalidationBtn.clipsToBounds = YES;
        _revalidationBtn.layer.cornerRadius = 25.0f;
        [_revalidationBtn addTarget:self action:@selector(reloadVerCode) forControlEvents:UIControlEventTouchUpInside];
        _revalidationBtn.hidden = YES;
    }
    return _revalidationBtn;
}

- (UITextField *)mobileTextField {
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.borderStyle = UITextBorderStyleNone;
        _mobileTextField.font = [UIFont systemFontOfSize:20];
        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.placeholder = @"请输入手机号";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:_mobileTextField];
        
    }
    return _mobileTextField;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = kSetRGBColor(204, 204, 204);
    }
    return _lineLabel;
}

//添加约束
- (void)addContraints {
    //添加 手机号输入框 约束
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(280);
    }];
    
    //添加 手机号 输入框下方分割线 约束
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(5);
    }];
    
    //添加重新获取验证的按钮
    [self.revalidationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(50);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(60);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
    //添加View
    [self.view addSubview:self.mobileTextField];
    [self.view addSubview:self.lineLabel];
    [self.view addSubview:self.revalidationBtn];
    //添加约束
    [self addContraints];
    
    //添加 修改手机号 监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMobile:) name:ImportVerCodeVcChangeMobileNotification object:nil];

}

//获取验证码
- (void)loadVerCode {
    NSLog(@"————————获取验证码");
    ImportVerCodeViewController *importVerCodeVc = [[ImportVerCodeViewController alloc] init];
    [self.navigationController pushViewController:importVerCodeVc animated:YES];
}

#pragma mark -- 通知调用的方法
//重新回到这个页面时 调用的方法
- (void)changeMobile:(NSNotification *)note {
    [self.mobileTextField becomeFirstResponder];
    self.isChangeMobile = YES;
    self.revalidationBtn.hidden = NO;
}

//输入框 内容发生变化 时会调用
- (void)textFieldDidChange {
    
    NSString *text = self.mobileTextField.text;
    //只有第一次 输入完 手机号之后 进行自动跳转 重新获取验证码时 isChangeMobile = YES
    if ([self isPhoneNum:text] &&
        !self.isChangeMobile) {
        
        [self loadVerCode];
    }
    //输入超过 11位
    if (text.length > 11) {
        _mobileTextField.text = [text substringToIndex:11];
    }
}

//简单判断 是不是手机号
- (BOOL)isPhoneNum:(NSString *)mobile {
    if (mobile.length != 11) {
        return NO;
    }
    
    if ([[mobile substringToIndex:1] isEqualToString:@"1"]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark -- Action Clicked
//重新验证按钮被点击
- (void)reloadVerCode {
    
    [self loadVerCode];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mobileTextField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
