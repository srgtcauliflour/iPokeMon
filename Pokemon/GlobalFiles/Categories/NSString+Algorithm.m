//
//  NSString+Algorithm.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "NSString+Algorithm.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Algorithm)

// Encrypt NSString with MD5
- (NSString *)encrypt {
  return [self toMD5];
}

// MD5
- (NSString *)toMD5 {
  // Create pointer to the string as UTF8
  const char * ptr = [self UTF8String];
  
  // Create byte array of unsigned chars
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
  
  // Create 16 byte MD5 hash value, store in buffer
  CC_MD5(ptr, strlen(ptr), md5Buffer);
  
  // Convert MD5 value in the buffer to NSString of hex values
  NSMutableString * output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) 
    [output appendFormat:@"%02x",md5Buffer[i]];
  return output;
}

// For Pokedex
//     HEX: @"AFF"
//     BIN: 1  0  1  0 1 1 1 1 1 1 1 1 : 1:Caught 0:Not
// PokeDEX: 12 11 10 9 8 7 6 5 4 3 2 1
- (BOOL)isBinary1AtIndex:(NSInteger)index {
  NSRange   scanRange = NSMakeRange([self length] - round(index / 4) - 1, 1);
  unsigned  result    = 0;
  NSScanner * scanner = [[NSScanner alloc] initWithString:[self substringWithRange:scanRange]];
  [scanner scanHexInt:&result];
  [scanner release];
  return (result & (1 << ((index - 1) % 4)));
}

// Generate a new Hex by modifying binary value at |index|
- (NSString *)generateHexBySettingBainaryTo1:(BOOL)settingBinaryTo1
                                     atIndex:(NSInteger)index {
  // Get the single Hex to be modified
  NSRange   scanRange = NSMakeRange([self length] - round(index / 4) - 1, 1);
  unsigned  result    = 0;
  NSScanner * scanner = [[NSScanner alloc] initWithString:[self substringWithRange:scanRange]];
  [scanner scanHexInt:&result];
  [scanner release];
  
  // New single Hex value by adding |mask|
  unsigned mask = 1 << ((index - 1) % 4);
  if (settingBinaryTo1) result = result |  mask;
  else                  result = result & ~mask;
  
  return [self stringByReplacingCharactersInRange:scanRange
                                       withString:[NSString stringWithFormat:@"%x", result]];
}

/*
// SHA1
- (NSString*) sha1:(NSString*)input {
  const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:input.length];
  
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return output;
}

// MD5
- (NSString *)md5:(NSString *)input {
  const char *cStr = [input UTF8String];
  unsigned char digest[16];
  CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
  
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return  output;
}*/

@end
