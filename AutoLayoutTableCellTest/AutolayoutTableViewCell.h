//
//  AutolayoutTableViewCell.h
//  AutoLayoutTableCellTest
//
//  Created by Matt Propst on 11/16/16.
//  Copyright © 2016 Matt Propst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutolayoutTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *cellTitle;
@property (strong, nonatomic) UIView *bottomView;
@property (readwrite) int bottomViewHeight;

@end
