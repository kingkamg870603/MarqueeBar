//
//  MarqueeBar.h
//  DATABK
//
//  Created by Charles on 2020/11/30.
//  Copyright © 2020 databank. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MarqueeBar : UIView
@property (nonatomic, strong) NSString  * title;

+ (instancetype)marqueeBarWithFrame:(CGRect)frame title:(NSString*)title;

- (void)updateTitle:(NSString*)title;
- (void)updateTitleFont:(UIFont*)font color:(UIColor*)textColor;
- (void)resume;

@end

