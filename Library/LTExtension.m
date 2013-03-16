//
//  NSString+MVExtension.m
//  musavy-app2
//
//  Created by 伊藤 祐輔 on 11/12/07.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LTExtension.h"

@implementation NSString (LTExtension)

-(NSString *)lt_encodeURIComponent
{
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR (";,/?:@&=+$#"), kCFStringEncodingUTF8);
}


-(NSString *)lt_MD5HashString
{
         
        CC_MD5_CTX md5;
        CC_MD5_Init (&md5);
        CC_MD5_Update (&md5, [self UTF8String], [self length]);
        
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final (digest, &md5);
        NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                       digest[0],  digest[1], 
                       digest[2],  digest[3],
                       digest[4],  digest[5],
                       digest[6],  digest[7],
                       digest[8],  digest[9],
                       digest[10], digest[11],
                       digest[12], digest[13],
                       digest[14], digest[15]];
        
        return s;
   

}

@end
