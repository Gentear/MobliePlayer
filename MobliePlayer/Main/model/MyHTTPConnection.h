//
//  MyHTTPConnection.h
//  Http
//
//  Created by and on 16/3/2.
//  Copyright © 2016年 and. All rights reserved.
//

#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {
    MultipartFormDataParser*        parser;
    NSFileHandle*					storeFile;
    
    NSMutableArray*					uploadedFiles;
}
@end
