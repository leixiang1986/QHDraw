//
//  DrawPaletteView.m
//  lovewith
//
//  Created by imqiuhang on 15/4/22.
//  Copyright (c) 2015年 imqiuhang All rights reserved.
//

#import "DrawPaletteView.h"
#import "UIView+QHUIViewCtg.h"


@interface DrawPaletteView () {
    
@private
    //所有的线条信息，包含了颜色，坐标和粗细信息 @see DrawPaletteLineInfo
    NSMutableArray <__kindof DrawPaletteLineInfo *> *allMyDrawPaletteLineInfos;
    
}

@end
@implementation DrawPaletteView

#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        allMyDrawPaletteLineInfos = [[NSMutableArray alloc] initWithCapacity:10];
        self.currentPaintBrushColor = [UIColor blackColor];
        self.currentPaintBrushWidth =  4.f;
    }
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        allMyDrawPaletteLineInfos = [[NSMutableArray alloc] initWithCapacity:10];
        self.currentPaintBrushColor = [UIColor blackColor];
        self.currentPaintBrushWidth =  4.f;
    }
    
    return self;
}

#pragma  mark - draw event
//根据现有的线条 绘制相应的图画
- (void)drawRect:(CGRect)rect  {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    
    CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    if (allMyDrawPaletteLineInfos.count > 0) {
        for (int i = 0; i < [allMyDrawPaletteLineInfos count]; i++) {
            DrawPaletteLineInfo *info = allMyDrawPaletteLineInfos[i];
            

            CGContextSetLineWidth(context, info.lineWidth);
            
            CGFloat count = 12;
            
            for (int i = 0; i < count; i++) {
                if (i == 0) {
                    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                }
                else if (i == 1){
                    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
                    }
                else if (i == 2) {
                    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
                }
                else {
                    CGContextSetStrokeColorWithColor(context, info.lineColor.CGColor);
                }

                CGContextBeginPath(context);
                [self drawLine:info.linePoints rect:rect offset:CGPointMake(-CGRectGetMidX(rect), -CGRectGetMidY(rect))];
                CGContextStrokePath(context);

                CGContextBeginPath(context);
                [self drawOppositeLine:info.linePoints rect:rect offset:CGPointMake(-CGRectGetMidX(rect), -CGRectGetMidY(rect))];
                CGContextStrokePath(context);

                if (i == 0) {
                    CGContextRotateCTM(context, 360 / count * M_PI / 180);
                }
                else {
                    CGContextRotateCTM(context, 360 / count * M_PI / 180);
                }
            }
        }
    }
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextRotateCTM(context, 0);
}

- (void)drawLine:(NSMutableArray <__kindof NSValue *> *)linePoints rect:(CGRect)rect offset:(CGPoint)offset {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint myStartPoint = linePoints[0].CGPointValue;
    CGContextMoveToPoint(context, myStartPoint.x + offset.x, myStartPoint.y + offset.y);
    
    if (linePoints.count == 1) {
        CGContextAddLineToPoint(context, myStartPoint.x + offset.x, myStartPoint.y + offset.y);
    }
    else {
        for (int j = 0; j < linePoints.count - 1; j++) {
            CGPoint myEndPoint = linePoints[j + 1].CGPointValue;
            CGContextAddLineToPoint(context, myEndPoint.x + offset.x, myEndPoint.y + offset.y);
        }
    }
}

- (void)drawOppositeLine:(NSMutableArray <__kindof NSValue *> *)linePoints rect:(CGRect)rect offset:(CGPoint)offset {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint myStartPoint = linePoints[0].CGPointValue;
    CGContextMoveToPoint(context, myStartPoint.x + offset.x, rect.size.height - myStartPoint.y + offset.y);
    
    if (linePoints.count == 1) {
        CGContextAddLineToPoint(context, myStartPoint.x + offset.x, rect.size.height - myStartPoint.y + offset.y);
    }
    else {
        for (int j = 0; j < linePoints.count - 1; j++) {
            CGPoint myEndPoint = linePoints[j + 1].CGPointValue;
            CGContextAddLineToPoint(context, myEndPoint.x + offset.x, rect.size.height - myEndPoint.y + offset.y);
        }
    }
}



#pragma mark - touch event
//触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.anyObject locationInView:self];
    [self drawPaletteTouchesBeganWithWidth:self.currentPaintBrushWidth andColor:self.currentPaintBrushColor andBeginPoint:location];
    [self setNeedsDisplay];
}
//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.anyObject locationInView:self];
    [self drawPaletteTouchesMovedWithPonit:location];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark draw info edite event
//在触摸开始的时候 添加一条新的线条 并初始化
- (void)drawPaletteTouchesBeganWithWidth:(float)width andColor:(UIColor *)color andBeginPoint:(CGPoint)bPoint {
    DrawPaletteLineInfo *info = [DrawPaletteLineInfo new];
    info.lineColor = color;
    info.lineWidth = width;
    
    [info.linePoints addObject:[NSValue valueWithCGPoint:bPoint]];
    
    [allMyDrawPaletteLineInfos addObject:info];
}

//在触摸移动的时候 将现有的线条的最后一条的 point增加相应的触摸过的坐标
- (void)drawPaletteTouchesMovedWithPonit:(CGPoint)mPoint {
    DrawPaletteLineInfo *lastInfo = [allMyDrawPaletteLineInfos lastObject];
    [lastInfo.linePoints addObject:[NSValue valueWithCGPoint:mPoint]];
}

- (void)cleanAllDrawBySelf {
    if ([allMyDrawPaletteLineInfos count]>0)  {
        [allMyDrawPaletteLineInfos removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (void)cleanFinallyDraw {
    if ([allMyDrawPaletteLineInfos count]>0) {
        [allMyDrawPaletteLineInfos  removeLastObject];
    }
    [self setNeedsDisplay];
}


@end

@implementation DrawPaletteLineInfo

- (instancetype)init {
    if (self=[super init]) {
        self.linePoints = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

@end


