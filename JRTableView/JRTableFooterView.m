//
//  JRTableFooterView.m
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import "JRTableFooterView.h"

@interface JRTableFooterView ()

@property (nonatomic, strong) NSLayoutConstraint *bottomInsetConstraint;

@end

@implementation JRTableFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.clipsToBounds = YES;
        
        _contentMode = JRTableFooterViewContentModeTop;
        
        _contentView = [UIView new];
        _contentView.frame = self.bounds;
        _contentView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        [self addSubview:_contentView];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.contentMode == JRTableFooterViewContentModeFill) {
        
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-self.bottomInset);
        
    } else if (self.contentMode == JRTableFooterViewContentModeTop) {
        
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.height);
        
    } else if (self.contentMode == JRTableFooterViewContentModeBottom) {
        
        self.contentView.frame = CGRectMake(0, self.frame.size.height-self.height-self.bottomInset, self.frame.size.width, self.height);
        
    } else if (self.contentMode == JRTableFooterViewContentModeCenter) {
        
        self.contentView.frame = CGRectMake(0, ((self.frame.size.height-self.bottomInset)/2.0-self.height/2.0), self.frame.size.width, self.height);
    }
}

@end
