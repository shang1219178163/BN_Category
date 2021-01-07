//
//  NSAttributedString+Helper.h
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/27.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

//推荐使用 NSMutableAttributedString+Chain.h 链式编程

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Helper)

- (CGSize)sizeWithWidth:(CGFloat)width;

/**
 富文本特殊部分设置
 */
+ (NSDictionary *)attrDictWithFont:(CGFloat)font textColor:(UIColor *)textColor;

/**
 富文本整体设置
 */
+ (NSDictionary *)paraDictWithFont:(CGFloat)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment;

/**
 [源]富文本
 @param text 源字符串
 @param textTaps 特殊部分数组(每一部分都必须包含在text中)
 @param font 一般字体大小(传NSNumber或者UIFont)
 @param tapFont 特殊部分子体大小(传NSNumber或者UIFont)
 @param tapColor 特殊部分颜色
 @return 富文本字符串
 */
+ (NSAttributedString *)getAttString:(NSString *)text
                            textTaps:(NSArray<NSString *> *_Nullable)textTaps
                                font:(CGFloat)font tapFont:(CGFloat)tapFont
                               color:(UIColor *)color
                            tapColor:(UIColor *)tapColor
                           alignment:(NSTextAlignment)alignment;

/**
 富文本段落
 */
+ (NSAttributedString *)getAttString:(NSString *)string
                            textTaps:(NSArray<NSString *> *)textTaps
                            tapColor:(UIColor *)tapColor
                           alignment:(NSTextAlignment)alignment;

/**
 富文本段落设置(无特殊文本)
 */
+ (NSAttributedString *)getAttString:(NSString *)string
                                font:(CGFloat)font
                               color:(UIColor *)color
                           alignment:(NSTextAlignment)alignment;

/**
 富文本产生
 */
+ (NSMutableAttributedString *)getAttString:(NSString *)string textTaps:(NSArray<NSString *> *)textTaps;

/**
 标题前加*
 */
+ (NSArray *)getAttListByPrefix:(NSString *)prefix titleList:(NSArray *)titleList mustList:(NSArray *)mustList;

/**
 (推荐)单个标题前加*
 */
+ (NSAttributedString *)getAttringByPrefix:(NSString *)prefix content:(NSString *)content isMust:(BOOL)isMust;


+ (NSAttributedString *)hyperlinkFromString:(NSString *)string withURL:(NSURL *)aURL font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
