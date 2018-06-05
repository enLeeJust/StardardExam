//
//  SZLImageHelper.h
//  SZLTimber
//
//  Created by 桂舟 on 16/10/27.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZLImageHelper : NSObject

/**
 *  压缩图片
 *
 *  @param targetSize 压缩大小
 *  @param srcImg     原图
 *
 *  @return 修改后的图片
 */

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImg:(UIImage *)srcImg;
@end
