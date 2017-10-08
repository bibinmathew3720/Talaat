//
//  NetworkHandler.h
//  NetworkHandler
//
//  Created by Jay Krish on 3/9/15.
//  Copyright (c) 2015 Pumex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodDELETE,
}MethodType;

typedef enum{
    fileTypeVideo,
    fileTypeJPGImage,
    fileTypePNGImage,
    fileTypeDocument,
    fileTypePowerPoint,
    fileTypeHTML,
    fileTypePDF
}FileType;

extern NSString * const kNetworkFailFailNotification;


@interface NetworkHandler : NSObject

+(BOOL)networkUnavalible;

- (void)cancellAllOperations ;
- (id)initWithRequestUrl:(NSURL *) requestUrl withBody:(id) data withMethodType:(MethodType) method withHeaderFeild:(NSMutableDictionary *)headerDictionary;
- (void)startServieRequestWithSucessBlockSuccessBlock:(void (^)( id responseObject,int statusCode))success FailureBlock:(void (^)( NSError *error,int statusCode,id errorResponseObject))failure;
-(void)startDownloadRequestSuccessBlock:(void (^)( id responseObject))success FailureBlock:(void (^)( NSString *errorDescription))failure  ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;

- (void)startServieRequestWithMessageSucessBlockSuccessBlock:(void (^)( id responseObject,int statusCode))success FailureBlock:(void (^)( NSError *error,int statusCode,id errorResponseObject))failure;
-(void)startUploadRequest:(NSString *)filename withfileLocation:(NSString *)fileLocation
              withBaseUrl:(NSString *)baseUrl
              withUrlPart:(NSString *)urlPart
                 withData:(NSData *)Data
                 withType:(FileType)fileType
             SuccessBlock:(void (^)( id responseObject))success
            ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
             FailureBlock:(void (^)( NSString *errorDescription))failure;
-(void)startUploadRequest:(NSString *)filename
                   withBaseUrl:(NSString *)baseUrl
                   withUrlPart:(NSString *)urlPart
                      withData:(NSData *)Data
                      withType:(FileType)fileType
                  SuccessBlock:(void (^)( id responseObject))success
                 ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                  FailureBlock:(void (^)( NSString *errorDescription))failure;
-(void)startMultipleFileUploadRequest:(NSString *)filename
                          withBaseUrl:(NSString *)baseUrl
                          withUrlPart:(NSString *)urlPart
                             withData:(NSArray *)dataArray
                             withType:(FileType)fileType
                         SuccessBlock:(void (^)( id responseObject,int statusCode))success
                        ProgressBlock:(void (^)( NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                         FailureBlock:(void (^)(NSError *error,int statusCode,id errorResponse))failure;
@end
