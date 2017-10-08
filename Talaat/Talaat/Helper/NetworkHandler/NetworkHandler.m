//
//  NetworkHandler.m
//  NetworkHandler
//
//  Created by Jay Krish on 3/9/15.
//  Copyright (c) 2015 Pumex. All rights reserved.
//

#import "AFNetworking.h"
#import "NetworkHandler.h"

#import "Reachability.h"
#import "RequestBodyGenerator.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const CLNetworkErrorMessage = @"No internet Access";
NSString * const kNetworkFailFailNotification = @"com.CL.NetworkHandler.fail";

@interface NetworkHandler()

@property (nonatomic, strong) NSURL * requestUrl;
@property (nonatomic, assign) MethodType methodType;
@property (nonatomic, assign) NSMutableDictionary * headerDictionary;
@property (nonatomic, strong) id bodyData;
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

@end

@implementation NetworkHandler

#pragma mark - init Service Handler

- (id)initWithRequestUrl:(NSURL *) requestUrl withBody:(id) data withMethodType:(MethodType) method withHeaderFeild:(NSMutableDictionary *)headerDictionary {
    self = [super init];
    if(self) {
        [self checkNetwrokAvailability];
        self.requestUrl = requestUrl;
        self.bodyData = data;
        self.methodType = method;
        self.headerDictionary =headerDictionary;
    }
    return self;
}

#pragma mark- Network Check

+ (BOOL)networkUnavalible {
    Reachability *connectionMonitor = [Reachability reachabilityForInternetConnection];
    BOOL  hasInet = YES ;//= [connectionMonitor currentReachabilityStatus] != NotReachable;
    
    if ((connectionMonitor.isConnectionRequired) || (NotReachable == connectionMonitor.currentReachabilityStatus)) {
        hasInet = NO;
        
    } else if((ReachableViaWiFi == connectionMonitor.currentReachabilityStatus) || (ReachableViaWWAN == connectionMonitor.currentReachabilityStatus)){
        hasInet = YES;
    }
    return hasInet;
}

#pragma mark -

- (void)checkNetwrokAvailability {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.requestUrl];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status){
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"SO REACHABLE");
                [operationQueue setSuspended:NO];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            default: {
                NSLog(@"SO UNREACHABLE");
                [operationQueue setSuspended:YES];
                break;
            }
        }
    }];
    [manager.reachabilityManager startMonitoring];
}

#pragma mark - Statr Api Call

- (void)startServieRequestWithSucessBlockSuccessBlock:(void (^)( id responseObject,int statusCode))success FailureBlock:(void (^)( NSError *error,int statusCode,id errorResponseObject))failure {
    if (![NetworkHandler networkUnavalible]) {
        NSError * customError = [NSError errorWithDomain:CLNetworkErrorMessage code:1024 userInfo:nil];
        failure(customError,1024,nil);
        return;
    }
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:self.requestUrl];
    if( self.headerDictionary.count!=0)
        urlRequest.allHTTPHeaderFields = self.headerDictionary;
    
    [urlRequest setHTTPMethod:[self httpMethodForRequest:self.methodType]];
    if( [self.bodyData isKindOfClass:[NSMutableDictionary class]] || [self.bodyData isKindOfClass:[NSMutableArray class]]) {
        NSMutableDictionary *tempBodyDictionary = self.bodyData;
        if(tempBodyDictionary.count !=0) {
            [urlRequest setHTTPBody:[[RequestBodyGenerator sharedBodyGenerator]requestBodyGeneratorWith:self.bodyData]];
        }
    }else if( [self.bodyData isKindOfClass:[NSString class]]){
        if(self.bodyData!=nil)
            [urlRequest setHTTPBody:[self.bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    }
    urlRequest.timeoutInterval = 40;
     [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil],(int)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id errorResponseObject;
        
        NSString* myString;
        myString = [[NSString alloc] initWithData:operation.responseObject encoding:NSASCIIStringEncoding];
        if(operation.responseObject != NULL) {
            errorResponseObject = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        } else {
            errorResponseObject = nil;
        }
        failure(error,(int)operation.response.statusCode,errorResponseObject);
    }];
    [self.requestOperation start];
}


- (void)startServieRequestWithMessageSucessBlockSuccessBlock:(void (^)( id responseObject,int statusCode))success FailureBlock:(void (^)( NSError *error,int statusCode,id errorResponseObject))failure {
    if (![NetworkHandler networkUnavalible]) {
        NSError * customError = [NSError errorWithDomain:CLNetworkErrorMessage code:1024 userInfo:nil];
        failure(customError,1024,nil);
        return;
    }
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:self.requestUrl];
    if( self.headerDictionary.count!=0)
        urlRequest.allHTTPHeaderFields = self.headerDictionary;
    
    [urlRequest setHTTPMethod:[self httpMethodForRequest:self.methodType]];
    if( [self.bodyData isKindOfClass:[NSMutableDictionary class]] || [self.bodyData isKindOfClass:[NSMutableArray class]]) {
        NSMutableDictionary *tempBodyDictionary = self.bodyData;
        if(tempBodyDictionary.count !=0) {
            [urlRequest setHTTPBody:[[RequestBodyGenerator sharedBodyGenerator]requestBodyGeneratorWith:self.bodyData]];
        }
    }else if( [self.bodyData isKindOfClass:[NSString class]]){
        if(self.bodyData!=nil)
            [urlRequest setHTTPBody:[self.bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    }
    urlRequest.timeoutInterval = 40;
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* myString;
        myString = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        success(myString,(int)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id errorResponseObject;
        if(operation.responseObject != NULL) {
            errorResponseObject = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        } else {
            errorResponseObject = nil;
        }
        failure(error,(int)operation.response.statusCode,errorResponseObject);
    }];
    [self.requestOperation start];
}
#pragma mark - Image Download

-(void)startDownloadRequestSuccessBlock:(void (^)( id responseObject))success FailureBlock:(void (^)( NSString *errorDescription))failure  ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress {
    if (![NetworkHandler networkUnavalible]) {
        failure(CLNetworkErrorMessage);
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl];
    if( self.headerDictionary.count!=0)
        request.allHTTPHeaderFields = self.headerDictionary;
    
    [request setHTTPMethod:[self httpMethodForRequest:self.methodType]];
    if( [self.bodyData isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *tempBodyDictionary = self.bodyData;
        if(tempBodyDictionary.count !=0) {
            [request setHTTPBody:[[RequestBodyGenerator sharedBodyGenerator]requestBodyGeneratorWith:self.bodyData]];
        }
    }else if( [self.bodyData isKindOfClass:[NSString class]]){
        if(self.bodyData!=nil)
            [request setHTTPBody:[self.bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    }
    self.requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    self.requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
    [self.requestOperation start];
}

#pragma mark - File Upload

-(void)startUploadRequest:(NSString *)filename withfileLocation:(NSString *)fileLocation
              withBaseUrl:(NSString *)baseUrl
              withUrlPart:(NSString *)urlPart
                 withData:(NSData *)Data
                 withType:(FileType)fileType
             SuccessBlock:(void (^)( id responseObject))success
            ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
             FailureBlock:(void (^)( NSString *errorDescription))failure {
    if (![NetworkHandler networkUnavalible]) {
        failure(CLNetworkErrorMessage);
        return;
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    if( self.headerDictionary.count!=0)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    AFHTTPRequestOperation *op = [manager POST:urlPart parameters:self.bodyData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:Data name:fileLocation fileName:filename mimeType:[self mimeTypeOfFile:fileType]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success: %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if([responseObject isKindOfClass:[NSData class]])
            success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
        else
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
    }];
    [self.requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [op start];
}

-(void)startUploadRequest:(NSString *)filename
                   withBaseUrl:(NSString *)baseUrl
                   withUrlPart:(NSString *)urlPart
                      withData:(NSData *)Data
                      withType:(FileType)fileType
                  SuccessBlock:(void (^)( id responseObject))success
                 ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                  FailureBlock:(void (^)( NSString *errorDescription))failure {
    if (![NetworkHandler networkUnavalible]) {
        failure(CLNetworkErrorMessage);
        return;
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    if( self.headerDictionary.count!=0) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        for(id key in self.headerDictionary) {
            [manager.requestSerializer setValue:[self.headerDictionary objectForKey:key] forHTTPHeaderField:key];
        }
    }
    AFHTTPRequestOperation *op = [manager POST:urlPart parameters:self.bodyData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(Data != nil)
        [formData appendPartWithFileData:Data name:@"file" fileName:filename mimeType:[self mimeTypeOfFile:fileType]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject );
        if([responseObject isKindOfClass:[NSData class]])
            success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
        else
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([error localizedDescription]);
        //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [self.requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [op start];
}

#pragma mark - Cancell All Operations

- (void)cancellAllOperations {
    [self.requestOperation cancel];
}

- (NSString *)httpMethodForRequest:(MethodType) method {
    NSString *type = nil;
    switch (method) {
        case HTTPMethodPOST:
            type = @"POST";
            break;
        case HTTPMethodGET:
            type = @"GET";
            break;
        case HTTPMethodPUT:
            type = @"DELETE";
            break;
        case HTTPMethodDELETE:
            type = @"DELETE";
            break;

        default:
            break;
    }
    return type;
}

-(NSString *)mimeTypeOfFile:(FileType)file{
    NSString *type = nil;
    switch (file) {
        case fileTypeJPGImage:
            type = @"image/jpeg";
            break;
        case fileTypePNGImage:
            type = @"image/png";
            break;
        case fileTypeDocument:
            type = @"application/msword";
            break;
        case fileTypePowerPoint:
            type = @"application/vnd.ms-powerpoint";
            break;
        case fileTypeHTML:
            type = @"text/html";
            break;
        case fileTypePDF:
            type = @"application/pdf";
            break;
        case fileTypeVideo:
            type = @"video/mp4";
            break;
        default:
            break;
    }
    return type;
}

-(NSString *)extensionOfFile:(FileType)file{
    NSString *extension = nil;
    switch (file) {
        case fileTypeJPGImage:
            extension = @".jpg";
            break;
        case fileTypePNGImage:
            extension = @".png";
            break;
        case fileTypeDocument:
            extension = @".doc";
            break;
        case fileTypeHTML:
            extension = @".html";
            break;
        case fileTypePDF:
            extension = @".pdf";
            break;
        case fileTypePowerPoint:
            extension = @".ppt";
            break;
        default:
            break;
    }
    return extension;
}

-(void)startMultipleFileUploadRequest:(NSString *)filename
                          withBaseUrl:(NSString *)baseUrl
                          withUrlPart:(NSString *)urlPart
                             withData:(NSArray *)dataArray
                             withType:(FileType)fileType
                         SuccessBlock:(void (^)( id responseObject,int statusCode))success
                        ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                         FailureBlock:(void (^)(NSError *error,int statusCode,id errorResponse))failure {
    if (![NetworkHandler networkUnavalible]) {
        NSError * customError = [NSError errorWithDomain:CLNetworkErrorMessage code:1024 userInfo:nil];
        failure(customError,1024,CLNetworkErrorMessage);
        return;
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    if( self.headerDictionary.count!=0) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        for(id key in self.headerDictionary) {
            [manager.requestSerializer setValue:[self.headerDictionary objectForKey:key] forHTTPHeaderField:key];
        }
    }
    id finalBodyData;
    if( [self.bodyData isKindOfClass:[NSString class]]){
        if(self.bodyData!=nil)
            finalBodyData = self.bodyData;
    }
    else
        finalBodyData = self.bodyData;
    AFHTTPRequestOperation *op = [manager POST:urlPart parameters:finalBodyData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<[dataArray count];i++) {
            if(i == 0)
                [formData appendPartWithFileData:[dataArray objectAtIndex:i] name:@"options" fileName:filename mimeType:[self mimeTypeOfFile:fileType]];
            else
                [formData appendPartWithFileData:[dataArray objectAtIndex:i] name:@"options" fileName:filename mimeType:[self mimeTypeOfFile:fileType]];
        }
        //        for (NSData *data in dataArray) {
        //            [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:[self mimeTypeOfFile:fileType]];
        //        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSData class]])
            success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil],(int)operation.response.statusCode);
        else
            success(responseObject,(int)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(operation.responseObject){
            failure(error ,(int)operation.response.statusCode,[NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil]);
        }
        else{
            failure(error,(int)operation.response.statusCode,nil);
        }
    }];
    [self.requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    
    [op start];
}

@end
