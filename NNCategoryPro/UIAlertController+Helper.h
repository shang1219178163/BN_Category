//
//  UIAlertController+Helper.h
//  ProductTemplet
//
//  Created by Bin Shang on 2019/1/17.
//  Copyright © 2019 BN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UIAlertController标题富文本key
FOUNDATION_EXPORT NSString * const kAlertVCTitle;
/// UIAlertController信息富文本key
FOUNDATION_EXPORT NSString * const kAlertVCMessage;
/// UIAlertController按钮颜色key
FOUNDATION_EXPORT NSString * const kAlertActionColor;
/// UIAlertController信息富文本key
FOUNDATION_EXPORT NSString * const kAlertContentViewController;


@interface UIAlertController (Helper)

@property(nonatomic, strong, readonly) UIAlertController *(^addAction)(NSArray<NSString *> *titles, void(^_Nullable handler)(UIAlertAction *action));
/// 仅 UIAlertControllerStyleAlert 可用
@property(nonatomic, strong, readonly) UIAlertController *(^addTextField)(NSArray<NSString *> *placeholders, void(^_Nullable handler)(UITextField *textField));
@property(nonatomic, strong, readonly) UIAlertController *(^present)(BOOL animated, void(^ __nullable completion)(void));

- (instancetype)addActionTitles:(NSArray<NSString *> *)titles handler:(void(^)(UIAlertController *vc, UIAlertAction *action))handler;
/// 仅 UIAlertControllerStyleAlert 可用
- (instancetype)addTextFieldPlaceholders:(NSArray<NSString *> *)placeholders handler:(void(^)(UITextField *textField))handler;


/// [源]Alert弹窗创建
+ (instancetype)createAlertTitle:(NSString * _Nullable)title
                         message:(NSString *_Nullable)message
                    actionTitles:(NSArray *_Nullable)actionTitles
                         handler:(void(^_Nullable)(UIAlertController *vc, UIAlertAction *action))handler;
/// [源]Alert弹窗展示
+ (instancetype)showAlertTitle:(NSString * _Nullable)title
                       message:(NSString *_Nullable)message
                  actionTitles:(NSArray *_Nullable)actionTitles
                       handler:(void(^_Nullable)(UIAlertController *vc, UIAlertAction *action))handler;

/// [源]Sheet弹窗创建
+ (instancetype)createSheetTitle:(NSString *_Nullable)title
                         message:(NSString *_Nullable)message
                    actionTitles:(NSArray *_Nullable)actionTitles
                         handler:(void(^_Nullable)(UIAlertController *vc, UIAlertAction *action))handler;
/// [源]Sheet弹窗展示
+ (instancetype)showSheetTitle:(NSString *_Nullable)title
                       message:(NSString *_Nullable)message
                  actionTitles:(NSArray *_Nullable)actionTitles
                       handler:(void(^_Nullable)(UIAlertController *vc, UIAlertAction *action))handler;

/// 设置标题颜色
- (instancetype)setTitleColor:(UIColor *)color;
/// 设置Message文本换行,对齐方式
- (instancetype)setMessageParaStyle:(NSMutableParagraphStyle *)style;

- (instancetype)setContent:(UIViewController *)vc height:(CGFloat)height;

+ (void)callPhone:(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END
