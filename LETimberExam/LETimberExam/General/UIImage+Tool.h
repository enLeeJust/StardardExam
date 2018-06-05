//
//  UIImage+Tool.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)
/**
 *  返回虚线image的方法
 *
 *  @param imageView 创建一个imageView 高度是你想要的虚线的高度 一般设为2
 *
 *  @return 返回虚线image
 */
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView;
/**
 *  保持原来的长宽比，生成一个缩略图
 *
 *  @param image 原图
 *  @param asize 原尺寸
 *
 *  @return 新缩略图
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

/**
 *  根据颜色返回图片
 *
 *  @param color 需要的颜色
 *
 *  @return 颜色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
