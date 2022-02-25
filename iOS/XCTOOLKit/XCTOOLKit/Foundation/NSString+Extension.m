//
//  NSString+Extension.m
//  GYFoundation
//
//  Created by MINI-02 on 2021/8/5.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)isBlankString:(NSString *)string {
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil){
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPureNumber:(NSString *)string withSpace:(BOOL)bSpace {
    NSString *str = string;
    if (bSpace) {
        str = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    }
    NSString *trimStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return (trimStr.length == 0);
//该方法： 字符串多位数据  可能会溢出
//    NSScanner *scan = [NSScanner scannerWithString:string];
//    int value;
//    return [scan scanInt:&value] && [scan isAtEnd];
}

#pragma mark - Account
+ (NSString *)setPhoneHideMiddleFour:(NSString *)phone {
    if ([phone length] < 7) {
        return phone;
    }
    NSString *strPhoneHide = [NSString stringWithFormat:@"%@****%@", [phone substringToIndex:3], [phone substringFromIndex:7]];
    return strPhoneHide;
}

+ (BOOL)checkChinaIDCode:(NSString *)chinaIDCode {
    //长度不为18的都排除掉
    if ( chinaIDCode.length != 18 ) {
        return false;
    }
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];

    BOOL flag = [identityCardPredicate evaluateWithObject:chinaIDCode];
    if (!flag) {//格式错误
        return false;
    } else {//格式正确
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;

        for (int i=0; i < 17; i++) {
            NSInteger subStrIndex = [[chinaIDCode substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum += subStrIndex * idCardWiIndex;
        }

        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        //得到最后一位身份证号码
        NSString * idCardLast = [chinaIDCode substringWithRange:NSMakeRange(17, 1)];
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if ( idCardMod == 2 ) {
            return ([[idCardLast uppercaseString] isEqualToString:@"X"]);
        } else {
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            return ([idCardLast isEqualToString:[idCardYArray objectAtIndex:idCardMod]]);
        }
    }
}

+ (BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isPureChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)includeChinese:(NSString *)string {
    BOOL includeChinese = false;
    for (int i = 0; i < string.length; i++) {
        int a = [string characterAtIndex:i];
        if ( a >0x4e00 && a < 0x9fff) {
            includeChinese = true;
            break;
        }
    }
    return includeChinese;
}

#pragma mark - PinYin
+ (NSString *)chineseToPinyin:(NSString *)hanString {
    if (!hanString || [hanString isEqualToString:@""]) {
        return @"";
    }
    //转成了可变字符串
    NSMutableString *pyStr = [NSMutableString stringWithString:hanString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)pyStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)pyStr,NULL, kCFStringTransformStripDiacritics,NO);
    return pyStr;
}

+ (NSString *)firstCharactor:(NSString *)pinyinString {
    NSString *pyStr = [self chineseToPinyin:pinyinString];
    //转化为大写拼音
    NSString *firstPinYin = [pyStr capitalizedString];
    //获取并返回首字母
    return [firstPinYin substringToIndex:1];
}

#pragma mark - 编码
/// 字符串转Unicode编码
/// @param string 字符串
+ (NSString *)utf8ToUnicode:(NSString *)string{
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [string characterAtIndex:i];
        // 判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else{
            // 中文和字符
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
        }
        [str appendFormat:@"%@", s];
    }
    return str;
}

+ (NSString *)gy_replaceStringWithEncoding:(NSString *)originString {
    NSString *resultStr = originString;
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    return resultStr;
}

+ (NSString *)gy_replaceStringWithSpecialString:(NSString *)originString {
    NSString *resultStr = originString;
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%25" withString:@"%"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
    return resultStr;
}

+ (NSString *)gy_URLEncodeString:(NSString *)urlString {
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)gy_URLDecodeString:(NSString *)urlString {
    return [urlString stringByRemovingPercentEncoding];
}

#pragma mark - JSON
+ (NSDictionary *)gy_dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString.length == 0) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return dic;
}

+ (NSArray *)gy_arrayWithJsonString:(NSString *)jsonString {
    if (jsonString.length == 0) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return array;
}

+ (NSString *)gy_jsonStringWithDictionary:(NSDictionary *)jsonDic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return @"";
    }
    return [self gy_stringWithData:jsonData];
}

+ (NSString *)gy_jsonStringWithArray:(NSArray *)jsonArr {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return @"";
    }
    return [self gy_stringWithData:jsonData];
}

+ (NSString *)gy_stringWithData:(NSData *)data {
    NSMutableString *string = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}

+ (NSData *)gy_dataWithString:(NSString *)string {
    if (string.length == 0) {
        return nil;
    }
    return [string dataUsingEncoding:NSUTF8StringEncoding];;
}

+ (NSDictionary *)gy_URLStringToDictionaryParam:(NSString *)urlString {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSRange params_range = [urlString rangeOfString:@"?"];
    if (params_range.location == NSNotFound) {
        return params;
    }
    NSArray * array = [[urlString substringFromIndex:params_range.location + params_range.length] componentsSeparatedByString:@"&"];
    for (NSString * param in array) {
        NSArray * maps = [param componentsSeparatedByString:@"="];
        if (maps.count == 2) {
            [params setValue:maps.lastObject forKey:maps.firstObject];
        } else {
            NSLog(@"url参数拼接异常%@", param);
        }
    }
    return params;
}

+ (NSString *)gy_getUrlWithString:(NSString *)urlString dictionaryParam:(NSDictionary *)dict {
    NSString *paramerStr = [NSString gy_stringConvertFromParameterDictionary:dict];
    if (paramerStr.length == 0) {
        return urlString;
    }
    NSMutableString *finalStr = [NSMutableString stringWithString:urlString?:@""];
    if ([urlString rangeOfString:@"?"].location == NSNotFound) {
        [finalStr appendString:[NSString stringWithFormat:@"?%@", [paramerStr substringFromIndex:1]]];
    } else {
        [finalStr appendString:[NSString stringWithFormat:@"%@", paramerStr]];
    }
    return finalStr;
}

+ (NSString *)gy_stringConvertFromParameterDictionary:(NSDictionary *)paramDict {
    NSMutableString *paramStr = [[NSMutableString alloc] initWithString:@""];
    if (paramDict.count > 0) {
        for (NSString * key in paramDict.allKeys) {
            NSString *value = paramDict[key];
            value = [NSString stringWithFormat:@"%@", value];
            [paramStr appendFormat:@"&%@=%@", key, value];
        }
    }
    return paramStr;
}

#pragma mark - Number
+ (NSString *)getUnitConversionNumber:(NSString *)originValue digit:(int)digit {
    NSString *result;
    NSString *formart = [NSString stringWithFormat:@"%%.%df%%@", digit];
    float floatValue = [originValue floatValue];
    if (floatValue > 100000000) {
        result = [NSString stringWithFormat:formart, (floatValue/100000000),@"亿"];
    } else if ([originValue floatValue] > 10000) {
        result = [NSString stringWithFormat:formart, (floatValue/10000), @"万"];
    } else {
        result = [NSString stringWithFormat:formart, floatValue, @""];
    }
    return result;
}

@end
