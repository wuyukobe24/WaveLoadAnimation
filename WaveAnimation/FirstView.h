//
//  FirstView.h
//  WaveAnimation
//
//  Created by WXQ on 2018/9/4.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, WaveAnimationStyle) {
    WaveAnimationStyleOne,
    WaveAnimationStyleTwo,
    WaveAnimationStyleThree,
    WaveAnimationStyleFour
};
@interface FirstView : UIView
@property(nonatomic,assign)WaveAnimationStyle waveStyle;
- (instancetype)initWithFrame:(CGRect)frame waveStyle:(WaveAnimationStyle)waveStyle;
- (void)startLoading;
@end
