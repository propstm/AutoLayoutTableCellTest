//
//  AFTableViewCell.m
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFTableViewCell.h"

@implementation AFIndexedCollectionView

@end

@implementation AFTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    layout.itemSize = CGSizeMake(100, 100);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    //lazy init ivars
    if(!self.cellTitle){
        self.cellTitle = [[UILabel alloc] init];
        [self.cellTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.cellTitle];
    }
    
    if(!self.bottomView){
        self.bottomView = [[UIView alloc] init];
        [self.bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.bottomView];
    }
    //self.bottomViewHeight = 350;
    //[self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[self updateConstraints];
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    //Create local versions of the ivars
    UILabel *titleLabelP = self.cellTitle;
    UIView *bottomViewP = self.collectionView;
    NSNumber *bottomViewHeightP = [NSNumber numberWithInt:self.bottomViewHeight];
    
    
    //Build the visual constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabelP, bottomViewP);
    NSDictionary *metrics = @{ @"padding" : @8.0, @"viewHeight": bottomViewHeightP };
    
    // title and bottom view fill the width of the superview (cell content view)
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabelP]-padding-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[bottomViewP]-padding-|" options:0 metrics:metrics views:views]];
    // title and bottom view are setup vertically with 8px of padding between.  The cell should expand to fit the full size of the bottom view.
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabelP]-padding-[bottomViewP(viewHeight)]-padding-|" options:0 metrics:metrics views:views]];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    //self.collectionView.frame = self.contentView.bounds;
}


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    
    [self.collectionView reloadData];
}

@end
