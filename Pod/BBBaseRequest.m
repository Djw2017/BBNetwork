//
//  BBBaseRequest.m
//  bbframework
//
//  Created by Dongjw on 2018/1/26.
//  Copyright © 2018年 Babybus. All rights reserved.
//

#import "BBBaseRequest.h"
#import "BBNetwork.h"

@interface BBBaseRequest ()

@property (nonatomic, strong) NSURLSessionDataTask * dataTask;

@property (nonatomic, weak) id<BBBaseRequestProtocol> childRequest;

@property (nonatomic, strong, readwrite, nullable) id responseObject;

@property (nonatomic, strong, readwrite, nullable) NSError *error;

@property (nonatomic, assign, readwrite) NSTimeInterval requestTimeoutInterval;

@property (nonatomic, assign, readwrite) BBNetResponseType responseType;

@property (nonatomic, strong, readwrite) NSURL *resumableDownloadPath;

@property (nonatomic, copy, readwrite) NSString *reuqestUrl;

@property (nonatomic, strong) BBBaseRequest *chainReuqest;

@end

@implementation BBBaseRequest

- (instancetype)init
{
    self = [super init];
    if ([self conformsToProtocol:@protocol(BBBaseRequestProtocol)]) {
        self.childRequest = (id<BBBaseRequestProtocol>)self;
    } else {
        NSAssert(NO, @"必须遵循BBBaseRequestProtocol协议");
    }
    return self;
}

/**
 开始请求
 */
- (void)start {
    
    // 是否允许请求
    if ([self.delegate respondsToSelector:@selector(requestAllow:)]) {
        if (![self.delegate requestAllow:self]) {
            return;
        }
    }
    // 请求前
    if ([self.childRequest respondsToSelector:@selector(requestBefore)]) {
        [self.childRequest requestBefore];
    }

    // 请求地址
    if ([self.childRequest respondsToSelector:@selector(requestUrl)]) {
        self.reuqestUrl = [self.childRequest requestUrl];
    } else {
        NSAssert(NO, @"BBBaseRequestProtocol协议中requestUrl方法未实现");
    }
    
    if ([self.childRequest resumableDownloadPath]) {
        
        [self download];
        
    } else {

        [self request];
    }
}

/**
 停止请求
 */
- (void)stop {
    [self.dataTask cancel];
}

/**
 添加请求
 */
- (BBBaseRequest *)addChainRequest:(BBBaseRequest *)chainRequest {
    if ([chainRequest isKindOfClass:[BBBaseRequest class]]) {
        self.chainReuqest = chainRequest;
    } else {
        NSAssert(NO, @"添加的请求必须继承BBBaseRequest");
    }
    return self.chainReuqest;
}

#pragma mark - Prvite
- (void)request {
    
    // 请求参数
    NSDictionary *parameters;
    if ([self.childRequest respondsToSelector:@selector(requestParameters)]) {
        parameters = [self.childRequest requestParameters];
    }
    
    // 超时时间
    NSNumber *requestTimeoutNumber = [NSNumber numberWithInteger:self.requestTimeoutInterval];
    
    // 返回类型
    NSNumber *responseTypeNumber = [NSNumber numberWithInteger:self.responseType];
    
    NSDictionary * optionsAttributes = @{BBNetworkTimeoutIntervalName:requestTimeoutNumber,
                                         BBNetworkResponseTypeName:responseTypeNumber};
    
    self.dataTask = [BBNetworkManager postURLString:self.reuqestUrl parameters:parameters optionsAttributes:optionsAttributes success:^(id  _Nonnull responseObject) {
        
        //
        if ([self.childRequest respondsToSelector:@selector(requestCompletePreprocessor)]) {
            [self.childRequest requestCompletePreprocessor];
        }
        
        // 检验返回数据格式
        if ([self.childRequest respondsToSelector:@selector(jsonValidator)]) {
            id validator = [self.childRequest jsonValidator];
            BOOL result = [[self class] validateJSON:responseObject withValidator:validator];
            if (result) {
                self.responseObject = responseObject;
                if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
                    if (self.chainReuqest) {
                        [self.chainReuqest start];
                    }
                    [self.delegate requestFinished:self];
                }
            } else {
                NSError *error = [NSError errorWithDomain:@"返回数据格式错误" code:-3 userInfo:nil];
                self.error = error;
                if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [self.delegate requestFailed:self];
                }
            }
        } else {
            // 不需要校验格式
            self.responseObject = responseObject;
            if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
                if (self.chainReuqest) {
                    [self.chainReuqest start];
                }
                [self.delegate requestFinished:self];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        // 请求前
        if ([self.childRequest respondsToSelector:@selector(requestFailedPreprocessor:)]) {
            [self.childRequest requestFailedPreprocessor:error.code];
        }
        self.error = error;
        if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
            [self.delegate requestFailed:self];
        }
    }];
}


- (void)download {
    self.resumableDownloadPath = [self.childRequest resumableDownloadPath];
    
    [BBNetworkManager downLoadWithURL:self.reuqestUrl progress:nil destination:^NSURL * _Nullable(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return self.resumableDownloadPath;
    } downLoadSuccess:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath) {
        
        if ([self.childRequest respondsToSelector:@selector(requestCompletePreprocessor)]) {
            [self.childRequest requestCompletePreprocessor];
        }
        if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
            [self.delegate requestFinished:self];
        }
        if (self.chainReuqest) {
            [self.chainReuqest start];
        }
    } downLoadfailure:^(NSError * _Nonnull error) {
        // 请求前
        if ([self.childRequest respondsToSelector:@selector(requestFailedPreprocessor:)]) {
            [self.childRequest requestFailedPreprocessor:error.code];
        }
        self.error = error;
        if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
            [self.delegate requestFailed:self];
        }
    }];
}

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator {
    if ([json isKindOfClass:[NSDictionary class]] &&
        [jsonValidator isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = json;
        NSDictionary * validator = jsonValidator;
        BOOL result = YES;
        NSEnumerator * enumerator = [validator keyEnumerator];
        NSString * key;
        while ((key = [enumerator nextObject]) != nil) {
            id value = dict[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSArray class]]) {
                result = [self validateJSON:value withValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if ([value isKindOfClass:format] == NO &&
                    [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([json isKindOfClass:[NSArray class]] &&
               [jsonValidator isKindOfClass:[NSArray class]]) {
        NSArray * validatorArray = (NSArray *)jsonValidator;
        if (validatorArray.count > 0) {
            NSArray * array = json;
            NSDictionary * validator = jsonValidator[0];
            for (id item in array) {
                BOOL result = [self validateJSON:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([json isKindOfClass:jsonValidator]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - get setter
- (NSTimeInterval)requestTimeoutInterval {
    
    // 默认10秒超时
    NSTimeInterval requestTimeoutInterval = 10;
    if ([self.childRequest respondsToSelector:@selector(requestTimeoutInterval)]) {
        requestTimeoutInterval = [self.childRequest requestTimeoutInterval];
    }
    return requestTimeoutInterval;
}

- (BBNetResponseType)responseType {
    
    // 默认返回字典类型
    BBNetResponseType responseType = BBNetResponseNSDictionary;
    if ([self.childRequest respondsToSelector:@selector(responseOCDataType)]) {
        if ([[[self.childRequest responseOCDataType] class] isEqual:[NSDictionary class]]) {
            
            responseType = BBNetResponseNSDictionary;
        } else if ([[[self.childRequest responseOCDataType] class] isEqual:[NSData class]]){
            
            responseType = BBNetResponseNSData;
        } else {
            responseType = BBNetResponseNSString;
        }
    }
    return responseType;
}

@end
