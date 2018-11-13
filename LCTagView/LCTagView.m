//
//  LCTagView.m
//  LCTagView
//
//  Created by Richard on 2018/11/12.
//  Copyright © 2018 Richard. All rights reserved.
//

#import "LCTagView.h"
#import "UICollectionViewLeftAlignedLayout.h"

@implementation LCTagViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:242/255.0 alpha:1];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont systemFontOfSize:12];
        _tagLabel.textColor = [UIColor colorWithRed:149/255.0 green:148/255.0 blue:157/255.0 alpha:1];
        [self.contentView addSubview:_tagLabel];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

@end


static NSString *const kLCTagsViewCellIdentifier = @"LCTagsViewCell";

@interface LCTagView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, getter=isNeedAdd) BOOL needAdd;
@property(nonatomic, strong)UICollectionViewLeftAlignedLayout *flowLayout;
@end

@implementation LCTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.dataArray = [[NSMutableArray alloc]init];
        _needAdd = YES;
        self.maxCount = 5;
        
    }
    return self;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    self.flowLayout.minimumLineSpacing = lineSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    self.flowLayout.minimumInteritemSpacing = interitemSpacing;
}

#pragma mark -- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + (self.isNeedAdd ? 1 : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLCTagsViewCellIdentifier forIndexPath:indexPath];
    if ((self.dataArray.count < self.maxCount) && indexPath.row == self.dataArray.count) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"添加" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:149/255.0 green:148/255.0 blue:157/255.0 alpha:1]}];
        cell.tagLabel.attributedText = text;
        cell.contentView.backgroundColor = UIColor.whiteColor;
        cell.layer.borderColor =  [UIColor colorWithRed:234/255.0 green:234/255.0 blue:235/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 0.5f;
        return cell;
    } else {
        cell.contentView.backgroundColor =  [UIColor colorWithRed:244/255.0 green:243/255.0 blue:242/255.0 alpha:1];
        cell.layer.borderWidth = 0.f;
        cell.tagLabel.attributedText = self.dataArray[indexPath.row];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayot sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.dataArray.count < self.maxCount) && indexPath.row == self.dataArray.count) {
        //添加按钮的大小
        return CGSizeMake(57, 45);
    } else {
        NSInteger row = indexPath.row;
        NSAttributedString *title = self.dataArray[row];
        CGSize size =  [title size];
        //文字的长度+左右边距
        return CGSizeMake(size.width + 16 * 2, 45);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        if ([self.delegate respondsToSelector:@selector(tagView:didSelectAtIndex:)]) {
            [self.delegate tagView:self didSelectAtIndex:indexPath.row];
        }
    } else {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self updateData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateData {
    if (self.dataArray.count == self.maxCount) {
        self.needAdd = NO;
    } else {
        self.needAdd = YES;
    }
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    CGFloat height = 0;
    //一行的时候self.collectionView.contentSize.height = 30
//    if (self.collectionView.contentSize.height < 45) {
//        height = 45;
//    } else {
        height = self.collectionView.contentSize.height;
//    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    if ([self.delegate respondsToSelector:@selector(tagView:height:)]) {
        [self.delegate tagView: self height:height];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame: CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource  = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:LCTagViewCell.class forCellWithReuseIdentifier:kLCTagsViewCellIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewLeftAlignedLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        _flowLayout.minimumLineSpacing = 15;
        _flowLayout.minimumInteritemSpacing = 15;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _flowLayout;
}
@end
