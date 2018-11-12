//
//  LCTagView.h
//  LCTagView
//
//  Created by Richard on 2018/11/12.
//  Copyright © 2018 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@class LCTagView;

@protocol LCTagViewDelegate <NSObject>

- (void)tagView:(LCTagView *)tagView height:(CGFloat)height;

- (void)tagView:(LCTagView *)tagView didSelectAtIndex:(NSInteger)index;

@end

@interface LCTagView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id <LCTagViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger maxCount;
- (void)updateData;
@end


