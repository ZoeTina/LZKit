//
//  NSString+Extension.h
//  LZExtension
//
//  Created by 寕小陌 on 2016/12/12.
//  Copyright © 2016年 寕小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  此分类增加了一些关于NSString的有用方法
 */
@interface NSString (Extension)

/** 手机号码验证 MODIFIED BY HELENSONG */
- (BOOL) lz_isValidateMobile;

/** 判断字符串是否为空 */
- (BOOL) isBlankString:(NSString *_Nonnull)string;
///**
// *身份证验证
// */
//- (BOOL)validateIdentityCard;
/** 判断字段是否包含空格 */
- (BOOL)lz_validateContainsSpace;

/** 根据生日返回年龄 */
- (NSString *_Nonnull)lz_ageFromBirthday;

/** 根据身份证返回岁数 */
- (NSString *_Nonnull)lz_ageFromIDCard;

/** 根据身份证返回生日 */
- (NSString *_Nonnull)lz_birthdayFromIDCard;

/** 根据身份证返回性别 */
- (NSString *_Nonnull)lz_sexFromIDCard;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)lz_sizeWithFont:(UIFont *_Nonnull)font maxSize:(CGSize)maxSize;

+ (NSString *_Nonnull)lz_stringWithMoneyAmount:(double)amount;

+ (NSString *_Nonnull)lz_stringIntervalFrom:(NSDate *_Nonnull)start to:(NSDate *_Nonnull)end;

//邮箱
+ (BOOL)lz_validateEmail:(NSString *_Nonnull)email;

- (BOOL)lz_isEmptyString;

/** 拼接了`文档目录`的全路径 */ 
@property (nullable, nonatomic, readonly) NSString *lz_documentDirectory;
/** 拼接了`缓存目录`的全路径 */
@property (nullable, nonatomic, readonly) NSString *lz_cacheDirecotry;
/** 拼接了临时目录的全路径 */
@property (nullable, nonatomic, readonly) NSString *lz_tmpDirectory;

/** BASE 64 编码的字符串内容 */
@property(nullable, nonatomic, readonly) NSString *lz_base64encode;
/** BASE 64 解码的字符串内容 */
@property(nullable, nonatomic, readonly) NSString *lz_base64decode;

#pragma mark - 散列函数 Hash

/**
 *  计算MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 -s "string"
 *  @endcode
 *
 *  <p>提示：随着 MD5 碰撞生成器的出现，MD5 算法不应被用于任何软件完整性检查或代码签名的用途。<p>
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *_Nullable)lz_md5String;

#pragma mark - TODO:
@end
