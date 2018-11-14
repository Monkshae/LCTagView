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

@interface LCTagView ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    /**
     记录初始化后第一次布局完成后tagView的高度，然后在layoutSubViews中记录，作为cell单行的高度
     */
    BOOL _fisrtLayout;
    /**
     cell单行的高度
     */
    CGFloat _lineHeight;
    /**
     是否显示添加按钮
     */
    CGFloat _isShowAdd;
}
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewLeftAlignedLayout *flowLayout;
@end

@implementation LCTagView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.dataArray = [[NSMutableArray alloc]init];
        _isShowAdd = YES;
        _fisrtLayout = YES;
        self.maxCount = 5;
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_fisrtLayout) {
        _lineHeight = self.bounds.size.height;
        _fisrtLayout = NO;
    }
}

#pragma mark -- UICollectionViewDelegate And UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + (_isShowAdd ? 1 : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLCTagsViewCellIdentifier forIndexPath:indexPath];
    if(self.addPostionType == LCAddPostionAtFirst) {
        if (indexPath.row == 0) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"添加" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:149/255.0 green:148/255.0 blue:157/255.0 alpha:1]}];
            cell.tagLabel.attributedText = text;
            cell.contentView.backgroundColor = UIColor.whiteColor;
            cell.layer.borderColor =  [UIColor colorWithRed:234/255.0 green:234/255.0 blue:235/255.0 alpha:1].CGColor;
            cell.layer.borderWidth = 0.5f;
            return cell;
        } else {
            cell.contentView.backgroundColor =  [UIColor colorWithRed:244/255.0 green:243/255.0 blue:242/255.0 alpha:1];
            cell.layer.borderWidth = 0.f;
            cell.tagLabel.attributedText = self.dataArray[indexPath.row - 1];
            return cell;
        }
    } else {
        if (indexPath.row == self.dataArray.count) {
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayot sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.addPostionType == LCAddPostionAtFirst) {
        if (indexPath.row == 0) {
            if ([self.delegate respondsToSelector:@selector(tagView:sizeForAddAtIndex:)]) {
                return [self.delegate tagView:self sizeForAddAtIndex:indexPath.row];
            }
            //"添加"按钮的大小
            return CGSizeMake(57, _lineHeight);
        } else {
            //文字的长度+左右边距
            if ([self.delegate respondsToSelector:@selector(tagView:sizeForNomalItemAtIndex:)]) {
                return [self.delegate tagView:self sizeForNomalItemAtIndex:indexPath.row - 1];
            }
            NSAttributedString *title = self.dataArray[indexPath.row - 1];
            CGSize size =  [title size];
            return CGSizeMake(size.width + 15 * 2, _lineHeight);
        }
    } else {
        if (indexPath.row == self.dataArray.count) {
            if ([self.delegate respondsToSelector:@selector(tagView:sizeForAddAtIndex:)]) {
                return [self.delegate tagView:self sizeForAddAtIndex:indexPath.row];
            }
            //"添加"按钮的大小
            return CGSizeMake(57, _lineHeight);
        } else {
            if ([self.delegate respondsToSelector:@selector(tagView:sizeForNomalItemAtIndex:)]) {
                return [self.delegate tagView:self sizeForNomalItemAtIndex:indexPath.row];
            }
            NSAttributedString *title = self.dataArray[indexPath.row];
            CGSize size =  [title size];
            //文字的长度+左右边距
            return CGSizeMake(size.width + 15 * 2, _lineHeight);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.addPostionType == LCAddPostionAtFirst) {
        if (indexPath.row == 0) {
            if ([self.delegate respondsToSelector:@selector(tagView:didSelectAtIndex:)]) {
                [self.delegate tagView:self didSelectAtIndex:indexPath.row - 1];
            }
        } else {
            [self.dataArray removeObjectAtIndex:indexPath.row - 1];
            [self reloadDataWithCompletion:nil];
        }
    } else {
        if (indexPath.row == self.dataArray.count) {
            if ([self.delegate respondsToSelector:@selector(tagView:didSelectAtIndex:)]) {
                [self.delegate tagView:self didSelectAtIndex:indexPath.row];
            }
        } else {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self reloadDataWithCompletion:nil];
        }
    }
}

#pragma mark - Setter And Getter

- (void)setLineSpacing:(CGFloat)lineSpacing {
    self.flowLayout.minimumLineSpacing = lineSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    self.flowLayout.minimumInteritemSpacing = interitemSpacing;
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

#pragma mark - Actions And Events

- (void)reloadDataWithCompletion:(void (^)(CGFloat))completion {
    if (self.addPostionType == LCAddPostionAtLast) {
        if (self.dataArray.count == self.maxCount) {
            _isShowAdd = NO;
        } else {
            _isShowAdd = YES;
        }
    }
    [self.collectionView reloadData];
    [self.superview layoutIfNeeded];
    CGFloat height  = self.collectionView.contentSize.height;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    if (completion) {
        completion(height);
    } else {
        if ([self.delegate respondsToSelector:@selector(tagView:estimatedHeight:)]) {
            [self.delegate tagView:self estimatedHeight:height];
        }
    }
}

@end
