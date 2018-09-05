# WaveLoadAnimation
UIBezierPath制作水波浪加载动画（仿百度贴吧）

### 动画效果：

![水波浪加载动画](https://github.com/wuyukobe24/WaveLoadAnimation/blob/master/水波浪.gif)

正弦曲线百度百科：
```
正弦曲线可表示为y=Asin(ωx+φ)+k，定义为函数y=Asin(ωx+φ)+k在直角坐标系上的图象，其中sin为正弦符号，x是直角坐标系 X 轴上的数值，y是在同一直角坐标系上函数对应的y值，k、ω和φ是常数（k、ω、φ∈R且ω≠0）。
A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。（控制波浪上下高度）
(ωx+φ)——相位，反映变量y所处的状态。
φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。(控制波浪左右偏移速度)
k——偏距，反映在坐标系上则为图像的上移或下移。
ω——角速度， 控制正弦周期(单位弧度内震动的次数)。（角速度ω变大，则波形在X轴上收缩（波形变紧密）；角速度ω变小，则波形在X轴上延展（波形变稀疏））。
```

### 核心代码：

正弦曲线参数设置：
```
self.waveWidth = CGRectGetWidth(self.backImageView.bounds);
self.waveHeight = CGRectGetHeight(self.backImageView.bounds)/2;//设置波浪大小
self.maxAmplitude = self.waveHeight * 0.1f;//振幅
self.phase = 16;
```

绘制正弦曲线：
```
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
```

创建DisplayLink，实时刷新正弦曲线：
```
_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshWave:)];
[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];   
```

下面三个动画需要设置位置，添加移动动画：
```
self.waveLayer.frame = CGRectMake(0, K_HEIGHT, K_WIDTH, K_HEIGHT);
CGPoint position = self.waveLayer.position;
position.y = position.y - K_HEIGHT;
[self.waveLayer addAnimation:[self creatBasicAnimationFromValue:[NSValue valueWithCGPoint:self.waveLayer.position] toValue:[NSValue valueWithCGPoint:position] duration:3.0f] forKey:@"positionWave"];
```
动画：
```
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
```

总结：其实显示原理就是用动画在UIBezierPath绘制的封闭路径中实时显示路径在waveImageView中裁剪的图片区域罢了。
