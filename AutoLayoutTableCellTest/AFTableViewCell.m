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
    //layout.itemSize = CGSizeMake(93, 93);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    if(!self.titleLabel){
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, self.frame.size.width-8, 20)];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        UIFont *boldFont = [UIFont fontWithName:@".SFUIText-Bold" size:16.0f];
        [self.titleLabel setFont:boldFont];
        [self addSubview:self.titleLabel];
    }
    
    [self updateConstraints];
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    //Create local versions of the ivars
    UILabel *titleLabelP = self.titleLabel;
    UIView *bottomViewP = self.collectionView;
    NSLog(@"BOTTOM VIEW HEIGHT: %li", self.areasOfImpactHeight);
    NSNumber *bottomViewHeightP = [NSNumber numberWithInteger:self.areasOfImpactHeight];
    NSLog(@"BOTTOM VIEW HEIGHT P: %@", bottomViewHeightP);
    
    //Build the visual constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabelP, bottomViewP);
    NSDictionary *metrics = @{ @"padding" : @8.0, @"viewHeight": @150.0 };
    
    // title and bottom view fill the width of the superview (cell content view)
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabelP]-padding-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[bottomViewP]-padding-|" options:0 metrics:metrics views:views]];
    // title and bottom view are setup vertically with 8px of padding between.  The cell should expand to fit the full size of the bottom view.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabelP]-padding-[bottomViewP(viewHeight)]-padding-|" options:0 metrics:metrics views:views]];
    
    NSLog(@"HIT UPDATE CONSTRAINT CODE");
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
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
