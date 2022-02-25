//
//  NSString+Extension.h
//  GYFoundation
//
//  Created by MINI-02 on 2021/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/// 字符串判空
/// @param string  待校验字符串
+ (BOOL)isBlankString:(NSString *)string;

/// 字符串是否是纯数字(int long longlong)
/// @param string 待验证字符串
/// @param bSpace 是否先去除空格和换行符
+ (BOOL)isPureNumber:(NSString *)string withSpace:(BOOL)bSpace;

#pragma mark - Account
/// 隐藏手机号中间位数
/// @param phone 手机号字符串
+ (NSString *)setPhoneHideMiddleFour:(NSString *)phone;

/// 是否是身份证号码
/// @param chinaIDCode 待校验字符串
+ (BOOL)checkChinaIDCode:(NSString *)chinaIDCode;

/// 是否是邮箱地址
/// @param email 待校验字符
+ (BOOL)isEmail:(NSString *)email;

#pragma mark - Chinese & PinYin
/// 是否是纯中文
+ (BOOL)isPureChinese:(NSString *)string;

/// 字符串是否包含中文
+ (BOOL)includeChinese:(NSString *)string;

/// 汉字转拼音
/// @param hanString 汉字
+ (NSString *)chineseToPinyin:(NSString *)hanString;

/// 获取字符串拼音首字母
/// @param pinyinString 字符串
+ (NSString *)firstCharactor:(NSString *)pinyinString;

#pragma mark - 编码
/// 字符串转Unicode编码
/// @param string 字符串
+ (NSString *)utf8ToUnicode:(NSString *)string;

/// 使用编码后的字符替换原来特殊字符
/// @param originString 原始字符串
+ (NSString *)gy_replaceStringWithEncoding:(NSString *)originString;

/// 使用特殊字符替换编码后的字符
/// @param originString 原始字符串
+ (NSString *)gy_replaceStringWithSpecialString:(NSString *)originString;


/// 字符串进行rul编码
/// @param urlString url字符串
+ (NSString *)gy_URLEncodeString:(NSString *)urlString;

/// 字符串进行url解码
/// @param urlString 待解码url字符串
+ (NSString *)gy_URLDecodeString:(NSString *)urlString;

/// url字符串去参数转字典
/// @param urlString  带参数的url
+ (NSDictionary *)gy_URLStringToDictionaryParam:(NSString *)urlString;

/// 将字典作为参数拼接到url
/// @param urlString url
/// @param dict 参数字典
+ (NSString *)gy_getUrlWithString:(nonnull NSString *)urlString dictionaryParam:(NSDictionary *)dict;

#pragma mark - JSON
/// JSON字符串转字典
/// @param jsonString JSON字符串
+ (NSDictionary *)gy_dictionaryWithJsonString:(NSString*)jsonString;

/// 字典JSON字符串
/// @param jsonDic  JSON字典
+ (NSString *)gy_jsonStringWithDictionary:(NSDictionary *)jsonDic;

/// JSON字符串转数组
/// @param jsonString JSON字符串
+ (NSArray *)gy_arrayWithJsonString:(NSString *)jsonString;

/// 数组转JSON字符串
/// @param jsonArr JSON数组
+ (NSString *)gy_jsonStringWithArray:(NSArray *)jsonArr;

/// NSData转字符串
/// @param data 待转Data
+ (NSString *)gy_stringWithData:(NSData *)data;

/// 字符串转NSData
/// @param string 待转String
+ (NSData *)gy_dataWithString:(NSString *)string;

#pragma mark - Number

/// 数字转为带单位的数字
/// @param originValue  数值字符串
/// @param digit 保留小数位数
+ (NSString *)getUnitConversionNumber:(NSString *)originValue digit:(int)digit;

@end

NS_ASSUME_NONNULL_END
