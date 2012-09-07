/*
 *  NSColor-Additions.h
 *
 *  Requires Mac OS X 10.4 or higher
 *
 *	Provides a category for converting an NSColor into a CGColor.
 *
 *	-------------------------------------------------------------------
 *
 *
 */


#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface NSColor (PCAdditions)

- (NSColor*)pc_colorByAdjustingBrightness:(CGFloat)brightnessDelta;
- (NSColor*)pc_colorByAdjustingBrightness:(CGFloat)brightnessDelta minimum:(CGFloat)minimum;

- (NSColor*)pc_colorByAdjustingSaturation:(CGFloat)saturationDelta;
- (NSColor*)pc_colorByAdjustingSaturation:(CGFloat)saturationDelta minimum:(CGFloat)minimum;

- (NSColor*)pc_colorByAdjustingHue:(CGFloat)hueDelta;
- (NSColor*)pc_colorByAdjustingHue:(CGFloat)hueDelta minimum:(CGFloat)minimum;

- (CGColorRef)pc_CGColor;
- (NSColor*)pc_graphiteFromAqua;
+ (NSControlTint)pc_currentControlTint;
+ (NSColor*)pc_colorWithCGColor:(CGColorRef)colorRef;
+ (NSColor*)pc_colorWithThemeBrush:(ThemeBrush)themeBrush;
+ (NSColor*)pc_colorWithThemeTextColor:(ThemeTextColor)themeTextColor;
+ (NSColor*)pc_linenColor;
+ (NSColor*)pc_checkerboardColor;

- (NSColor*)pc_colorWithBrightness:(CGFloat)brightness;
- (BOOL)pc_isDarkColor;

@end
