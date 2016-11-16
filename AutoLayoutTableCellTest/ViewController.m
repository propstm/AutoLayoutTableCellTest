//
//  ViewController.m
//  AutoLayoutTableCellTest
//
//  Created by Matt Propst on 11/16/16.
//  Copyright © 2016 Matt Propst. All rights reserved.
//

#import "ViewController.h"
#import "AutolayoutTableViewCell.h"
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
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    /*
    if(firstIndexPath.row == 0){
        
        AutolayoutTableViewCell *cell = (AutolayoutTableViewCell*)[self.tableView cellForRowAtIndexPath:secondIndexPath];
        
        NSLog(@"----------------------------------------------------");
        NSLog(@"----------------------------------------------------");
        NSLog(@"WAS ANYTHING CREATED:");
        NSLog(@"CELL TITLE: %@", cell.cellTitle);
        NSLog(@"CELL BOTTOM VIEW: %@", cell.bottomView);

    }
    if(secondIndexPath.row == 1){
        AFTableViewCell *afCell = (AFTableViewCell*)[self.tableView cellForRowAtIndexPath:secondIndexPath];
        
        NSLog(@"----------------------------------------------------");
        NSLog(@"----------------------------------------------------");
        NSLog(@"WAS ANYTHING CREATED:");
        NSLog(@"CELL TITLE: %@", afCell.titleLabel.text);
        NSLog(@"CELL BOTTOM VIEW: %@", afCell.collectionView);
    }

*/
    
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
    UIView *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    [sectionHeader setBackgroundColor:[UIColor whiteColor]];
    
    
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
    if(indexPath.row == 0 || indexPath.row == 2){
        AutolayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
            
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
        }

        NSString *cellTitleText = [NSString stringWithFormat:@"CURRENT INDEXPATH ROW: %li", indexPath.row];
        [cell.cellTitle setText:cellTitleText];
        [cell.bottomView setBackgroundColor:[UIColor greenColor]];
        [cell setBottomViewHeight:100];

        return cell;
    }
    static NSString *CellIdentifier = @"CellIdentifier";
    
    AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *cellTitleText = [NSString stringWithFormat:@"CURRENT INDEXPATH ROW: %li", indexPath.row];
    [cell.titleLabel setText:cellTitleText];

    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    NSInteger index = cell.collectionView.indexPath.row;
    
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    
    return cell;
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
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width-10, 44)];
    [lbl setText:@"Productivity"];
    UIFont *regularFont = [UIFont fontWithName:@".SFUIText-Regular" size:10.0f];
    [lbl setFont:regularFont];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:lbl];
    
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
