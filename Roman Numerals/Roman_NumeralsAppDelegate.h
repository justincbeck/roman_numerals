//
//  Roman_NumeralsAppDelegate.h
//  Roman Numerals
//
//  Created by Justin Beck on 9/23/11.
//  Copyright 2011 Intalgent. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Roman_NumeralsAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSTextField *result;
    
    const int *list;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *origin;
@property (assign) IBOutlet NSTextField *result;

- (IBAction)buttonPressed:(id)sender;
- (NSString *)convert:(NSString *)from;
- (NSString *)toRoman:(NSString *)candidate;
- (NSString *)toArabic:(NSString *)candidate;

- (NSString *)constructSegment:(char)segment: (NSString *[3])magnitude;

- (NSString *)reverseString:(NSString *)string;
- (NSString *)upCase:(NSString *)string;

@end
