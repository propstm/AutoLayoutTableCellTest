//
//  AutolayoutTableViewCell.m
//  AutoLayoutTableCellTest
//
//  Created by Matt Propst on 11/16/16.
//  Copyright © 2016 Matt Propst. All rights reserved.
//

/*
 
 The goal of this cell is to create a UI with title across the top, and a view below.
    -Text set by datasource
    -View height set by datasource
    -Padding around views 8px
        _________________________________________
        |                                       |
        |   |------TITLE LABEL TEXT HERE-----|  |
        |   _________________________________   |
        |   |                               |   |         
        |   |                               |   |
        |   |         BOTTOM VIEW           |   |
        |   |                               |   |
        |   |                               |   |
        |   |                               |   |
        |   ---------------------------------   |
        -----------------------------------------
 
 */

#import "AutolayoutTableViewCell.h"

@implementation AutolayoutTableViewCell

- (void)awakeFromNib {
    //don't have a xib file, this is useless
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    //lazy init ivars
    if(!self.cellTitle){
        self.cellTitle = [[UILabel alloc] init];
        [self.cellTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.cellTitle];
    }
    
    if(!self.bottomView){
        self.bottomView = [[UIView alloc] init];
        [self.bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.bottomView];
    }
    self.bottomViewHeight = 150;
    
    [self updateConstraints];
    
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    //Create local versions of the ivars
    UILabel *titleLabelP = self.cellTitle;
    UIView *bottomViewP = self.bottomView;
    NSNumber *bottomViewHeightP = [NSNumber numberWithInt:self.bottomViewHeight];
   
    
    //Build the visual constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabelP, bottomViewP);
    NSDictionary *metrics = @{ @"padding" : @8.0, @"viewHeight": bottomViewHeightP };

    // title and bottom view fill the width of the superview (cell content view)
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabelP]-padding-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[bottomViewP]-padding-|" options:0 metrics:metrics views:views]];
    // title and bottom view are setup vertically with 8px of padding between.  The cell should expand to fit the full size of the bottom view.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabelP]-padding-[bottomViewP(viewHeight)]-padding-|" options:0 metrics:metrics views:views]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
