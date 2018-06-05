//
//  SZLStartPageManager.m
//  SZLTimberTrain
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLStartPageManager.h"

NSString * const kTBStartPage = @"startpage";

@implementation SZLStartPageManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static SZLStartPageManager * instance = nil;
    dispatch_once(&once, ^{
        instance = [[SZLStartPageManager alloc] init];
    });
    return instance;
}

- (NSString *)imgURL {
    return [[SZLInfoHelper shareInstance] getAsynchronousWithKey:kTBStartPage];
}

- (void)setImgURL:(NSString *)imgURL {
    if (imgURL.length == 0) { /** 启动图置空 */
        NSString * tmpURL = [[SZLInfoHelper shareInstance] getAsynchronousWithKey:kTBStartPage];
        if (tmpURL) {
            [self removeStartPageFoyKey:tmpURL];
            [[SZLInfoHelper shareInstance] clearAsynchronousWithKey:kTBStartPage];
        }
    }else{
        NSString * tmpURL = [[SZLInfoHelper shareInstance] getAsynchronousWithKey:kTBStartPage];
        if (![tmpURL isEqualToString:imgURL]) { /** 更改新的启动图 */
            [self removeStartPageFoyKey:tmpURL];
            [[SZLInfoHelper shareInstance] setAsynchronous:imgURL withKey:kTBStartPage];
            
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgURL] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
            }];
            /*
             [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imgURL] options:SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             
             }];*/
        }else{ /** 启动图未更改 判断缓存中是否存在该启动图 不存在重新下载 */
            [[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:imgURL completion:^(BOOL isInCache) {
                
                if (isInCache == NO) {
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgURL] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        
                    }];
                }
                
            }];
            
            /*
             if (![[[SDWebImageManager sharedManager] imageCache] diskImageExistsWithKey:imgURL]) {
             [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imgURL] options:SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             
             }];
             }*/
        }
    }
}

- (void)removeStartPageFoyKey:(NSString *)key {
    // 如果磁盘中存在这个page 则删除
    
    [[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:key completion:^(BOOL isInCache) {
        
        if (isInCache) {
            [[SDWebImageManager sharedManager].imageCache removeImageForKey:key fromDisk:YES withCompletion:^{
                
            }];
        }
        
    }];
    /*
     if ([[[SDWebImageManager sharedManager] imageCache] diskImageExistsWithKey:key]) {
     [[[SDWebImageManager sharedManager] imageCache] removeImageForKey:key];
     }*/
}

@end
