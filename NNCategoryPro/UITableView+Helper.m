
//
//  UITableView+Helper.m
//  
//
//  Created by BIN on 2018/2/28.
//  Copyright © 2018年 SHANG. All rights reserved.
//

#import "UITableView+Helper.h"

#import <NNGloble/NNGloble.h>
#import "UIColor+Helper.h"
#import "NSArray+Helper.h"

@implementation UITableView (Helper)

/**
 [源]UITableView创建方法
 */
+ (instancetype)createRect:(CGRect)rect style:(UITableViewStyle)style{
    UITableView *view = [[self alloc] initWithFrame:rect style:style];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.separatorInset = UIEdgeInsetsZero;
    view.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    view.rowHeight = 70;
    view.backgroundColor = UIColor.backgroudColor;
//    view.tableHeaderView = [[UIView alloc]init];
//    view.tableFooterView = [[UIView alloc]init];
//    view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [view registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    return view;
}

-(void)logTableViewContentInset{
    NSLog(@"frame:%@", NSStringFromCGRect(self.frame));
    NSLog(@"contentInset:%@", NSStringFromUIEdgeInsets(self.contentInset));
    if (@available(iOS 11.0, *)) {
        NSLog(@"safeAreaInsets:%@", NSStringFromUIEdgeInsets(self.safeAreaInsets));
        NSLog(@"adjustedContentInset:%@", NSStringFromUIEdgeInsets(self.adjustedContentInset));
    }
}

-(void)reloadRowList:(NSArray *)rowList section:(NSInteger)section rowAnimation:(UITableViewRowAnimation)rowAnimation{    
    NSInteger rowMax = [[rowList valueForKeyPath:kArrMaxInter] integerValue];
    if (section > self.numberOfSections || rowMax >= [self numberOfRowsInSection:section]) {
        return;
    }
    
    NSMutableArray *marr = [NSMutableArray array];
    for (NSNumber *row in rowList) {
        [marr addObject:[NSIndexPath indexPathForRow:row.integerValue inSection:section]];
    }
    
    if (!rowAnimation) rowAnimation = UITableViewRowAnimationNone;
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:marr.copy withRowAnimation:rowAnimation];
    [self endUpdates];
}

-(void)insertRowList:(NSArray *)rowList section:(NSInteger)section rowAnimation:(UITableViewRowAnimation)rowAnimation{
    NSMutableArray *marr = [NSMutableArray array];
    for (NSNumber *row in rowList) {
        [marr addObject:[NSIndexPath indexPathForRow:row.integerValue inSection:section]];
    }
    
    if (!rowAnimation) rowAnimation = UITableViewRowAnimationNone;
    [self beginUpdates];
    [self insertRowsAtIndexPaths:marr.copy withRowAnimation:rowAnimation];
    [self endUpdates];
}

-(void)deleteRowList:(NSArray *)rowList section:(NSInteger)section rowAnimation:(UITableViewRowAnimation)rowAnimation{
    NSInteger rowMax = [[rowList valueForKeyPath:kArrMaxInter] integerValue];
    if (section > self.numberOfSections || rowMax >= [self numberOfRowsInSection:section]) {
        return;
    }
    
    if (!rowAnimation) rowAnimation = UITableViewRowAnimationNone;
    if (rowList.count == [self numberOfRowsInSection:section] && self.numberOfSections != 1) {
        [self beginUpdates];
        [self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self endUpdates];
        
    } else {
        NSMutableArray * marr = [NSMutableArray array];
        for (NSNumber *row in rowList) {
            [marr addObject:[NSIndexPath indexPathForRow:row.integerValue inSection:section]];
        }
        
        if (!rowAnimation) rowAnimation = UITableViewRowAnimationNone;
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:marr.copy withRowAnimation:rowAnimation];
        [self endUpdates];
    }
}

-(void)cellAddCornerRadius:(CGFloat)cornerRadius cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(tintColor)]) {
        
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = CAShapeLayer.layer;
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [self numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            
        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
        layer.strokeColor = UIColor.blackColor.CGColor;
        layer.strokeColor = UIColor.clearColor.CGColor;
        
        if (addLine) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / UIScreen.mainScreen.scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 10,
                                         bounds.size.height - lineHeight,
                                         bounds.size.width - 10,
                                         lineHeight);
            lineLayer.backgroundColor = self.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:bounds];
        [bgView.layer insertSublayer:layer atIndex:0];
        bgView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = bgView;
    }
}



@end
