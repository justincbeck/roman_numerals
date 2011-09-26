//
//  Roman_NumeralsAppDelegate.m
//  Roman Numerals
//
//  Created by Justin Beck on 9/23/11.
//  Copyright 2011 Intalgent. All rights reserved.
//

#import "Roman_NumeralsAppDelegate.h"

@implementation Roman_NumeralsAppDelegate

@synthesize window;
@synthesize result;

const static NSString *ONE[3] = {@"I", @"V", @"X"};
const static NSString *TEN[3] = {@"X", @"L", @"C"};
const static NSString *HUNDRED[3] = {@"C", @"D", @"M"};
const static NSString *THOUSAND[3] = {@"M"};

const static NSDictionary *THE_MAP;

+ (void)initialize
{
    THE_MAP = [[NSDictionary alloc] initWithObjectsAndKeys:
                [NSNumber numberWithInt: 1], @"I",
                [NSNumber numberWithInt: 5], @"V",
                [NSNumber numberWithInt: 10], @"X",
                [NSNumber numberWithInt: 50], @"L",
                [NSNumber numberWithInt: 100], @"C",
                [NSNumber numberWithInt: 500], @"D",
                [NSNumber numberWithInt: 1000], @"M",
                NULL]; 
}

- (IBAction)buttonPressed:(id)sender
{
    NSString *arabic = [self convert:(NSString *) @"MCMLXXII"];
    NSLog(@"%ld", [arabic integerValue]);
    NSString *roman = [self convert:(NSString *) @"1972"];
    NSLog(@"%@", roman); // Should be MCMLXXII but is MMCXXLLII

    [result setStringValue:roman];
}

- (NSString *)convert:(NSString *)candidate
{
    NSRegularExpression *arabicRegex = [NSRegularExpression regularExpressionWithPattern:@"^\\d+$" options:0 error:NULL];
    NSUInteger numberOfArabicMatches = [arabicRegex numberOfMatchesInString:candidate options:0 range:NSMakeRange(0, [candidate length])];
    
    NSRegularExpression *romanRegex = [NSRegularExpression regularExpressionWithPattern:@"^\\w+$" options:0 error:NULL];
    NSUInteger numberOfRomanMatches = [romanRegex numberOfMatchesInString:candidate options:0 range:NSMakeRange(0, [candidate length])];
    
    
    if (numberOfArabicMatches == 1)
    {
        if ([candidate integerValue] > 3999)
        {
            NSLog(@"Arabic must be less than 4000!");
            return @"Arabic must be less than 4000!";
        }
        return [self toRoman:(NSString *) candidate];
    }
    else if (numberOfRomanMatches == 1)
    {
        return [self toArabic:(NSString *) candidate];
    }
    else
    {
        return @"Invalid Entry!";
    }
}

- (NSString *)toRoman:(NSString *)arabic
{
    NSString *candidate = [self reverseString:arabic];
    NSMutableString *roman = [[NSMutableString alloc] init];
    NSUInteger length = [candidate length];
    
    for (NSUInteger i = 0; i < length; i++)
    {
        unichar character = [candidate characterAtIndex:i];
        long sum = pow(10, (i + 1));
        
        switch(sum)
        {
            case 10:
                [roman appendString:[self constructSegment:character: ONE]];
                break;
            case 100:
                [roman appendString:[self constructSegment:character: TEN]];
                break;
            case 1000:
                [roman appendString:[self constructSegment:character: HUNDRED]];
                break;
            case 10000:
                [roman appendString:[self constructSegment:character: THOUSAND]];
                break;
        }
    }

    return [self reverseString:roman];
}

- (NSString *)toArabic:(NSString *)roman
{
    NSMutableArray *arabic = [[NSMutableArray alloc] init];
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    NSString *upperRoman = [self upCase: roman];
    NSInteger length = [upperRoman length];
    
    for (NSInteger i = 0; i < length; i++) {
        unichar character = [upperRoman characterAtIndex:i];
        NSMutableString *tempString = [[NSMutableString alloc] init];
        [tempString appendFormat:@"%c",character];
        NSString *num = [THE_MAP objectForKey:tempString];
        [segments addObject: num];
    }
    
    NSEnumerator *segEnum = [segments objectEnumerator];
    id segment;
    while (segment = [segEnum nextObject])
    {
        NSInteger value = [segment integerValue];
        if ([arabic count] > 0 && [[arabic lastObject] integerValue] < value)
        {
            NSInteger sum = value - [[arabic lastObject] integerValue];
            NSInteger index = [arabic indexOfObject:[arabic lastObject]];
            [arabic replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:sum]];
        }
        else
        {
            [arabic addObject: segment];
        }
        
        NSLog(@"%@", arabic);
    }
    
    NSInteger total = 0;
    NSEnumerator *arabEnum = [arabic objectEnumerator];
    id arab;
    while (arab = [arabEnum nextObject])
    {
        total += [arab integerValue];
    }
    
    return [NSString stringWithFormat:@"%d", total];
}

- (NSString *)constructSegment:(char)segment: (NSString *[3])magnitude
{
    NSMutableString *roman = [[NSMutableString alloc] init];
    
    if (segment == '9')
    {
        [roman appendString:magnitude[0]];
        [roman appendString:magnitude[2]];
    }
    else if (segment > '5')
    {
        [roman appendString:magnitude[1]];
        int seg = (int) segment - 48;
        for (NSUInteger i = 0; i < (seg - 5); i++)
        {
            [roman appendString:magnitude[0]];
        }
    }
    else if (segment == '5')
    {
        [roman appendString:magnitude[1]];
    }
    else if (segment == '4')
    {
        [roman appendString:magnitude[0]];
        [roman appendString:magnitude[1]];
    }
    else
    {
        int seg = (int) segment - 48;
        for (NSUInteger i = 0; i < seg; i++)
        {
            [roman appendString:magnitude[0]];
        }
    }

    return roman;
}

- (NSString *) reverseString: (NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *rtr=[NSMutableString stringWithCapacity:length];
    
    while (length > (NSUInteger)0) { 
        unichar uch = [string characterAtIndex:--length]; 
        [rtr appendString:[NSString stringWithCharacters:&uch length:1]];
    }
    return rtr;
}

- (NSString *) upCase: (NSString *)string
{
    // TODO: This needs to be written
    return string;
}
                                  
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@end
