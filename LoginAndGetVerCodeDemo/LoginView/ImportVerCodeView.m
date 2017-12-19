//
//  ImportVerCodeView.m
//  PlamExam
//
//  Created by 郭凯 on 2017/12/15.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import "ImportVerCodeView.h"
#import "Define.h"
#import <Masonry.h>

static const NSInteger kTextFieldBaseTag = 200;

@interface ImportVerCodeView()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *textFieldsArr;   //存放 textField 最后获取验证码
@end

@implementation ImportVerCodeView

- (NSMutableArray *)textFieldsArr {
    if (!_textFieldsArr) {
        _textFieldsArr = [NSMutableArray array];
    }
    return _textFieldsArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat textFieldSpace = 20;
    CGFloat textFieldW = (self.bounds.size.width-20*3)/4.0f;
    for (NSInteger i = 0; i < 4; i++) {
        //添加textField
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((textFieldSpace+textFieldW)*i, 0, textFieldW, 30)];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:22];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = @" ";
        textField.tag = kTextFieldBaseTag + i;
        textField.delegate = self;
        [self addSubview:textField];
        [self.textFieldsArr addObject:textField];
        
        //添加遮罩 防止手动点击textField
        UILabel *shadeLabel = [[UILabel alloc] initWithFrame:textField.frame];
        shadeLabel.backgroundColor = [UIColor clearColor];
        shadeLabel.userInteractionEnabled = YES;
        [self addSubview:shadeLabel];
        
        if (i == 0) {
            [textField becomeFirstResponder];
        }
        
        //添加textField 下划线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(textField.frame)+5, textFieldW, 1)];
        lineLabel.backgroundColor = kSetRGBColor(224, 224, 224);
        [self addSubview:lineLabel];
    }
}

- (NSString *)getVerCode {
    NSString *verCode = @"";
    for (UITextField *textField in self.textFieldsArr) {
        verCode = [verCode stringByAppendingString:textField.text];
    }
    return verCode;
}

#pragma mark -- UITextFieldText
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果textField操作之前数据是字符串空格 并且操作之后textField.text为空 说明是删除了一个code 则选中前一个textField
    if ([textField.text isEqualToString:@" "] &&
        [string isEqualToString:@""]) {
        
        NSInteger prevTextFieldTag = textField.tag - 1;
        UITextField *prevTextField = (UITextField *)[self viewWithTag:prevTextFieldTag];
        [prevTextField becomeFirstResponder];
    }
    
    return YES;
}

//textFieldDidChange 这个方法 主要是 为了判断输入的新值进行选中下一个textField
- (void)textFieldDidChange:(NSNotification *)note {

    UITextField *textField = (UITextField *)note.object;
    //text.length>1 表示输入了新内容 此时去掉 之前的空格
    if (textField.text.length > 1) {
        textField.text = [textField.text substringFromIndex:1];
    }
    
    //当输入的是最后一个textField 并且 textField.text != nil 表示 输入完成
    if (textField.tag == kTextFieldBaseTag + 3 &&
        textField.text.length) {
        //依次遍历数组获取验证码
        NSString *verCode = [self getVerCode];
        NSLog(@"_____输入的验证码是 %@",verCode);
        [[[UIAlertView alloc] initWithTitle:@"验证码" message:verCode delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];

        return;
    }
    
    //如果 textField.text 为空时 表示删除一个code 此时 添加 一个空格 根据删除空格 在代理方法中进行判断跳转前一个textField
    if (!textField.text.length) {
        textField.text = @" ";
    }else {
        //如果textField.text 不为空 表示输入了一个code 选中下一个textField
        NSInteger nextTextFieldTag = textField.tag + 1;
        UITextField *nextTextField = (UITextField *)[self viewWithTag:nextTextFieldTag];
        [nextTextField becomeFirstResponder];
    }
    
}

@end
