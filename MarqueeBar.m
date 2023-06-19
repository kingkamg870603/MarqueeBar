//
//  MarqueeBar.m
//  DATABK
//
//  Created by Charles on 2020/11/30.
//  Copyright © 2020 databank. All rights reserved.
//

#import "MarqueeBar.h"

#define kDefaultSpeed 60.0

@interface MarqueeBar() {
    NSTimer *_timer;
}

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation MarqueeBar

+ (instancetype)marqueeBarWithFrame:(CGRect)frame title:(NSString*)title {
    MarqueeBar * marqueeBar = [[MarqueeBar alloc] initWithFrame:frame];
    marqueeBar.title = title;
    return marqueeBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        
        [self.labelArray addObject:_firstLabel];
        [self.labelArray addObject:_secondLabel];
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    NSString *raceStr = [NSString stringWithFormat:@"%@    ",title];
    NSAttributedString *attri = [raceStr bracketAttributedStringWithDefaultColor:[UIColor color_26]
                                                                     defaultFont:[UIFont font_13]
                                                                           color:[UIColor colorWithHex:@"#FF7600"]
                                                                            font:[UIFont xm_boldFont:13]];
    _firstLabel.attributedText = attri;
    _secondLabel.attributedText = attri;
    
    self.firstLabel.frame = CGRectMake(0, 0, [self getStringWidth:raceStr], self.frame.size.height);
    self.secondLabel.frame = CGRectMake(_firstLabel.frame.origin.x + _firstLabel.bounds.size.width, _firstLabel.frame.origin.y, _firstLabel.bounds.size.width, _firstLabel.bounds.size.height);
    
    _secondLabel.hidden = ![self isNeedRaceAnimate];
    
    if ([self isNeedRaceAnimate]) {
        [self startAnimation];
    }
}

- (void)updateTitle:(NSString *)title {
    self.title = title;
}

- (BOOL)isNeedRaceAnimate{
    return YES;
    /// 一直滚动
//    return _firstLabel.bounds.size.width > self.bounds.size.width;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    if (_firstLabel && _secondLabel) {
        _firstLabel.frame = CGRectMake(0, 0, _firstLabel.bounds.size.width, self.bounds.size.height);
        _secondLabel.frame = CGRectMake(_firstLabel.frame.origin.x + _firstLabel.bounds.size.width, _firstLabel.frame.origin.y, _firstLabel.bounds.size.width, _firstLabel.bounds.size.height);
    }
    _secondLabel.hidden = ![self isNeedRaceAnimate];
}


- (void)startAnimation{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / kDefaultSpeed target:self selector:@selector(raceLabelFrameChanged:) userInfo:nil repeats:YES];
    [_timer fire];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateTitleFont:(UIFont*)font color:(UIColor*)textColor{
    NSString *raceStr = [NSString stringWithFormat:@"%@    ",self.title];
    NSAttributedString *attri = [raceStr bracketAttributedStringWithDefaultColor:textColor
                                                                     defaultFont:[UIFont font_16]
                                                                           color:[UIColor colorWithHex:@"#FF7600"]
                                                                            font:[UIFont xm_boldFont:13]];
    _firstLabel.attributedText = attri;
    _secondLabel.attributedText = attri;
    
    self.firstLabel.frame = CGRectMake(0, 0, [self getStringWidth:raceStr], self.frame.size.height);
    self.secondLabel.frame = CGRectMake(_firstLabel.frame.origin.x + _firstLabel.bounds.size.width, _firstLabel.frame.origin.y, _firstLabel.bounds.size.width, _firstLabel.bounds.size.height);
}

- (void)raceLabelFrameChanged:(NSTimer *)timer{
    UILabel *firstLabel = [self.labelArray firstObject];
    UILabel *secondLabel = [self.labelArray lastObject];
    CGRect frameOne = firstLabel.frame;
    CGRect frameTwo = secondLabel.frame;
    CGFloat firstX = firstLabel.frame.origin.x;
    CGFloat secondX = secondLabel.frame.origin.x;
    firstX -= 0.5;
    secondX -= 0.5;
    if (ABS(firstX) >= firstLabel.bounds.size.width) {
        firstX = secondX + firstLabel.bounds.size.width;
        [self.labelArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
    }
    frameOne.origin.x = firstX;
    frameTwo.origin.x = secondX;
    firstLabel.frame = frameOne;
    secondLabel.frame = frameTwo;
}

- (void)resume{
    [self resumeAndStart:NO];
}

- (void)resumeAndStart{
    [self resumeAndStart:YES];
}

- (void)resumeAndStart:(BOOL)start{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _firstLabel.frame = CGRectMake(0, 0, _firstLabel.bounds.size.width, self.bounds.size.height);
    _secondLabel.frame = CGRectMake(_firstLabel.frame.origin.x + _firstLabel.bounds.size.width, _firstLabel.frame.origin.y, _firstLabel.bounds.size.width, _firstLabel.bounds.size.height);
    if (start) {
        [self startAnimation];
    }
}



#pragma mark - Properties
- (UILabel *)firstLabel {
    if (_firstLabel == nil) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.textAlignment = NSTextAlignmentLeft;
        _firstLabel.font = [UIFont font_13];
        _firstLabel.textColor = [UIColor color_26];
        _firstLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstLabel;
}

- (UILabel *)secondLabel {
    if (_secondLabel == nil) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.textAlignment = NSTextAlignmentLeft;
        _secondLabel.font = [UIFont font_13];
        _secondLabel.textColor = [UIColor color_26];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondLabel;
}

- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        self.labelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelArray;
}


- (CGFloat)getStringWidth:(NSString *)string{
    if (string) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                           options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:[UIFont font_13]}
                                           context:nil];
        if (rect.size.width < self.width) {
            return self.width;
        }
        return rect.size.width;
    }
    return 0.f;
}


@end
