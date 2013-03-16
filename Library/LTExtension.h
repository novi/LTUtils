//
//  NSString+MVExtension.h
//  musavy-app2
//
//  Created by 伊藤 祐輔 on 11/12/07.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (LTExtension)


- (NSString*)lt_encodeURIComponent;
- (NSString*)lt_MD5HashString;

@end
