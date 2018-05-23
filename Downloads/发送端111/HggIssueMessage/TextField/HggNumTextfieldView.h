//
//  HggNumTextfieldView.h
//  HggIssueMessage
//
//  Created by zww on 2017/8/31.
//  Copyright © 2017年 zww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HggNumTextfieldView : UIView
typedef void(^ButtonClick)(NSString * string);// 这里的index是参数，我传递的是button
@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *textNumView;
@property (nonatomic, strong) UILabel *textNumberLabel;

@property (nonatomic, strong) UILabel *toplabel;

@property (nonatomic,copy) ButtonClick buttonAction;
//我想要的高度
@property (nonatomic, assign) int numHight;
@end
