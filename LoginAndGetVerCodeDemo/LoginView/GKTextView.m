//
//  GKTextView.m
//  GKTextViewDemo
//
//  Created by 郭凯 on 2017/11/6.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import "GKTextView.h"

#define kCoverViewTag 201

@interface GKTextView()
@property (nonatomic, strong) NSMutableAttributedString *contentAttributed;
@property (nonatomic, strong) NSMutableArray *rectsArr;
@end

@implementation GKTextView

- (NSMutableArray *)rectsArr {
    if (!_rectsArr) {
        _rectsArr = [NSMutableArray array];
    }
    return _rectsArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //初始化设置 textView 不能编辑 和不能滚动
        self.editable = NO;
        self.scrollEnabled = NO;
    }
    return self;
}

//重写 Text setter 方法 获取属性字符串样式
- (void)setText:(NSString *)text {
    [super setText:text];
    
    self.contentAttributed = [[NSMutableAttributedString alloc] initWithString:text];
    [self.contentAttributed addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    if (self.textColor) {
        [self.contentAttributed addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, text.length)];
    }
}

- (void)setTextWithRange:(NSRange)textRange normalColor:(UIColor *)color coverColor:(UIColor *)coverColor clickEvent:(GKTextViewClickBlock)clickBlock {
    
    if (self.text.length < (textRange.location + textRange.length)) {
        return;
    }
    
    // 设置下划线
    //    [self.content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:underlineTextRange];
    
    //设置可点击文字颜色
    if (color) {
        [self.contentAttributed addAttribute:NSForegroundColorAttributeName value:color range:textRange];
    }
    self.attributedText = self.contentAttributed;
    
    // self.selectedRange  影响  self.selectedTextRange
    self.selectedRange = textRange;
    //根据range 获取到 rects
    NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
    //清空选中范围
    self.selectedRange = NSMakeRange(0, 0);
    
    for (UITextSelectionRect *selectionRect in selectionRects) {
        CGRect rect = selectionRect.rect;
        if (rect.size.width == 0 || rect.size.height == 0) {
            continue;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        // 存储文字对应的frame，一段文字可能会有两个甚至多个frame，考虑到文字换行问题
        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"rect"];
        //存储可点击对应的文字
        [dict setObject:[self.text substringWithRange:textRange] forKey:@"content"];
        //存储点击事件的回调
        [dict setObject:clickBlock forKey:@"block"];
        //存储对应的点击效果背景颜色
        [dict setValue:coverColor forKey:@"coverColor"];
        [self.rectsArr addObject:dict];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取触摸对象
    UITouch *touch = touches.anyObject;
    //触摸点
    CGPoint point = [touch locationInView:self];
    // 通过一个触摸点，查询点击的是不是在下划线对应的文字的frame
    if ([self isTouchInTextRangeWithPoint:point]) {
        //在  添加coverView
        for (NSDictionary *dict in self.rectsArr) {
            if (dict && dict[@"coverColor"]) {
                UIView *coverView = [[UIView alloc] init];
                coverView.backgroundColor = dict[@"coverColor"];
                coverView.frame = [dict[@"rect"] CGRectValue];
                coverView.layer.cornerRadius = 5;
                coverView.tag = kCoverViewTag;
                [self insertSubview:coverView atIndex:0];
            }
        }
        
        // 如果说有点击效果的话，加个延时，展示下点击效果,如果没有点击效果的话，直接回调
        NSDictionary *dic = [self.rectsArr firstObject];
        GKTextViewClickBlock block = dic[@"block"];
        if (dic[@"coverColor"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                block(dic[@"content"]);
            });
        }else{
            block(dic[@"content"]);
        }
    }
}

//判断该点有没有在 可点击区域
- (BOOL)isTouchInTextRangeWithPoint:(CGPoint)point {
    for (NSDictionary *dict in self.rectsArr) {
        CGRect rect = [dict[@"rect"] CGRectValue];
        if (CGRectContainsPoint(rect, point)) {
            return YES;
        }
    }
    return NO;
}

//点击结束的时候调用
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *subView in self.subviews) {
            if (subView.tag == kCoverViewTag) {
                [subView removeFromSuperview];
            }
        }
    });
}

//取消点击的时候 消除相关的阴影
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *subView in self.subviews) {
        if (subView.tag == kCoverViewTag) {
            [subView removeFromSuperview];
        }
    }
}

@end
