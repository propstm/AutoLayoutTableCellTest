//
//  ViewController.m
//  AutoLayoutTableCellTest
//
//  Created by Matt Propst on 11/16/16.
//  Copyright © 2016 Matt Propst. All rights reserved.
//

#import "ViewController.h"
#import "AutolayoutTableViewCell.h"

//SOURCE: https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell/
#import "AFTableViewCell.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation ViewController

-(void)loadView
{
    [super loadView];
    
    const NSInteger numberOfTableViewRows = 3;
    const NSInteger numberOfCollectionViewCells = 9;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            CGFloat red = arc4random() % 255;
            CGFloat green = arc4random() % 255;
            CGFloat blue = arc4random() % 255;
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
            
            [colorArray addObject:color];
        }
        
        [mutableArray addObject:colorArray];
    }
    
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 210.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[AutolayoutTableViewCell self] forCellReuseIdentifier:@"testCell"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //create header view
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    [sectionHeader setBackgroundColor:[UIColor greenColor]];
    
    
    //create and style label in header view
    CGRect headerLabelFrame = CGRectMake(16, 6, 300, 34);
    UILabel* headerLabel = [[UILabel alloc] initWithFrame: headerLabelFrame];
    [headerLabel setText:@"Sample Header Text for messages sent as needed."];
    [headerLabel setTextColor:[UIColor blackColor]];
    [headerLabel setNumberOfLines:0];
    [headerLabel setFont:[UIFont fontWithName:@".SFUIText-Bold" size:12.0f]];
    
    //add label to headerview
    [sectionHeader addSubview:headerLabel];
    sectionHeader.layer.borderColor = [UIColor blackColor].CGColor;
    
    //return constructed view
    return sectionHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  44;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create and display cells -- Autolayout for cells done in cell's .m files
    
    if(indexPath.row == 0 || indexPath.row == 2){
        AutolayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
            
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
        }

        NSString *cellTitleText = [NSString stringWithFormat:@"This will be a multiple line label for a title: CURRENT INDEXPATH ROW: %li", indexPath.row];
        [cell.cellTitle setText:cellTitleText];
        [cell.cellTitle setNumberOfLines:0];
        [cell.bottomView setBackgroundColor:[UIColor greenColor]];
        //[cell setBottomViewHeight:100];

        return cell;
    }
    static NSString *CellIdentifier = @"CellIdentifier";
    
    AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBottomViewHeight:300];
        [cell layoutSubviews];
    }
    NSString *cellTitleText = [NSString stringWithFormat:@"...CURRENT INDEXPATH ROW: %li", indexPath.row];
    [cell.cellTitle setText:cellTitleText];
    //[cell.cellTitle setNumberOfLines:0];

    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    
    NSLog(@"CALL UPDATE CONSTRAINTS");
    [cell updateConstraints];
    NSLog(@"CALLED UPDATE CONSTRAINTS");
    
    NSInteger index = cell.collectionView.indexPath.row;
    
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    
    return cell;
 
 }


- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    return collectionViewArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSArray *collectionViewArray = self.colorArray[[(AFIndexedCollectionView *)collectionView indexPath].row];
    cell.backgroundColor = collectionViewArray[indexPath.item];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
    NSInteger index = collectionView.indexPath.row;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}



@end
