//
//  JRTableHeaderView.m
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import "JRTableHeaderView.h"

@interface JRTableHeaderView ()

@property (nonatomic, strong) NSLayoutConstraint *topInsetConstraint;

@end

@implementation JRTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.clipsToBounds = YES;
        
        _contentMode = JRTableHeaderViewContentModeBottom;
        
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [self addSubview:_contentView];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.contentMode == JRTableHeaderViewContentModeFill) {
        
        self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.frame.size.height-self.topInset);
        
    } else if (self.contentMode == JRTableHeaderViewContentModeTop) {
        
        if (self.frame.size.height <= self.minHeight) {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.minHeight);
        } else if (self.frame.size.height >= self.maxHeight) {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.maxHeight);
        } else {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.frame.size.height);
        }
        
    } else if (self.contentMode == JRTableHeaderViewContentModeBottom) {
        
        if (self.frame.size.height >= self.maxHeight+self.topInset) {
            self.contentView.frame = CGRectMake(0, self.frame.size.height-self.maxHeight, self.frame.size.width, self.maxHeight);
        } else if (self.frame.size.height <= self.minHeight+self.topInset) {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.minHeight);
        } else {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.frame.size.height-self.topInset);
        }
        
    } else {
        
        if (self.frame.size.height <= self.minHeight) {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.minHeight-self.topInset);
        } else if (self.frame.size.height-self.topInset >= self.maxHeight) {
            self.contentView.frame = CGRectMake(0, ((self.frame.size.height+self.topInset)/2.0-self.maxHeight/2.0), self.frame.size.width, self.maxHeight);
        } else {
            self.contentView.frame = CGRectMake(0, self.topInset, self.frame.size.width, self.frame.size.height-self.topInset);
        }
    }
}

@end
