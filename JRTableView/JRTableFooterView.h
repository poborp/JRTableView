//
//  JRTableFooterView.h
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JRTableFooterViewContentModeFill,
    JRTableFooterViewContentModeTop,
    JRTableFooterViewContentModeBottom,
    JRTableFooterViewContentModeCenter
} JRTableFooterViewContentMode;

@interface JRTableFooterView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) JRTableFooterViewContentMode contentMode;
@property (nonatomic, assign) CGFloat bottomInset;
@property (nonatomic, assign) CGFloat height;

@end
