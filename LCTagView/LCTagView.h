//
//  LCTagView.h
//  LCTagView
//
//  Created by Richard on 2018/11/12.
//  Copyright © 2018 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, LCAddPostionType) {
    // 添加按钮在最前面
    LCAddPostionAtFirst = 0,
    //添加按钮在最后面
    LCAddPostionAtLast = 1,
};

@class LCTagView;

@protocol LCTagViewDelegate <NSObject>

- (void)tagView:(LCTagView *)tagView didSelectAtIndex:(NSInteger)index;

@optional
- (CGSize)tagView:(LCTagView *)tagView sizeForNomalItemAtIndex:(NSInteger )index;

- (CGSize)tagView:(LCTagView *)tagView sizeForAddAtIndex:(NSInteger )index;

@end

@interface LCTagView : UIView

@property(nonatomic, weak) id <LCTagViewDelegate> delegate;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSUInteger maxCount;
@property(nonatomic, assign) CGFloat lineSpacing;
@property(nonatomic, assign) CGFloat interitemSpacing;
@property(nonatomic, assign) LCAddPostionType addPostionType;

/**
 reload数据
 @param completion reload数据之后，将最新的tagView高度传递出去
 */
- (void)reloadDataWithCompletion:(void (^ __nullable)(CGFloat height))completion;

@end


