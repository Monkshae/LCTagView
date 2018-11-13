//
//  ViewController.m
//  LCTagView
//
//  Created by Richard on 2018/11/12.
//  Copyright © 2018 Richard. All rights reserved.
//

#import "ViewController.h"
#import "LCTagView.h"

@interface ViewController ()<LCTagViewDelegate>
@property (nonatomic, strong) LCTagView *tagView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tagView = [[LCTagView alloc] init];
    self.tagView.delegate = self;
    self.tagView.maxCount = 10;
//    self.tagView.addPostionType = LCAddPostionAtLast;
//    self.tagView.lineSpacing = 30;
    self.tagView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}

- (void)tagView:(LCTagView *)tagView didSelectAtIndex:(NSInteger)index {
   NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"我是一个标签😀😝😀😝" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:149/255.0 green:148/255.0 blue:157/255.0 alpha:1]}];
    [self.tagView.dataArray addObject:text];
    [self.tagView reloadDataWithCompletion:nil];
}

- (CGSize)tagView:(LCTagView *)tagView sizeForAddAtIndex:(NSInteger)index {
    return CGSizeMake(100, 30);
}

@end
