//
//  GKTextView.h
//  GKTextViewDemo
//
//  Created by 郭凯 on 2017/11/6.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GKTextViewClickBlock)(NSString *clickText);

@interface GKTextView : UITextView

- (void)setTextWithRange:(NSRange)textRange normalColor:(UIColor *)color coverColor:(UIColor *)coverColor clickEvent:(GKTextViewClickBlock)clickBlock;

@end
