//
//  DEVICE.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import"DeviceManager.h"

#ifndef ______DEVICE_h
#define ______DEVICE_h

#define ISIOS7ADD ISIOS7

#define HEIGHT [DeviceManager currentScreenHeight]

#define WIDTH [DeviceManager currentScreenWidth]

#define ISIOS7 [DeviceManager isIOS7Version]
// iOS7的话，就是我们的屏幕是从（0，0）开始的
#define ISIOS8 [DeviceManager isIOS8Version]

#define ISIOS9 [DeviceManager isIOS9Version]

#define ISIOS10 [DeviceManager isIOS10Version]

#define MODEL [DeviceManager currentDeviceModel]

#define ISIPHONE_4 [DeviceManager isIphone4]

#define ISIPHONE_5 [DeviceManager isIphone5]

#define ISIPHONE_6 [DeviceManager isIphone6]

#define ISIPHONE_6p [DeviceManager isIphone6p]

#define ISIPHONE [DeviceManager isIphone]

#define isPhoneX ([UIScreen mainScreen].bounds.size.width == 812 || [UIScreen mainScreen].bounds.size.height == 812)

#define NavHeight (isPhoneX ? 88 : 64)
#define StatusHeight (isPhoneX ? 44 : 20)
#define NavBarHeight 44
#define TabHeight (isPhoneX ? 83 : 49)
#define BottomCornerRadius (isPhoneX ? 34 : 0)
#define HomeIndicatorTop (isPhoneX ? 14 : 0)

#define DeviceAndOSInfo [DeviceManager getDeviceAndOSInfo]

#endif
