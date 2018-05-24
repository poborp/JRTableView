//
//  JRTableView.h
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JRTableHeaderView.h"
#import "JRTableFooterView.h"

@interface JRTableView : UITableView

//Custom tableHeader
@property (nonatomic, strong) JRTableHeaderView *tableHeaderView;
@property (nonatomic, assign) CGFloat tableHeaderViewMinHeight;
@property (nonatomic, assign) CGFloat tableHeaderViewMaxHeight;

//Custom tableFooter
@property (nonatomic, strong) JRTableFooterView *tableFooterView;
@property (nonatomic, assign) CGFloat tableFooterViewMaxHeight;

//Custom scrollBar
@property (nonatomic, strong) UIColor *scrollBarColor;

//Sticky Values
@property (nonatomic, assign) BOOL stickyHeader;
@property (nonatomic, assign) BOOL stickyFooter;

@end
