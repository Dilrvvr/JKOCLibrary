//
//  JKOCUtility.m
//  JKOCLibrary
//
//  Created by albert on 10/25/22.
//

#import "JKOCUtility.h"
#import <AudioToolbox/AudioToolbox.h>
#import "sys/utsname.h"
#import <mach/mach.h>

NSString * const JKOCLibraryPodName = @"JKOCLibrary";

/// 获取资源图片失败的回调
static JKOCImageFailedBlock sw_oc_resourceImageFailedHandler;

@implementation JKOCUtility

+ (NSString *)developmentTeamId {
    
    static NSString *buPreStr = nil;
    
    if (buPreStr.length == 0) {
        
        @try {
            
            NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys: (id)kSecClassGenericPassword, kSecClass, @"bundleIDPrefix", kSecAttrAccount, @"", kSecAttrService, (id)kCFBooleanTrue, kSecReturnAttributes, nil];
            
            CFDictionaryRef result = nil;
            
            OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
            
            if (status == errSecItemNotFound) {
                
                status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
            }
            
            if (status != errSecSuccess) {
                
                return nil;
            }
            
            NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(id)kSecAttrAccessGroup];
            
            NSLog(@"accessGroup: %@", accessGroup);
            
            NSArray *components = [accessGroup componentsSeparatedByString:@"."];
            
            buPreStr = [[components objectEnumerator] nextObject]; CFRelease(result);
            
        } @catch(NSException *exception) {
            
        }
    }
    
    return buPreStr;
}

/// 竖屏的屏幕宽度
+ (CGFloat)portraitScreenWidth {
    
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

/// 竖屏的屏幕高度
+ (CGFloat)portraitScreenHeight {
    
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

/// 竖屏的屏幕bounds
+ (CGRect)portraitScreenBounds {
    
    return CGRectMake(0.0, 0.0, [self portraitScreenWidth], [self portraitScreenHeight]);
}

/// 当前是否竖屏
+ (BOOL)isPortrait {
    
    if (@available(iOS 16.0, *)) {
        
        UIWindowScene *windowScene = [self currentWindowScene];
        
        if (windowScene &&
            [windowScene isKindOfClass:[UIWindowScene class]]) {
            
            return UIInterfaceOrientationIsPortrait(windowScene.interfaceOrientation);
        }
    }
    
    return [UIScreen mainScreen].bounds.size.height >= [UIScreen mainScreen].bounds.size.width;
}

/// 当前是否横屏
+ (BOOL)isLandscape {
    
    if (@available(iOS 16.0, *)) {
        
        UIWindowScene *windowScene = [self currentWindowScene];
        
        if (windowScene &&
            [windowScene isKindOfClass:[UIWindowScene class]]) {
            
            return UIInterfaceOrientationIsLandscape(windowScene.interfaceOrientation);
        }
    }
    
    return [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height;
}

/// 是否iPhone
+ (BOOL)isDeviceiPhone {
    
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

/// 是否iPad
+ (BOOL)isDeviceiPad {
    
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

/// 是否iPhone X设备
+ (BOOL)isDeviceX {
    
    static BOOL isDeviceX_ = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (![self isDeviceiPhone]) { return; }
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        BOOL isDeviceXType = CGSizeEqualToSize(CGSizeMake(375.0, 812.0), screenBounds.size);
        BOOL isDeviceXMaxType = CGSizeEqualToSize(CGSizeMake(414.0, 896.0), screenBounds.size);
        
        BOOL isDevice12Type = CGSizeEqualToSize(CGSizeMake(390.0, 844.0), screenBounds.size);
        BOOL isDevice12MaxType = CGSizeEqualToSize(CGSizeMake(428.0, 926.0), screenBounds.size);
        
        BOOL isDevice14ProType = CGSizeEqualToSize(CGSizeMake(393.0, 852.0), screenBounds.size);
        BOOL isDevice14ProMaxType = CGSizeEqualToSize(CGSizeMake(430.0, 932.0), screenBounds.size);
        
        // 如有新设备，在此添加
        // 并更新SWiPhoneMaxScreenWidth
        
        isDeviceX_ = (isDeviceXType ||
                      isDeviceXMaxType ||
                      isDevice12Type ||
                      isDevice12MaxType ||
                      isDevice14ProType ||
                      isDevice14ProMaxType);
    });
    
    return isDeviceX_;
}

/// 当前的windowScene
+ (UIWindowScene *)currentWindowScene API_AVAILABLE(ios(13.0)) {
    
    NSSet *connectedScenes = UIApplication.sharedApplication.connectedScenes;
    
    if (connectedScenes.count < 1) { return nil; }
    
    if (connectedScenes.count == 1) {
        
        UIWindowScene *windowScene = connectedScenes.anyObject;
        
        if ([windowScene isKindOfClass:[UIWindowScene class]]) {
            
            return windowScene;
        }
        
        return nil;
    }
    
    for (UIWindowScene *windowScene in connectedScenes) {
        
        if (![windowScene isKindOfClass:[UIWindowScene class]]) { continue; }
        
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            
            return windowScene;
        }
    }
    
    return nil;
}

/// 当前windowScene的window
+ (UIWindow *)currentSceneWindow {
    
    if (@available(iOS 13.0, *)) {
        
        UIWindowScene *windowScene = [self currentWindowScene];
        
        if (!windowScene ||
            ![windowScene isKindOfClass:[UIWindowScene class]]) {
            
            return nil;
        }
        
        id delegate = windowScene.delegate;
        
        if ([delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)] &&
            [delegate respondsToSelector:@selector(window)]) {
            
            return [delegate window];
        }
        
        if (@available(iOS 15.0, *)) {
            
            if (windowScene.keyWindow != nil) {
                
                return windowScene.keyWindow;
            }
        }
        
        if (windowScene.windows.count < 1) {
            
            return nil;
        }
        
        if (windowScene.windows.count == 1) {
            
            return windowScene.windows.firstObject;
        }
        
        for (UIWindow *window in windowScene.windows) {
            
            if (window.isHidden) { continue; }
            
            if (window.isKeyWindow) {
                
                return window;
            }
            
            return window;
        }
    }
    
    return nil;
}

/// keyWindow
+ (UIWindow *)keyWindow {
    
    // TODO: - JKTODO 目前只有单window模式，暂不适配多window模式
    //return [UIApplication sharedApplication].delegate.window;
    
    if (defaultWindow_ != nil &&
        [defaultWindow_ isKindOfClass:[UIWindow class]]) {
        
        return defaultWindow_;
    }
    
    UIWindow *keyWindow = nil;
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        
        keyWindow = [[UIApplication sharedApplication].delegate window];
        
    } else {
        
        keyWindow = [self currentSceneWindow];
    }
    
    return keyWindow;
}

/// 安全区域 insets
+ (UIEdgeInsets)safeAreaInset {
    
    if (@available(iOS 11.0, *)) {
        
        return [self keyWindow].safeAreaInsets;
    }
    
    return UIEdgeInsetsZero;
}

/// 状态栏高度
+ (CGFloat)statusBarHeight {
    
    if (@available(iOS 11.0, *)) {
        
        CGFloat topInset = [self safeAreaInset].top;
        
        if ([self isDeviceiPad]) {
            
            return topInset > 0.0 ? topInset : 24.0;
        }
        
        return topInset;
    }
    
    return 20.0;
}

/// 导航条高度
+ (CGFloat)navigationBarHeight {
    
    // 小屏iPad高度为70，这里全部处理为74
    if ([self isDeviceiPad]) { return 74.0; }
    
    if ([self isLandscape]) {
        
        return MIN(JKScreenWidth, JKScreenHeight) > 400.0 ? 44.0 : 32.0;
    }
    
    return [self statusBarHeight] + 44.0;
}

/// 底部安全区域高度
+ (CGFloat)bottomSafeAreaInset {
    
    return [self safeAreaInset].bottom;
}

/// tabBar高度
+ (CGFloat)tabBarHeight {
    
    if (JKisPortrait) { // 竖屏
        
        return JKBottomSafeAreaInset + 49.0;
    }
    
    // 横屏
    
    if (JKisDeviceiPad ||
        MIN(JKScreenWidth, JKScreenHeight) > 400.0) { // iPad和大屏iPhone
        
        return JKBottomSafeAreaInset + 49.0;
    }
    
    return JKBottomSafeAreaInset + 32.0;
}

/// 分隔线粗细
+ (CGFloat)lineThickness {
    
    static CGFloat lineThickness_ = 0.0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lineThickness_ = 1.0 / [UIScreen mainScreen].scale;
    });
    
    return lineThickness_;
}

/// 分隔线颜色 浅色模式
+ (UIColor *)lineLightColor {
    
    return [UIColor colorWithRed:60.0 / 255.0 green:60.0 / 255.0 blue:67.0 / 255.0 alpha:0.29];
}

/// 分隔线颜色 深色模式
+ (UIColor *)lineDarkColor {
    
    return [UIColor colorWithRed:84.0 / 255.0 green:84.0 / 255.0 blue:88.0 / 255.0 alpha:0.6];
}

/// 系统红色
+ (UIColor *)systemRedColor {
    
    return [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0];
}

/// 系统蓝色
+ (UIColor *)systemBlueColor {
    
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
}

/// 目前iPhone屏幕最大宽度
+ (CGFloat)iPhoneMaxScreenWidth {
    
    return 430.0;
}

/// 屏幕适配放大比例 仅小屏幕缩放，大屏幕 不放大
+ (CGFloat)zoomScale {
    
    static CGFloat zoomScale_ = 0.0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        zoomScale_ = MIN(1.0, [self zoomLargeScale]);
    });
    
    return zoomScale_;
}

/// 屏幕适配放大比例 小屏幕缩放，大屏幕 放大
+ (CGFloat)zoomLargeScale {
    
    static CGFloat zoomLargeScale_ = 0.0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGFloat screenWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        
        screenWidth = MIN(screenWidth, [self iPhoneMaxScreenWidth]);
        
        zoomLargeScale_ = screenWidth / 375.0;
    });
    
    return zoomLargeScale_;
}

static __weak UIWindow *defaultWindow_ = nil;

/// 设置默认window，设置后若有值则keyWindow返回此值
+ (void)makeDefaultWindow:(UIWindow *)window {
    
    defaultWindow_ = window;
}

/// 让手机振动一下
+ (void)vibrateDevice {
    
    // iPad没有振动
    if ([self isDeviceiPad]) { return; }
    
    if (@available(iOS 10.0, *)) {
        
        UIImpactFeedbackGenerator *feedbackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        
        [feedbackGenertor impactOccurred];
    }
}

/// 播放收到推送通知的那种振动，受系统控制
+ (void)playNotificationVibrate {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

/// 播放通知声音，受系统控制
+ (void)playNotificationSound {
    
    NSString *path = @"/System/Library/Audio/UISounds/sms-received1.caf";
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    SystemSoundID sound = 0;
    
    OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
    
    if (status == kAudioServicesNoError) {
        
        AudioServicesPlaySystemSound(sound);
    }
}

/// rgb Color alpha默认1
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    return [self colorWithRed:red green:green blue:blue alpha:1.0];
}

/// rgba color
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

/// rgb相同color alpha默认1
+ (UIColor *)sameRGBColor:(CGFloat)rgb {
    
    return [self sameRGBColor:rgb alpha:1.0];
}

/// rgb相同color alpha
+ (UIColor *)sameRGBColor:(CGFloat)rgb alpha:(CGFloat)alpha {
    
    return [self colorWithRed:rgb green:rgb blue:rgb alpha:alpha];
}

/// 随机颜色
+ (UIColor *)randomColor {
    
    return [self randomColorWithAlpha:1.0];
}

/// 随机颜色 alpha
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha {
    
    CGFloat r = (CGFloat)arc4random_uniform(256);
    CGFloat g = (CGFloat)arc4random_uniform(256);
    CGFloat b = (CGFloat)arc4random_uniform(256);
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

/// 根据颜色创建图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size opaque:(BOOL)opaque {
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/// 读取资源图片失败的回调
+ (void)makeResourceImageFailedHandler:(JKOCImageFailedBlock)handler {
    
    sw_oc_resourceImageFailedHandler = handler;
}

/**
 * 读取资源中的图片
 * name: 无须添加@2x.png/@3x.png，类似UIImage(named: name)即可
 * 读取失败使用 +makeResourceImageFailedHandler处理
 */
+ (UIImage *)resourceImageNamed:(NSString *)name {
    
    return [self resourceImageNamed:name pathExtension:@"png"];
}

/**
 * 读取资源中的图片
 * name: 无须添加@2x.png/@3x.png，类似UIImage(named: name)即可
 * pathExtension: 传nil则默认 "png"，如其它格式则传对应格式后缀名，不包括小数点
 * 读取失败使用 +makeResourceImageFailedHandler处理
 */
+ (UIImage *)resourceImageNamed:(NSString *)name pathExtension:(NSString *)pathExtension {
    
    if (!name ||
        ![name isKindOfClass:[NSString class]]) {
        
        return nil;
    }
    
    NSString *realName = [name copy];
    
    NSString *filePathExtension = [pathExtension copy];
    
    if (!pathExtension) {
        
        filePathExtension = @"png";
    }
    
    static NSBundle *resourceBundle = nil;
    
    if (!resourceBundle) {
        
        resourceBundle = [NSBundle bundleForClass:[self class]];
    }
    
    // 读取bundle失败
    if (!resourceBundle) {
        
        return [self solveResourceImageReadFailedWithName:realName];
    }
    
    NSString *bundlePath = [resourceBundle pathForResource:@"JKOCLibraryResource" ofType:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithPath:bundlePath];
    
    // 读取bundle失败
    if (!imageBundle) {
        
        return [self solveResourceImageReadFailedWithName:realName];
    }
    
    // 直接根据名称读取图片
    UIImage *image = [UIImage imageNamed:realName inBundle:imageBundle compatibleWithTraitCollection:nil];
    
    if (image) { return image; }
    
    // 根据图片全名读取图片
    NSInteger scale = (NSInteger)([UIScreen mainScreen].scale);
    NSString *fullName = [NSString stringWithFormat:@"%@@%zdx.%@", realName, scale, filePathExtension];
    image = [UIImage imageNamed:fullName inBundle:imageBundle compatibleWithTraitCollection:nil];
    
    if (image) { return image; }
    
    // 根据路径使用contentsOfFile读取图片
    NSString *imagePath = [imageBundle pathForResource:fullName ofType:nil];
    image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (image) { return image; }
    
    return [self solveResourceImageReadFailedWithName:realName];
}

+ (UIImage *)solveResourceImageReadFailedWithName:(NSString *)name {
    
    if (sw_oc_resourceImageFailedHandler) {
        
        return sw_oc_resourceImageFailedHandler(name);
    }
    
    return nil;
}



#pragma mark
#pragma mark - 日期格式化

/// "yyyy-MM-dd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
+ (NSString *)stringFromDate_yyyyMMdd_horizontal_line:(NSDate *)date {
    
    return [self stringFromDate:date format:@"%Y-%m-%d"];
}

/// "yyyyMMdd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
+ (NSString *)stringFromDate_yyyyMMdd:(NSDate *)date {
    
    return [self stringFromDate:date format:@"%Y%m%d"];
}

/// "yyyyMMdd HH:mm:ss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
+ (NSString *)stringFromDateNormal:(NSDate *)date {
    
    return [self stringFromDate:date format:@"%Y-%m-%d %H:%M:%S"];
}

/**
 * format格式: "%Y-%m-%d %H:%M:%S"
 * date无需增加时区偏移
 * date/format为空或出错时返回空字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    
    if (!date || !format) {
        
        return @"";
    }
    
    char buffer[100];
    
    // "%Y年%m月%d日%H时%M分%S秒"
    
    const char *cFormat = [format cStringUsingEncoding:(NSUTF8StringEncoding)];
    
    time_t timeInterval = [date timeIntervalSince1970];
    
    strftime(buffer, sizeof(buffer), cFormat, localtime(&timeInterval));
    
    NSString *string = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
    return string ? string : @"";
}

#pragma mark
#pragma mark - 设备信息

/// 设备型号名称 e.g. @"iPhone 12", @"iPhone 12 Pro Max"
+ (NSString *)deviceModelName {
    
    static NSString *deviceModelName_ = nil;
    
    if (!deviceModelName_) {
        
        NSString *identifier = [self deviceIdentifier];
        
        NSDictionary *dict = [self deviceIdentifierDictionary];
        
        NSString *modelName = dict[identifier];
        
        if (modelName) {
            
            deviceModelName_ = modelName;
            
        } else if ([[identifier lowercaseString] hasPrefix:@"arm"]) {
            
            deviceModelName_ = @"Simulator";
            
        } else {
            
            modelName = [NSString stringWithFormat:@"unknown(%@)", [self deviceIdentifier]];
        }
        
        deviceModelName_ = modelName;
    }
    
    return deviceModelName_;
}

/// 设备硬件标识 e.g. @"iPhone13,2", @"iPhone13,3"
+ (NSString *)deviceIdentifier {
    
    static NSString *machineString_ = nil;
    
    if (!machineString_) {
        
        // 需要#import "sys/utsname.h"
        struct utsname systemInfo;
        
        uname(&systemInfo);
        
        machineString_ = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    
    return machineString_;
}

/// [设备硬件标识 : 型号名称] 对应字典
+ (NSDictionary *)deviceIdentifierDictionary {
    
    return @{
        
        // iPhone
        
        @"iPhone1,1" : @"iPhone",
        
        @"iPhone1,2" : @"iPhone 3G",
        
        @"iPhone2,1" : @"iPhone 3GS",
        
        @"iPhone3,1" : @"iPhone 4",
        @"iPhone3,2" : @"iPhone 4",
        @"iPhone3,3" : @"iPhone 4",
        
        @"iPhone4,1" : @"iPhone 4S",
        
        @"iPhone5,1" : @"iPhone 5",
        @"iPhone5,2" : @"iPhone 5",
        
        @"iPhone5,3" : @"iPhone 5c",
        @"iPhone5,4" : @"iPhone 5c",
        
        @"iPhone6,1" : @"iPhone 5s",
        @"iPhone6,2" : @"iPhone 5s",
        
        @"iPhone7,2" : @"iPhone 6",
        @"iPhone7,1" : @"iPhone 6 Plus",
        
        @"iPhone8,1" : @"iPhone 6s",
        @"iPhone8,2" : @"iPhone 6s Plus",
        
        @"iPhone8,4" : @"iPhone SE (1st generation)",
        
        @"iPhone9,1" : @"iPhone 7",
        @"iPhone9,3" : @"iPhone 7",
        @"iPhone9,2" : @"iPhone 7 Plus",
        @"iPhone9,4" : @"iPhone 7 Plus",
        
        @"iPhone10,1" : @"iPhone 8",
        @"iPhone10,4" : @"iPhone 8",
        @"iPhone10,2" : @"iPhone 8 Plus",
        @"iPhone10,5" : @"iPhone 8 Plus",
        
        @"iPhone10,3" : @"iPhone X",
        @"iPhone10,6" : @"iPhone X",
        
        @"iPhone11,8" : @"iPhone XR",
        @"iPhone11,2" : @"iPhone XS",
        @"iPhone11,4" : @"iPhone XS Max",
        @"iPhone11,6" : @"iPhone XS Max",
        
        @"iPhone12,1" : @"iPhone 11",
        @"iPhone12,3" : @"iPhone 11 Pro",
        @"iPhone12,5" : @"iPhone 11 Pro Max",
        
        @"iPhone12,8" : @"iPhone SE (2nd generation)",
        
        @"iPhone13,1" : @"iPhone 12 mini",
        @"iPhone13,2" : @"iPhone 12",
        @"iPhone13,3" : @"iPhone 12 Pro",
        @"iPhone13,4" : @"iPhone 12 Pro Max",
        
        @"iPhone14,4" : @"iPhone 13 mini",
        @"iPhone14,5" : @"iPhone 13",
        @"iPhone14,2" : @"iPhone 13 Pro",
        @"iPhone14,3" : @"iPhone 13 Pro Max",
        
        @"iPhone14,6" : @"iPhone SE (3rd generation)",
        
        @"iPhone14,7" : @"iPhone 14",
        @"iPhone14,8" : @"iPhone 14 Plus",
        @"iPhone15,2" : @"iPhone 14 Pro",
        @"iPhone15,3" : @"iPhone 14 Pro Max",
        
        @"iPhone15,4" : @"iPhone 15",
        @"iPhone15,5" : @"iPhone 15 Plus",
        @"iPhone16,1" : @"iPhone 15 Pro",
        @"iPhone16,2" : @"iPhone 15 Pro Max",
        
        
        // iPod touch
        
        @"iPod1,1" : @"iPod touch",
        
        @"iPod2,1" : @"iPod touch (2nd generation)",
        
        @"iPod3,1" : @"iPod touch (3rd generation)",
        
        @"iPod4,1" : @"iPod touch (4th generation)",
        
        @"iPod5,1" : @"iPod touch (5th generation)",
        
        @"iPod7,1" : @"iPod touch (6th generation)",
        
        @"iPod9,1" : @"iPod touch (7th generation)",
        
        
        // iPad
        
        @"iPad1,1" : @"iPad",
        @"iPad1,2" : @"iPad",
        
        @"iPad2,1" : @"iPad 2",
        @"iPad2,2" : @"iPad 2",
        @"iPad2,3" : @"iPad 2",
        @"iPad2,4" : @"iPad 2",
        
        @"iPad3,1" : @"iPad (3rd generation)",
        @"iPad3,2" : @"iPad (3rd generation)",
        @"iPad3,3" : @"iPad (3rd generation)",
        
        @"iPad3,4" : @"iPad (4th generation)",
        @"iPad3,5" : @"iPad (4th generation)",
        @"iPad3,6" : @"iPad (4th generation)",
        
        @"iPad6,11" : @"iPad (5th generation)",
        @"iPad6,12" : @"iPad (5th generation)",
        
        @"iPad7,5" : @"iPad (6th generation)",
        @"iPad7,6" : @"iPad (6th generation)",
        
        @"iPad7,11" : @"iPad (7th generation)",
        @"iPad7,12" : @"iPad (7th generation)",
        
        @"iPad11,6" : @"iPad (8th generation)",
        @"iPad11,7" : @"iPad (8th generation)",
        
        @"iPad12,1" : @"iPad (9th generation)",
        @"iPad12,2" : @"iPad (9th generation)",
        
        @"iPad13,18" : @"iPad (10th generation)",
        @"iPad13,19" : @"iPad (10th generation)",
        
        
        // iPad mini
        
        @"iPad2,5" : @"iPad mini",
        @"iPad2,6" : @"iPad mini",
        @"iPad2,7" : @"iPad mini",
        
        @"iPad4,4" : @"iPad mini 2",
        @"iPad4,5" : @"iPad mini 2",
        @"iPad4,6" : @"iPad mini 2",
        
        @"iPad4,7" : @"iPad mini 3",
        @"iPad4,8" : @"iPad mini 3",
        @"iPad4,9" : @"iPad mini 3",
        
        @"iPad5,1" : @"iPad mini 4",
        @"iPad5,2" : @"iPad mini 4",
        
        @"iPad11,1" : @"iPad mini (5th generation)",
        @"iPad11,2" : @"iPad mini (5th generation)",
        
        @"iPad14,1" : @"iPad mini (6th generation)",
        @"iPad14,2" : @"iPad mini (6th generation)",
        
        
        // iPad Air
        
        @"iPad4,1" : @"iPad Air",
        @"iPad4,2" : @"iPad Air",
        @"iPad4,3" : @"iPad Air",
        
        @"iPad5,3" : @"iPad Air 2",
        @"iPad5,4" : @"iPad Air 2",
        
        @"iPad11,3" : @"iPad Air (3rd generation)",
        @"iPad11,4" : @"iPad Air (3rd generation)",
        
        @"iPad13,1" : @"iPad Air (4th generation)",
        @"iPad13,2" : @"iPad Air (4th generation)",
        
        @"iPad13,16" : @"iPad Air (5th generation)",
        @"iPad13,17" : @"iPad Air (5th generation)",
        
        
        // iPad Pro
        
        @"iPad6,3" : @"iPad Pro (9.7-inch)",
        @"iPad6,4" : @"iPad Pro (9.7-inch)",
        
        @"iPad6,7" : @"iPad Pro (12.9-inch)",
        @"iPad6,8" : @"iPad Pro (12.9-inch)",
        
        @"iPad7,1" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,2" : @"iPad Pro (12.9-inch) (2nd generation)",
        
        @"iPad7,3" : @"iPad Pro (10.5-inch)",
        @"iPad7,4" : @"iPad Pro (10.5-inch)",
        
        @"iPad8,1" : @"iPad Pro (11-inch)",
        @"iPad8,2" : @"iPad Pro (11-inch)",
        @"iPad8,3" : @"iPad Pro (11-inch)",
        @"iPad8,4" : @"iPad Pro (11-inch)",
        
        @"iPad8,5" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,6" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,7" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,8" : @"iPad Pro (12.9-inch) (3rd generation)",
        
        @"iPad8,9" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,10" : @"iPad Pro (11-inch) (2nd generation)",
        
        @"iPad8,11" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad8,12" : @"iPad Pro (12.9-inch) (4th generation)",
        
        @"iPad13,4" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,5" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,6" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,7" : @"iPad Pro (11-inch) (3rd generation)",
        
        @"iPad13,8" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,9" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,10" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,11" : @"iPad Pro (12.9-inch) (5th generation)",
        
        @"iPad14,3" : @"iPad Pro (11-inch) (4th generation)",
        @"iPad14,4" : @"iPad Pro (11-inch) (4th generation)",
        
        @"iPad14,5" : @"iPad Pro (12.9-inch) (6th generation)",
        @"iPad14,6" : @"iPad Pro (12.9-inch) (6th generation)",
        
        @"iPad14,3-A" : @"iPad Pro (11-inch) (4th generation)",
        @"iPad14,3-B" : @"iPad Pro (11-inch) (4th generation)",
        @"iPad14,4-A" : @"iPad Pro (11-inch) (4th generation)",
        @"iPad14,4-B" : @"iPad Pro (11-inch) (4th generation)",
        
        @"iPad14,5-A" : @"iPad Pro (12.9-inch) (6th generation)",
        @"iPad14,5-B" : @"iPad Pro (12.9-inch) (6th generation)",
        @"iPad14,6-A" : @"iPad Pro (12.9-inch) (6th generation)",
        @"iPad14,6-B" : @"iPad Pro (12.9-inch) (6th generation)",
        
        
        // Apple Watch
        
        @"Watch1,1" : @"Apple Watch (1st generation) 38mm",
        @"Watch1,2" : @"Apple Watch (1st generation) 42mm",
        
        @"Watch2,6" : @"Apple Watch Series 1 38mm",
        @"Watch2,7" : @"Apple Watch Series 1 42mm",
        
        @"Watch2,3" : @"Apple Watch Series 2 38mm",
        @"Watch2,4" : @"Apple Watch Series 2 42mm",
        
        @"Watch3,1" : @"Apple Watch Series 3 (GPS + Cellular) 38mm",
        @"Watch3,2" : @"Apple Watch Series 3 (GPS + Cellular) 42mm",
        
        @"Watch3,3" : @"Apple Watch Series 3 (GPS) 38mm",
        @"Watch3,4" : @"Apple Watch Series 3 (GPS) 42mm",
        
        @"Watch4,1" : @"Apple Watch Series 4",
        @"Watch4,2" : @"Apple Watch Series 4",
        @"Watch4,3" : @"Apple Watch Series 4",
        @"Watch4,4" : @"Apple Watch Series 4",
        
        @"Watch5,1" : @"Apple Watch Series 5",
        @"Watch5,2" : @"Apple Watch Series 5",
        @"Watch5,3" : @"Apple Watch Series 5",
        @"Watch5,4" : @"Apple Watch Series 5",
        
        @"Watch5,9" : @"Apple Watch SE (GPS)",
        @"Watch5,10" : @"Apple Watch SE (GPS)",
        @"Watch5,11" : @"Apple Watch SE (GPS + Cellular)",
        @"Watch5,12" : @"Apple Watch SE (GPS + Cellular)",
        
        @"Watch6,1" : @"Apple Watch Series 6 (GPS)",
        @"Watch6,2" : @"Apple Watch Series 6 (GPS)",
        @"Watch6,3" : @"Apple Watch Series 6 (GPS + Cellular)",
        @"Watch6,4" : @"Apple Watch Series 6 (GPS + Cellular)",
        
        @"Watch6,6" : @"Apple Watch Series 7 (GPS)",
        @"Watch6,7" : @"Apple Watch Series 7 (GPS)",
        @"Watch6,8" : @"Apple Watch Series 7 (GPS + Cellular)",
        @"Watch6,9" : @"Apple Watch Series 7 (GPS + Cellular)",
        
        @"Watch6,10" : @"Apple Watch SE (GPS)",
        @"Watch6,11" : @"Apple Watch SE (GPS)",
        @"Watch6,12" : @"Apple Watch SE (GPS + Cellular)",
        @"Watch6,13" : @"Apple Watch SE (GPS + Cellular)",
        
        @"Watch6,14" : @"Apple Watch Series 8 (GPS)",
        @"Watch6,15" : @"Apple Watch Series 8 (GPS)",
        @"Watch6,16" : @"Apple Watch Series 8 (GPS + Cellular)",
        @"Watch6,17" : @"Apple Watch Series 8 (GPS + Cellular)",
        
        @"Watch6,18" : @"Apple Watch Ultra",
        
        @"Watch7,1" : @"Apple Watch Series 9 (GPS)",
        @"Watch7,2" : @"Apple Watch Series 9 (GPS)",
        @"Watch7,3" : @"Apple Watch Series 9 (GPS + Cellular)",
        @"Watch7,4" : @"Apple Watch Series 9 (GPS + Cellular)",
        
        @"Watch7,5" : @"Apple Watch Ultra 2",
        
        
        // Apple TV
        
        @"AppleTV1,1" : @"Apple TV (1st generation)",
        
        @"AppleTV2,1" : @"Apple TV (2nd generation)",
        
        @"AppleTV3,1" : @"Apple TV (3rd generation)",
        @"AppleTV3,2" : @"Apple TV (3rd generation)",
        
        @"AppleTV5,3" : @"Apple TV (4th generation)",
        
        @"AppleTV6,2" : @"Apple TV 4K",
        @"AppleTV11,1" : @"Apple TV 4K (2nd generation)",
        @"AppleTV14,1" : @"Apple TV 4K (3rd generation)",
        
        
        // Simulator
        
        @"i386" : @"Simulator",
        @"x86_64" : @"Simulator",
    };
}
@end

