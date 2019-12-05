//
//  XKUserInfo.m
//  XKSquare
//
//  Created by hupan on 2018/7/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKUserInfo.h"
#import "YYModel.h"

static NSString *XKUserCacheKey = @"staticUserCacheKey";
static dispatch_queue_t _serialQueue;
static NSString *XKPlatformPhone = @"";
static XKUserInfo *_user;

@interface XKUserInfo ()<YYModel> {
    NSString *_platformPhone;
}

@end

@implementation XKUserInfo

+ (void)load {
    _serialQueue = dispatch_queue_create("user_save_queue", DISPATCH_QUEUE_SERIAL);
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId": @"id"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userId" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

+ (XKUserInfo *)currentUser {
    __block XKUserInfo *cUser;
    dispatch_sync(_serialQueue, ^{
        if (!_user) {
            XKUserInfo *user = [XKUserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:XKUserCacheKey]];
            if (user == nil) {
                user = [[XKUserInfo alloc] init];
            }
            _user = user;
        }
        cUser = _user;
    });
    
    return cUser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 清除用户
+ (void)cleanUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XKUserCacheKey];
    _user = nil;
}

#pragma mark - 同步当前用户至userDefault
+ (void)synchronizeUser {
    [self saveCurrentUser:_user];
}

#pragma mark - 保存用户至单例 并且存至userDefult
+ (void)saveCurrentUser:(XKUserInfo *)user {
    _user = user;
    dispatch_async(_serialQueue, ^{
        if (_user == nil) {
            [self cleanUser];
        } else {
            NSString *userStr = [_user yy_modelToJSONString];
            [[NSUserDefaults standardUserDefaults] setObject:userStr forKey:XKUserCacheKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
}

#pragma mark - 快捷方式 请不要继续添加 使用 [XKUserInfo currentUser].进行操作

- (NSString *)mrCode {
    return self.securityCode;
}

+ (NSString *)getCurrentUserId {
    return [XKUserInfo currentUser].userId;
}

+ (NSString *)getCurrentUserToken {
    return [XKUserInfo currentUser].token;
}

+ (NSString *)getCurrentUserName {
    return [XKUserInfo currentUser].nickname;
}

+ (NSString *)getCurrentUserPhoneNumber {
    return [XKUserInfo currentUser].phone;
}

+ (NSString *)getCurrentUserRealPhoneNumber {
    return [XKUserInfo currentUser].realPhone;
}

+ (NSString *)getCurrentUserAvatar {
    return [XKUserInfo currentUser].avatar;
}

+ (NSString *)getCurrentUserLoginType {
    return [XKUserInfo currentUser].loginType;
}

+ (NSNumber *)getCurrentTimeInterval {
    return [XKUserInfo currentUser].timeInterval;
}

+ (NSString *)getCurrentIMUserID{
    return [XKUserInfo currentUser].userImAccount.accid;
}

+ (NSString *)getCurrentMrCode {
    return [XKUserInfo currentUser].mrCode;
}
+ (NSString *)getCurrentIMUserToken{
    return [XKUserInfo currentUser].userImAccount.token;
}

+ (NSString *)getCurrentRecommendVideoRand {
    return [XKUserInfo currentUser].recommendVideoRand;
}

+ (NSString *)getCurrentAddress {
    return [XKUserInfo currentUser].address;
}

- (void)setPlatformPhone:(NSString *)platformPhone {
    _platformPhone = platformPhone;
    XKPlatformPhone = platformPhone;
}

- (NSString *)platformPhone {
    
    if (_platformPhone) {
        return _platformPhone;
    }
    return XKPlatformPhone;
}

// FIXME: sy 服务器没存 先自己设置  服务器返回声音配置后记得删除这个代码

- (void)setIsShake:(NSString *)isShake {
    [[NSUserDefaults standardUserDefaults] setObject:isShake forKey:[NSString stringWithFormat:@"%@isShake",[XKUserInfo getCurrentUserId]]];
}

- (NSString *)isShake {
    NSString *isShake = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@isShake",[XKUserInfo getCurrentUserId]]];
    if (isShake == nil) {
        return @"YES";
    }
    return isShake;
}

- (void)setIsVoice:(NSString *)isVoice {
    [[NSUserDefaults standardUserDefaults] setObject:isVoice forKey:[NSString stringWithFormat:@"%@isVoice",[XKUserInfo getCurrentUserId]]];
}

- (NSString *)isVoice {
    NSString *isVoice = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@isVoice",[XKUserInfo getCurrentUserId]]];
    if (isVoice == nil) {
        return @"YES";
    }
    return isVoice;
}

- (void)setIsReceiveMessage:(NSString *)isReceiveMessage {
    [[NSUserDefaults standardUserDefaults] setObject:isReceiveMessage forKey:[NSString stringWithFormat:@"%@isReceiveMessage",[XKUserInfo getCurrentUserId]]];
}

- (NSString *)isReceiveMessage {
    NSString *isReceiveMessage = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@isReceiveMessage",[XKUserInfo getCurrentUserId]]];
    if (isReceiveMessage == nil) {
        return @"YES";
    }
    return isReceiveMessage;
}

+ (NSString *)getCurrentUserAuthStatus {
    return [XKUserInfo currentUser].authStatus;
}


+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"isShake",@"isVoice",@"isReceiveMessage"];
}

@end


@implementation XKUserImAccount

@end
