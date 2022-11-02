//
//  JKOCUtility.h
//  JKOCLibrary
//
//  Created by albert on 10/25/22.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const JKOCLibraryPodName;

typedef UIImage * (^JKOCImageFailedBlock)(NSString *imageName);


#define JKDevelopmentTeamId [JKOCUtility developmentTeamId]

#define JKScreenBounds [UIScreen mainScreen].bounds
#define JKScreenScale [UIScreen mainScreen].bounds.scale
#define JKScreenWidth [UIScreen mainScreen].bounds.size.width
#define JKScreenHeight [UIScreen mainScreen].bounds.size.height

#define JKisLandscape [JKOCUtility isLandscape]

#define JKisDeviceiPhone [JKOCUtility isDeviceiPhone]
#define JKisDeviceiPad [JKOCUtility isDeviceiPad]

#define JKisDeviceX [JKOCUtility isDeviceX]

#define JKKeyWindow [JKOCUtility keyWindow]
#define JKSafeAreaInsets [JKOCUtility safeAreaInset]

#define JKStatusBarHeight [JKOCUtility statusBarHeight]
#define JKNavigationBarHeight [JKOCUtility navigationBarHeight]

#define JKBottomSafeAreaInset [JKOCUtility bottomSafeAreaInset]
#define JKTabBarHeight [JKOCUtility tabBarHeight]

#define JKLineThickness [JKOCUtility lineThickness]
#define JKLineLightColor [JKOCUtility lineLightColor]
#define JKLineDarkColor [JKOCUtility lineDarkColor]
#define JKSystemRedColor [JKOCUtility systemRedColor]
#define JKSystemBlueColor [JKOCUtility systemBlueColor]

#define JKVibrateDevice [JKOCUtility vibrateDevice]
#define JKPlayNotificationVibrate [JKOCUtility playNotificationVibrate]
#define JKPlayNotificationSound [JKOCUtility playNotificationSound]

#define JKFitZoomScale [JKOCUtility zoomLargeScale]//[JKOCUtility zoomScale]
//#define JKFitZoomLargeScale [JKOCUtility zoomLargeScale]

#define JKFitFloat(value) ((value) * SWFitZoomScale)
#define JKFitFontNormal(value) [UIFont systemFontOfSize:((value) * SWFitZoomScale)]
#define JKFitFontMedium(value) [UIFont systemFontOfSize:((value) * SWFitZoomScale) weight:UIFontWeightMedium]
#define JKFitFontBold(value) [UIFont boldSystemFontOfSize:((value) * SWFitZoomScale)]

//#define JKFitFloatZoomLarge(value) ((value) * SWFitZoomLargeScale)
//#define JKFitFontNormalZoomLarge(value) [UIFont systemFontOfSize:((value) * SWFitZoomLargeScale)]
//#define JKFitFontMediumZoomLarge(value) [UIFont systemFontOfSize:((value) * SWFitZoomLargeScale) weight:UIFontWeightMedium]
//#define JKFitFontBoldZoomLarge(value) [UIFont boldSystemFontOfSize:((value) * SWFitZoomLargeScale)]

#define JKRGBColor(r,g,b) [JKOCUtility colorWithRed:(r) green:(g) blue:(b) alpha:1.0]
#define JKRGBColorAlpha(r,g,b,a) [JKOCUtility colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

#define JKSameRGBColor(rgb) [JKOCUtility sameRGBColor:(rgb) alpha:1.0]
#define JKSameRGBColorAlpha(rgb,a) [JKOCUtility sameRGBColor:(rgb) alpha:(a)]

#define JKRandomColor [JKOCUtility randomColor]
#define JKRandomColorAlpha(value) [JKOCUtility randomColorWithAlpha:(value)]



@interface JKOCUtility : NSObject

/// 当前签名的开发者ID
@property (class, nonatomic, readonly) NSString *developmentTeamId;

/// 当前是否横屏
@property (class, nonatomic, readonly) BOOL isLandscape;

/// 是否iPhone
@property (class, nonatomic, readonly) BOOL isDeviceiPhone;

/// 是否iPad
@property (class, nonatomic, readonly) BOOL isDeviceiPad;

/// 是否iPhone X设备
@property (class, nonatomic, readonly) BOOL isDeviceX;

/// keyWindow
@property (class, nonatomic, readonly) UIWindow *keyWindow;

/// 安全区域 insets
@property (class, nonatomic, readonly) UIEdgeInsets safeAreaInset;

/// 状态栏高度
@property (class, nonatomic, readonly) CGFloat statusBarHeight;

/// 导航条高度
@property (class, nonatomic, readonly) CGFloat navigationBarHeight;

/// 底部安全区域高度
@property (class, nonatomic, readonly) CGFloat bottomSafeAreaInset;

/// tabBar高度
@property (class, nonatomic, readonly) CGFloat tabBarHeight;

/// 分隔线粗细
@property (class, nonatomic, readonly) CGFloat lineThickness;

/// 分隔线颜色 浅色模式
@property (class, nonatomic, readonly) UIColor *lineLightColor;

/// 分隔线颜色 深色模式
@property (class, nonatomic, readonly) UIColor *lineDarkColor;

/// 系统红色
@property (class, nonatomic, readonly) UIColor *systemRedColor;

/// 系统蓝色
@property (class, nonatomic, readonly) UIColor *systemBlueColor;

/// 目前iPhone屏幕最大宽度
@property (class, nonatomic, readonly) CGFloat iPhoneMaxScreenWidth;

/// 屏幕适配放大比例 仅小屏幕缩放，大屏幕 不放大
@property (class, nonatomic, readonly) CGFloat zoomScale;

/// 屏幕适配放大比例 小屏幕缩放，大屏幕 放大
@property (class, nonatomic, readonly) CGFloat zoomLargeScale;

/// 让手机振动一下
+ (void)vibrateDevice;

/// 播放收到推送通知的那种振动，受系统控制
+ (void)playNotificationVibrate;

/// 播放通知声音，受系统控制
+ (void)playNotificationSound;

/// rgb Color alpha默认1
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/// rgba color
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/// rgb相同color alpha默认1
+ (UIColor *)sameRGBColor:(CGFloat)rgb;

/// rgb相同color alpha
+ (UIColor *)sameRGBColor:(CGFloat)rgb alpha:(CGFloat)alpha;

/// 随机颜色
+ (UIColor *)randomColor;

/// 随机颜色 alpha
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

/// 根据颜色创建图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size opaque:(BOOL)opaque;

/// 读取资源图片失败的回调
+ (void)makeResourceImageFailedHandler:(JKOCImageFailedBlock)handler;

/**
 * 读取资源中的图片
 * name: 无须添加@2x.png/@3x.png，类似UIImage(named: name)即可
 * 读取失败使用 +makeResourceImageFailedHandler处理
 */
+ (UIImage *)resourceImageNamed:(NSString *)name;

/**
 * 读取资源中的图片
 * name: 无须添加@2x.png/@3x.png，类似UIImage(named: name)即可
 * pathExtension: 传nil则默认 "png"，如其它格式则传对应格式后缀名，不包括小数点
 * 读取失败使用 +makeResourceImageFailedHandler处理
 */
+ (UIImage *)resourceImageNamed:(NSString *)name pathExtension:(NSString *)pathExtension;



#pragma mark
#pragma mark - 日期格式化

/// "yyyy-MM-dd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
+ (NSString *)stringFromDate_yyyyMMdd_horizontal_line:(NSDate *)date;

/// "yyyyMMdd" date无需增加时区偏移 date/format为空时或出错时返回空字符串
+ (NSString *)stringFromDate_yyyyMMdd:(NSDate *)date;

/// "yyyyMMdd HH:mm:ss" date无需增加时区偏移 date/format为空时或出错时返回空字符串
+ (NSString *)stringFromDateNormal:(NSDate *)date;

/**
 * format格式: "%Y-%m-%d %H:%M:%S"
 * date无需增加时区偏移
 * date/format为空或出错时返回空字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

#pragma mark
#pragma mark - 设备信息

/// 设备型号名称 e.g. @"iPhone 12", @"iPhone 12 Pro Max"
+ (NSString *)deviceModelName;

/// 设备硬件标识 e.g. @"iPhone13,2", @"iPhone13,3"
+ (NSString *)deviceIdentifier;

/// [设备硬件标识 : 型号名称] 对应字典
+ (NSDictionary *)deviceIdentifierDictionary;
@end

