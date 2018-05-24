//
//  JRTableView.m
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import "JRTableView.h"

@interface JRTableView ()

@property (nonatomic, strong) JRTableHeaderView *tableHeaderViewContainer;
@property (nonatomic, strong) JRTableFooterView *tableFooterViewContainer;

@end

@implementation JRTableView

@dynamic tableHeaderView;
@dynamic tableFooterView;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _stickyHeader = (style == UITableViewStylePlain) ? YES : NO;
        _stickyFooter = (style == UITableViewStylePlain) ? YES : NO;
        
        _scrollBarColor = [UIColor blackColor];
        
        _tableHeaderViewMinHeight = 0;
        _tableHeaderViewMaxHeight = 200;
        
        _tableFooterViewMaxHeight = 30;
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat offset = self.contentOffset.y;
    
    CGFloat topInset = 0;
    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
        topInset = self.adjustedContentInset.top;
        bottomInset = self.adjustedContentInset.bottom;
    }
    
    if (self.tableHeaderViewContainer) {
        
        self.tableHeaderViewContainer.topInset = topInset;
        self.tableHeaderViewContainer.minHeight = self.tableHeaderViewMinHeight;
        self.tableHeaderViewContainer.maxHeight = self.tableHeaderViewMaxHeight;
        
        // To Top
        if (self.tableHeaderViewMaxHeight-offset-topInset < self.tableHeaderViewMinHeight) {
            
            self.tableHeaderViewContainer.frame = CGRectMake(0, offset, self.frame.size.width, self.tableHeaderViewMinHeight+topInset);
            
        // To Bottom
        } else {
            
            self.tableHeaderViewContainer.frame = CGRectMake(0, offset, self.frame.size.width, self.tableHeaderViewMaxHeight-offset);
        }
        
        //NSLog(@"[Header] o: %f, y: %f, h: %f", offset, self.tableHeaderViewContainer.frame.origin.y, self.tableHeaderViewContainer.frame.size.height);
        
        //Show tableHeaderView over section views
        [self bringSubviewToFront:super.tableHeaderView];
    }
    
    if (self.tableFooterViewContainer) {
        
        self.tableFooterViewContainer.bottomInset = bottomInset;
        self.tableFooterViewContainer.height = self.tableFooterViewMaxHeight;
        
        // Big
        if (self.contentSize.height > self.frame.size.height) {
            
            //To Top
            if (self.contentOffset.y >= (self.contentSize.height - self.frame.size.height + bottomInset)) {
                
                self.tableFooterViewContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-self.contentSize.height-bottomInset+offset+self.tableFooterViewMaxHeight+bottomInset);
                
            // To Bottom
            } else {
                
                self.tableFooterViewContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.tableFooterViewMaxHeight+bottomInset);
            }
            
        // Small
        } else {
            
            // To Bottom
            if (self.tableFooterViewMaxHeight + offset + topInset <= self.tableFooterViewMaxHeight) {
                
                self.tableFooterViewContainer.frame = CGRectMake(0, self.frame.size.height-self.contentSize.height-bottomInset+offset, self.frame.size.width, self.tableFooterViewMaxHeight+bottomInset);
                
            // To Top
            } else {
                
                self.tableFooterViewContainer.frame = CGRectMake(0, self.frame.size.height-self.contentSize.height-topInset-bottomInset, self.frame.size.width, self.tableFooterViewMaxHeight+topInset+offset+bottomInset);
            }
        }
        
        //NSLog(@"[Footer] o: %f, y: %f, h: %f", offset, self.tableFooterViewContainer.frame.origin.y, self.tableFooterViewContainer.frame.size.height);
        
        //Show tableFooterView over section views
        [self bringSubviewToFront:super.tableFooterView];
    }
    
    //Hack to bring the vertical scroll indicator to front
    NSArray *subviews = [self.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"self isKindOfClass: %@", [UIImageView class]]];
    for (UIImageView *image in subviews) {
        NSInteger width = image.frame.size.width*10;
        if (width == 23 || width == 25) {
            UIImageView *barView = (UIImageView *)image;
            barView.image = [barView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            barView.tintColor = self.scrollBarColor;
            [self bringSubviewToFront:barView];
        }
    }
}

#pragma mark - Private Actions

- (void)refreshTableViewHeader {
    
    
}

- (BOOL)allowsHeaderViewsToFloat {
    
    return self.stickyHeader;
}

- (BOOL)allowsFooterViewsToFloat {
    
    return self.stickyFooter;
}

#pragma mark - Setter

- (void)setTableHeaderViewMinHeight:(CGFloat)tableHeaderViewMinHeight {
    
    _tableHeaderViewMinHeight = tableHeaderViewMinHeight;
    
    if (_tableHeaderViewContainer) {
        [_tableHeaderViewContainer removeFromSuperview];
    }
    
    self.tableHeaderView = self.tableHeaderViewContainer;
}

- (void)setTableHeaderViewMaxHeight:(CGFloat)tableHeaderViewMaxHeight {
    
    _tableHeaderViewMaxHeight = tableHeaderViewMaxHeight;
    
    if (_tableHeaderViewContainer) {
        [_tableHeaderViewContainer removeFromSuperview];
    }

    self.tableHeaderView = self.tableHeaderViewContainer;
}

- (void)setTableFooterViewMaxHeight:(CGFloat)tableFooterViewMaxHeight {
    
    _tableFooterViewMaxHeight = tableFooterViewMaxHeight;
    
    if (_tableFooterViewContainer) {
        [_tableFooterViewContainer removeFromSuperview];
    }
    
    self.tableFooterView = self.tableFooterViewContainer;
}

#pragma mark - Getter

- (JRTableHeaderView *)tableHeaderView {
    
    return self.tableHeaderViewContainer;
}

- (JRTableFooterView *)tableFooterView {
    
    return self.tableFooterViewContainer;
}

#pragma mark - Overide

- (void)setTableHeaderView:(JRTableHeaderView *)tableHeaderView {
    
    if (self.tableHeaderViewContainer) {
        [self.tableHeaderViewContainer removeFromSuperview];
    }
    
    if (tableHeaderView) {
        
        CGFloat topInset = 0;
        if (@available(iOS 11.0, *)) {
            topInset = self.adjustedContentInset.top;
        }
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.tableHeaderViewMaxHeight);
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [super setTableHeaderView:view];
        
        self.tableHeaderViewContainer = tableHeaderView;
        self.tableHeaderViewContainer.frame = self.tableHeaderView.bounds;
        self.tableHeaderViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:self.tableHeaderViewContainer];
        
    } else {
        
        self.tableHeaderViewContainer = tableHeaderView;
        [super setTableHeaderView:tableHeaderView];
    }
}

- (void)setTableFooterView:(JRTableFooterView *)tableFooterView {

    if (self.tableFooterViewContainer) {
        [self.tableFooterViewContainer removeFromSuperview];
    }
    
    if (tableFooterView) {

        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.tableFooterViewMaxHeight);
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [super setTableFooterView:view];

        self.tableFooterViewContainer = tableFooterView;
        self.tableFooterViewContainer.frame = self.tableFooterView.bounds;
        self.tableFooterViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:self.tableFooterViewContainer];

    } else {
        
        self.tableFooterViewContainer = tableFooterView;
        [super setTableFooterView:tableFooterView];
    }
}

@end
