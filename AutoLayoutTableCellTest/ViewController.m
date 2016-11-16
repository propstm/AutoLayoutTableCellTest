//
//  ViewController.m
//  AutoLayoutTableCellTest
//
//  Created by Matt Propst on 11/16/16.
//  Copyright © 2016 Matt Propst. All rights reserved.
//

#import "ViewController.h"
#import "AutolayoutTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 210.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[AutolayoutTableViewCell self] forCellReuseIdentifier:@"testCell"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    AutolayoutTableViewCell *cell = (AutolayoutTableViewCell*)[self.tableView cellForRowAtIndexPath:firstIndexPath];
    
    NSLog(@"----------------------------------------------------");
    NSLog(@"----------------------------------------------------");
    NSLog(@"WAS ANYTHING CREATED:");
    NSLog(@"CELL TITLE: %@", cell.cellTitle);
    NSLog(@"CELL BOTTOM VIEW: %@", cell.bottomView);
    NSLog(@"----------------------------------------------------");
    NSLog(@"CHECK FRAMES:");
    NSLog(@"CELL TITLE FRAME: %@", NSStringFromCGRect(cell.cellTitle.frame));
    NSLog(@"CELL BOTTOM VIEW FRAME: %@", NSStringFromCGRect(cell.bottomView.frame));
    
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





@end
