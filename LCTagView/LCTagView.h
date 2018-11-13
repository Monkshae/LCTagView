//
//  LCTagView.h
//  LCTagView
//
//  Created by Richard on 2018/11/12.
//  Copyright © 2018 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@class LCTagView, LCTagViewCell;

@protocol LCTagViewDelegate <NSObject>

- (NSInteger)tagViewNumberOfItems:(nullable LCTagView *)tagView;

- (LCTagViewCell *)tagView:(LCTagView *)tagView cellForItemAtIndex:(NSInteger)index;

- (LCTagViewCell *)tagView:(LCTagView *)tagView viewForSupplementaryAtIndex:(NSInteger )index;

- (LCTagViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSIndexPath *)index;

- (void)tagView:(LCTagView *)tagView height:(CGFloat)height;

- (void)tagView:(LCTagView *)tagView didSelectAtIndex:(NSInteger)index;

- (CGSize)tagView:(LCTagView *)tagView sizeForItemAtIndex:(NSInteger )index;

- (CGSize)tagView:(LCTagView *)tagView sizeForSupplementaryAtIndex:(NSInteger )index;

@end

@interface LCTagViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *tagLabel;
@end
    
@interface LCTagView : UIView
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, weak) id <LCTagViewDelegate>delegate;
@property(nonatomic, strong) NSMutableArray *dataArray;
//@property(nonatomic, assign) UIEdgeInsets edgeInsets;

@property(nonatomic, assign) NSUInteger maxCount;
@property(nonatomic, assign) CGFloat lineSpacing;
@property(nonatomic, assign) CGFloat interitemSpacing;
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, assign) UIEdgeInsets cellEdgeInsets;

- (void)updateData;
@end


