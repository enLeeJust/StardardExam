//
//  TNCheckBoxData.h
//  TNCheckBoxDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TNCheckBoxData : NSObject{
    
}

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) NSInteger tag;
@property (nonatomic) BOOL checked;

@property (nonatomic, copy) NSString *labelText;

@property (nonatomic, weak) UIFont *labelFont;
@property (nonatomic, weak) UIColor *labelColor;
@property (nonatomic,copy)NSString* HavePic;
@property (nonatomic,strong)NSMutableArray *picUrls;
@end
