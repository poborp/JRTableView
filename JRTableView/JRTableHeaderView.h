//
//  JRTableHeaderView.h
//  JRTableViewExample
//
//  Created by Jacobo Rodriguez on 10/03/18.
//  Copyright © 2018 tBear Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JRTableHeaderViewContentModeFill,
    JRTableHeaderViewContentModeTop,
    JRTableHeaderViewContentModeBottom,
    JRTableHeaderViewContentModeCenter
} JRTableHeaderViewContentMode;

@interface JRTableHeaderView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) JRTableHeaderViewContentMode contentMode;
@property (nonatomic, assign) CGFloat topInset;
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat maxHeight;

@end
