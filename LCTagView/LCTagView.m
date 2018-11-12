//
//  LCTagView.m
//  LCTagView
//
//  Created by Richard on 2018/11/12.
//  Copyright © 2018 Richard. All rights reserved.
//

#import "LCTagView.h"
#import "UICollectionViewLeftAlignedLayout.h"

@interface LCTagViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *tagLabel;
@end

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
@property (nonatomic, getter=isNeedAdd) BOOL needAdd;
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
    }
    return self;
}

#pragma mark -- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + (self.isNeedAdd ? 1 : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLCTagsViewCellIdentifier forIndexPath:indexPath];
    if ((self.dataArray.count < 5) && indexPath.row == self.dataArray.count) {
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
    if ((self.dataArray.count < 5) && indexPath.row == self.dataArray.count) {
        return CGSizeMake(57, 30);
    } else {
        NSInteger row = indexPath.row;
        NSAttributedString *title = self.dataArray[row];
        CGSize size =  [title size];
        return CGSizeMake(size.width + 16 * 2, 30);
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

- (void)updateData {
    if (self.dataArray.count == 5) {
        self.needAdd = NO;
    } else {
        self.needAdd = YES;
    }
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    CGFloat height = 0;
    //一行的时候self.collectionView.contentSize.height = 30
    if (self.collectionView.contentSize.height < 45) {
        height = 45;
    } else {
        height = self.collectionView.contentSize.height + 15;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    if ([self.delegate respondsToSelector:@selector(tagView:height:)]) {
        [self.delegate tagView: self height:height];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout=[[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame: CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource  = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:LCTagViewCell.class forCellWithReuseIdentifier:kLCTagsViewCellIdentifier];
    }
    return _collectionView;
}

@end
