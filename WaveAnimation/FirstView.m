//
//  FirstView.m
//  WaveAnimation
//
//  Created by WXQ on 2018/9/4.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "FirstView.h"

#define K_WIDTH    CGRectGetWidth(self.frame)
#define K_HEIGHT   CGRectGetHeight(self.frame)
@interface FirstView ()
@property(nonatomic,strong)UIImageView * backImageView;
@property(nonatomic,strong)UIImageView * waveImageView;
@property(nonatomic,strong)CAShapeLayer * waveLayer;
@property(nonatomic,strong)CADisplayLink * displayLink;
//波浪相关的参数
@property(nonatomic,assign)CGFloat waveWidth;
@property(nonatomic,assign)CGFloat waveHeight;
@property(nonatomic,assign)CGFloat maxAmplitude;//最大振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
@property(nonatomic,assign)CGFloat phase;//初相，即波浪左右偏移量
@property(nonatomic,assign)CGFloat shiftPhase;//变化初相
@end

@implementation FirstView

- (instancetype)initWithFrame:(CGRect)frame waveStyle:(WaveAnimationStyle)waveStyle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.waveStyle = waveStyle;
        [self addSubview:self.backImageView];
        [self addSubview:self.waveImageView];
        self.waveWidth = CGRectGetWidth(self.backImageView.bounds);
        self.waveHeight = CGRectGetHeight(self.backImageView.bounds)/2;//设置波浪大小
        self.maxAmplitude = self.waveHeight * 0.1f;//振幅
        self.phase = 16;
        self.waveImageView.layer.mask = self.waveLayer;
        [self creatDisplayLink];
        [self startLoading];
    }
    return self;
}

- (void)creatDisplayLink {
    if (self.waveStyle == WaveAnimationStyleOne || self.waveStyle == WaveAnimationStyleTwo) {
        [_displayLink invalidate];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshWave:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)startLoading {
    if (self.waveStyle == WaveAnimationStyleOne) {
        self.waveLayer.frame = CGRectMake(0, K_HEIGHT/2, K_WIDTH, K_HEIGHT);
    }else if (self.waveStyle == WaveAnimationStyleTwo) {
        self.waveLayer.frame = CGRectMake(0, K_HEIGHT, K_WIDTH, K_HEIGHT);
        CGPoint position = self.waveLayer.position;
        position.y = position.y - K_HEIGHT;
        [self.waveLayer addAnimation:[self creatBasicAnimationFromValue:[NSValue valueWithCGPoint:self.waveLayer.position] toValue:[NSValue valueWithCGPoint:position] duration:3.0f] forKey:@"positionWave"];
    }else if (self.waveStyle == WaveAnimationStyleThree) {
        [self creatAcrossBezierPath];
        self.waveLayer.frame = CGRectMake(0, K_HEIGHT, K_WIDTH, K_HEIGHT);
        CGPoint position = self.waveLayer.position;
        position.y = position.y - K_HEIGHT - self.waveLayer.position.y/2;
        [self.waveLayer addAnimation:[self creatBasicAnimationFromValue:[NSValue valueWithCGPoint:self.waveLayer.position] toValue:[NSValue valueWithCGPoint:position] duration:1.0f] forKey:@"position"];
    }else if (self.waveStyle == WaveAnimationStyleFour) {
        [self creatObliqueBezierPath];
        self.waveLayer.frame = CGRectMake(-K_WIDTH, 0, K_WIDTH, K_HEIGHT);
        CGPoint position = self.waveLayer.position;
        position.x = position.x + K_WIDTH*2.0f;
        [self.waveLayer addAnimation:[self creatBasicAnimationFromValue:[NSValue valueWithCGPoint:self.waveLayer.position] toValue:[NSValue valueWithCGPoint:position] duration:1.0f] forKey:@"position"];
    }
}

#pragma mark - UI
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"project_list_gray_word"]];
        _backImageView.frame = self.bounds;
    }
    return _backImageView;
}

- (UIImageView *)waveImageView {
    if (!_waveImageView) {
        _waveImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"project_list_word"]];
        _waveImageView.frame = self.bounds;
    }
    return _waveImageView;
}

- (CAShapeLayer *)waveLayer {
    if (!_waveLayer) {
        _waveLayer = [CAShapeLayer layer];
    }
    return _waveLayer;
}

#pragma mark - UIBezierPath
//绘制正弦波浪--1 --2
- (void)refreshWave:(CADisplayLink *)displayLink {
    self.shiftPhase += self.phase;
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for (CGFloat x=0; x<self.waveWidth+1; x += 1) {
        endX = x;
        CGFloat y = self.maxAmplitude * sinf(2*M_PI/self.waveWidth * x + self.shiftPhase * M_PI/180);
        if (x == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        } else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    CGFloat endY = CGRectGetHeight(self.backImageView.bounds);
    [path addLineToPoint:CGPointMake(endX, endY)];
    [path addLineToPoint:CGPointMake(0, endY)];
    self.waveLayer.path = path.CGPath;
}
//--3
- (void)creatAcrossBezierPath {
    CGRect rect = CGRectMake(0, 0, K_WIDTH, K_HEIGHT/2);
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    self.waveLayer.path = path.CGPath;
}
//--4
- (void)creatObliqueBezierPath {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(K_WIDTH/2, 0)];
    [path addLineToPoint:CGPointMake(K_WIDTH, 0)];
    [path addLineToPoint:CGPointMake(K_WIDTH/2, K_HEIGHT)];
    [path addLineToPoint:CGPointMake(0, K_HEIGHT)];
    [path closePath];
    self.waveLayer.path = path.CGPath;
}
#pragma mark - 动画
- (CABasicAnimation *)creatBasicAnimationFromValue:(id)fromValue toValue:(id)toValue duration:(CFTimeInterval)duration {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    return animation;
}

- (void)dealloc {
    [_displayLink invalidate];
    [_waveLayer removeAllAnimations];
    _waveLayer.path = nil;
}
@end
