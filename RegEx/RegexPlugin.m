//
//  RegexPlugin.m
//  RegEx
//
//  Created by Joe Dakroub on 9/6/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "RegexPlugin.h"
#import "CodaPlugInsController.h"
#import "JDTreeController.h"

NSString * const kMenuItemTitle = @"RegEx...";
NSString * const kPluginName = @"RegEx";

@interface RegexPlugin ()
{
    NSColorPanel *colorPanel;
    NSInteger colorSelectionTag;
    CodaPlugInsController *controller;    
    NSIndexPath *selectedPatternToEdit;
    NSDictionary *textEditorAttributes;
}

@property (unsafe_unretained) IBOutlet NSPopUpButton *actionButton;
@property (unsafe_unretained) IBOutlet NSPopUpButton *addButton;
@property (assign) BOOL allowDotall;
@property (assign) BOOL allowCaseless;
@property (assign) BOOL allowMultiline;
@property (assign) BOOL useSecondaryHighlightColor;
@property (copy) NSMutableArray *contents;
@property (copy) NSFont *editorFont;
@property (copy) NSColor *primaryHighlightColor;
@property (copy) NSColor *secondaryHighlightColor;
@property (assign) NSInteger matchCount;
@property (unsafe_unretained) IBOutlet NSTextField *matchLabel;
@property (unsafe_unretained) IBOutlet NSOutlineView *outlineView;
@property (unsafe_unretained) IBOutlet NSTextField *regexField;
@property (unsafe_unretained) IBOutlet NSTextField *regexPatternSaveField;
@property (unsafe_unretained) IBOutlet NSTextField *regexDescriptionSaveField;
@property (unsafe_unretained) IBOutlet NSWindow *regexSheet;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (unsafe_unretained) IBOutlet JDTreeController *treeController;
@property (unsafe_unretained) IBOutlet NSWindow *window;

- (id)initWithController:(CodaPlugInsController*)inController;

@end

@implementation RegexPlugin

CGFloat const kDataRowHeight = 65.0;
CGFloat const kHeaderRowHeight = 22.0;
CGFloat const kLeftViewMaxWidth = 350.0;
CGFloat const kLeftViewMinWidth = 225.0;
CGFloat const kDefaultFontSize = 12.0;

NSInteger const kPrimaryColorTag = 1000;

NSString * const kRegexLibraryKey = @"JDRegexPatternLibrary";
NSString * const kRegexAllowsCaseless = @"JDRegexAllowsCaseless";
NSString * const kRegexAllowsDotall = @"JDRegexAllowsDotall";
NSString * const kRegexAllowsMultiline = @"JDRegexAllowsMultiline";
NSString * const kRegexUseSecondaryHighlightColor = @"JDRegeUseSecondaryHighlightColor";
NSString * const kRegexEditorFont = @"JDRegexEditorFont";
NSString * const kRegexFieldPattern = @"JDRegexFieldPattern";
NSString * const kRegexEditorText = @"JDRegexEditorText";
NSString * const kRegexPrimaryHighlightColor = @"JDRegexPrimaryHighlightColor";
NSString * const kRegexSecondaryHighlightColor = @"JDRegexSecondaryHighlightColor";

NSString * const kDefaultFontName = @"Menlo";
NSString * const kDefaultFieldPattern = @"\\w";
NSString * const kDefaultEditorText = @"The quick brown fox jumps over the lazy dog";

//2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController *)aController bundle:(NSBundle *)aBundle
{
    return [self initWithController:aController];
}

//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController *)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
    return [self initWithController:aController];
}

- (id)initWithController:(CodaPlugInsController *)inController
{
	if ( ! (self = [super init]))
        return nil;
    
    controller = inController;
    [controller registerActionWithTitle:NSLocalizedString(kMenuItemTitle, @"")
                  underSubmenuWithTitle:nil
                                 target:self
                               selector:@selector(showRegexWindow:)
                      representedObject:self
                          keyEquivalent:@"^~@r"
                             pluginName:kPluginName];
    
	return self;
}

- (NSString *)name
{
	return kPluginName;
}

- (BOOL)validateMenuItem:(NSMenuItem *)aMenuItem
{
	return YES;
}

- (void)showRegexWindow:(id)sender
{
    if ([self window] == nil)
    {
        [NSBundle loadNibNamed:@"Window" owner:self];
    }
    
    [self restoreDefaults];
    [self addObservers];
    [self configureUI];
    
    [[self window] makeKeyAndOrderFront:self];
}

- (NSColor *)defaultPrimaryHighlightColor
{
    return [NSColor colorWithCalibratedRed:0.764 green:1.000 blue:0.329 alpha:1.000];
}

- (NSColor *)defaultSecondaryHighlightColor
{
    return [NSColor colorWithCalibratedRed:0.419 green:0.801 blue:0.994 alpha:1.000];
}

- (void)addObservers
{
    [[self treeController] addObserver:self forKeyPath:@"arrangedObjects" options:NSKeyValueObservingOptionNew context:nil];
    [[self regexField] addObserver:self forKeyPath:@"stringValue" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"allowCaseless" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"allowDotall" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"allowMultiline" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"useSecondaryHighlightColor" options:NSKeyValueObservingOptionNew context:nil];    
    [self addObserver:self forKeyPath:@"editorFont" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"primaryHighlightColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"secondaryHighlightColor" options:NSKeyValueObservingOptionNew context:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroupOrPattern:) name:@"JDTreeControllerAddedGroup" object:nil];
}

- (void)configureUI
{
    [[[self actionButton] cell] setBackgroundStyle:NSBackgroundStyleRaised];
    [[[self addButton] cell] setBackgroundStyle:NSBackgroundStyleRaised];
    [[[self matchLabel] cell] setBackgroundStyle:NSBackgroundStyleRaised];
    
    [[self outlineView] setDoubleAction:@selector(insertRegex:)];
    [[self outlineView] setTarget:self];
    
    [[self textView] setContinuousSpellCheckingEnabled:NO];
    
    [[self window] center];
    
    [self highlightMatchesWithRegex:[self constructRegularExpression]];
    
    [[self treeController] setUndoManager:[[self regexField] undoManager]];
}

- (NSMutableArray *)fetchData
{
    return [NSMutableArray arrayWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"Regular Expressions" ofType:@"plist"]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([keyPath isEqual:@"arrangedObjects"])
    {
        NSData *contentData = [NSKeyedArchiver archivedDataWithRootObject:[self contents]];
        [defaults setObject:contentData forKey:kRegexLibraryKey];
    }
    else
    {
        NSData *fontData = [NSKeyedArchiver archivedDataWithRootObject:[self editorFont]];
        NSData *primaryHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:[self primaryHighlightColor]];
        NSData *secondaryHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:[self secondaryHighlightColor]];
        
        [defaults setBool:[self allowCaseless] forKey:kRegexAllowsCaseless];
        [defaults setBool:[self allowDotall] forKey:kRegexAllowsDotall];
        [defaults setBool:[self allowMultiline] forKey:kRegexAllowsMultiline];
        [defaults setBool:[self useSecondaryHighlightColor] forKey:kRegexUseSecondaryHighlightColor];
        [defaults setObject:fontData forKey:kRegexEditorFont];
        [defaults setObject:primaryHighlightColorData forKey:kRegexPrimaryHighlightColor];
        [defaults setObject:secondaryHighlightColorData forKey:kRegexSecondaryHighlightColor];
        
        [self highlightMatchesWithRegex:[self constructRegularExpression]];
    }
    
    [defaults synchronize];
}

- (void)restoreDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([defaults objectForKey:kRegexLibraryKey] != nil)
    {
        if ([[defaults objectForKey:kRegexLibraryKey] isKindOfClass:[NSMutableArray class]])
        {
            [self setContents:[defaults objectForKey:kRegexLibraryKey]];
        }
        else
        {
            [self setContents:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kRegexLibraryKey]]];
        }
    }
    else
    {
        [self setContents:[self fetchData]];
    }

    [self setAllowCaseless:[defaults boolForKey:kRegexAllowsCaseless]];
    [self setAllowDotall:[defaults boolForKey:kRegexAllowsDotall]];
    [self setAllowMultiline:[defaults boolForKey:kRegexAllowsMultiline]];
    [self setUseSecondaryHighlightColor:[defaults boolForKey:kRegexUseSecondaryHighlightColor]];
    
    [self setPrimaryHighlightColor:[defaults objectForKey:kRegexPrimaryHighlightColor] != nil
     ? [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kRegexPrimaryHighlightColor]]
                           : [self defaultPrimaryHighlightColor]];
    [self setSecondaryHighlightColor:[defaults objectForKey:kRegexSecondaryHighlightColor] != nil
     ? [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kRegexSecondaryHighlightColor]]
                                  : [self defaultSecondaryHighlightColor]];
    [self setEditorFont:[defaults objectForKey:kRegexEditorFont] != nil
     ? [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kRegexEditorFont]]
                       : [NSFont fontWithName:kDefaultFontName size:kDefaultFontSize]];
    [[self regexField] setStringValue:[defaults stringForKey:kRegexFieldPattern] != nil
     ? [defaults stringForKey:kRegexFieldPattern]
                                     : kDefaultFieldPattern];
    [[self textView] setString:[defaults objectForKey:kRegexEditorText] != nil
     ? [defaults objectForKey:kRegexEditorText]
                              : kDefaultEditorText];
    
    [self setMatchCount:0];
}

#pragma -
#pragma OutlineView datasource/delegate

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    if ([[item representedObject] valueForKey:@"children"] != nil)
    {
        if ([[[self contents] lastObject] isEqualTo:[item representedObject]])
            return kHeaderRowHeight + 1.0;
        
        return kHeaderRowHeight;
    }
    
    return kDataRowHeight;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSInteger row = [outlineView rowForItem:item];
    
    if ([[item representedObject] valueForKey:@"children"] != nil)
    {
        JDOutlineHeaderCell *cell = [[JDOutlineHeaderCell alloc] init];
        
        if ([[[self contents] lastObject] isEqualTo:[item representedObject]])
            [cell setIsLastCellOfSection:YES];
        
        return cell;
    }
    
    JDOutlineDataCell *cell = [[JDOutlineDataCell alloc] init];
    [cell setRegexDescription:[[item representedObject] valueForKey:@"description"]];
    
    id object = [[outlineView itemAtRow:row - 1] representedObject];
    
    if ([object valueForKey:@"children"] != nil)
        [cell setIsFirstCellOfSection:YES];
    
    object = [[outlineView itemAtRow:row + 1] representedObject];
    
    if ([object valueForKey:@"children"] != nil)
        [cell setIsLastCellOfSection:YES];
    
    return cell;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSMutableDictionary *dict = [item representedObject];
    
    return [dict valueForKey:@"children"] != nil;
}

- (NSString *)outlineView:(NSOutlineView *)outlineView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)tc item:(id)item mouseLocation:(NSPoint)mouseLocation
{
    if ([cell isKindOfClass:[JDOutlineDataCell class]])
    {
        JDOutlineDataCell *dataCell = (JDOutlineDataCell *)cell;
        return [NSString stringWithFormat:@"%@ - %@", [dataCell title], [dataCell regexDescription]];
    }
    
    return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    [[self treeController] willChangeValueForKey:@"arrangedObjects"];
    
    [[item representedObject] setValue:object forKey:@"name"];
    
    [[self treeController] didChangeValueForKey:@"arrangedObjects"];
}

#pragma -
#pragma SplitView delegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex
{
    return dividerIndex == 0 ? kLeftViewMaxWidth : HUGE_VAL;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
{
    return dividerIndex == 0 ? kLeftViewMinWidth : HUGE_VAL;
}

- (void) splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    // http://www.wodeveloper.com/omniLists/macosx-dev/2003/May/msg00261.html
    
	// Grab the splitviews
    NSView *left = [[sender subviews] objectAtIndex:0];
    NSView *right = [[sender subviews] objectAtIndex:1];
	
    float dividerThickness = [sender dividerThickness];
	
	// Get the different frames
    NSRect newFrame = [sender frame];
    NSRect leftFrame = [left frame];
    NSRect rightFrame = [right frame];
	
	// Change in width for this redraw
	int	dWidth  = newFrame.size.width - oldSize.width;
	
	// Ratio of the left frame width to the right used for resize speed when both panes are being resized
	float rLeftRight = (leftFrame.size.width - kLeftViewMinWidth) / rightFrame.size.width;
    
	// Resize the height of the left
    leftFrame.size.height = newFrame.size.height;
    leftFrame.origin = NSMakePoint(0,0);
	
	// Resize the left & right pane equally if we are shrinking the frame
	// Resize the right pane only if we are increasing the frame
	// when resizing lock at minimum width for the left panel
	if (leftFrame.size.width <= kLeftViewMinWidth && dWidth < 0)
    {
		rightFrame.size.width += dWidth;
	}
    else if (dWidth > 0)
    {
		rightFrame.size.width += dWidth;
	}
    else
    {
		leftFrame.size.width += dWidth * rLeftRight;
		rightFrame.size.width += dWidth * (1 - rLeftRight);
	}
    
    rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
    rightFrame.size.height = newFrame.size.height;
    rightFrame.origin.x = leftFrame.size.width + dividerThickness;
    
    [left setFrame:leftFrame];
    [right setFrame:rightFrame];
}

#pragma -
#pragma TextField/TextView delegate

- (void)textDidChange:(NSNotification *)notification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[self textView] string] forKey:kRegexEditorText];
    [defaults synchronize];
    
    [self highlightMatchesWithRegex:[self constructRegularExpression]];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    id field = [notification object];
    
    if ([field isEqualTo:[self regexPatternSaveField]])
    {
        if ([[field stringValue] isEqualTo:@""])
            [field setStringValue:[[field cell] placeholderString]];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[self regexField] stringValue] forKey:kRegexFieldPattern];
        [defaults synchronize];
        
        [self highlightMatchesWithRegex:[self constructRegularExpression]];
    }
}

#pragma -
#pragma Actions

- (IBAction)addRegex:(id)sender
{
    [[self regexPatternSaveField] setStringValue:[[[self regexField] stringValue] isEqualTo:@""]
     ? [[[self regexPatternSaveField] cell] placeholderString]
                                                : [[self regexField] stringValue]];
    
    [self displayRegexSheet];
}

/* Intentionally left empty as we do not want to support other font attributes like strikethrough, color, etc. */
- (void)changeAttributes:(id)sender {}

- (void)changeFont:(id)sender
{
    [self setEditorFont:[[NSFontManager sharedFontManager] convertFont:[sender selectedFont]]];
}

- (IBAction)closeRegexSheet:(id)sender
{
    [[self regexPatternSaveField] setStringValue:@""];
    [[self regexDescriptionSaveField] setStringValue:@""];
    
    [NSApp endSheet:[self regexSheet]];
}

- (NSString *)constructRegularExpression
{
    NSString *regex = [[self regexField] stringValue];
    NSString *regexPrefix = [NSString string];
    
    // Options
    if ([self allowCaseless] || [self allowDotall] || [self allowMultiline])
    {
        regexPrefix = [regexPrefix stringByAppendingString:@"(?"];
        
        if ([self allowCaseless])
            regexPrefix = [regexPrefix stringByAppendingString:@"i"];
        
        if ([self allowDotall])
            regexPrefix = [regexPrefix stringByAppendingString:@"s"];
        
        if ([self allowMultiline])
            regexPrefix = [regexPrefix stringByAppendingString:@"m"];
        
        regexPrefix = [regexPrefix stringByAppendingString:@")"];
    }
    
    return [regexPrefix stringByAppendingString:regex];
}

- (void)colorPanelColorDidChange:(NSNotification *)note
{
    if (colorSelectionTag == kPrimaryColorTag)
    {
        [self setPrimaryHighlightColor:[colorPanel color]];
    }
    else
    {
        [self setSecondaryHighlightColor:[colorPanel color]];
    }
}

- (void)colorPanelDidClose:(NSNotification *)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSColorPanelColorDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:nil];
}

- (IBAction)displayColorPanel:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPanelColorDidChange:) name:NSColorPanelColorDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorPanelDidClose:) name:NSWindowWillCloseNotification object:nil];
    
    colorSelectionTag = [sender tag];
    
    colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel setColor:colorSelectionTag == kPrimaryColorTag ? [self primaryHighlightColor] : [self secondaryHighlightColor]];
    [colorPanel setContinuous:YES];
    [colorPanel setMode:NSCrayonModeColorPanel];
    [colorPanel setShowsAlpha:NO];
    
    [colorPanel makeKeyAndOrderFront:self];
}

- (IBAction)displayFontPanel:(id)sender
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setDelegate:self];
    [fontManager setSelectedFont:[self editorFont] isMultiple:NO];
    [fontManager setTarget:self];
    
    [fontManager orderFrontFontPanel:nil];
}

- (void)displayRegexSheet
{
    [NSApp beginSheet:[self regexSheet]
       modalForWindow:[self window]
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (IBAction)editGroupOrPattern:(id)sender
{
    NSMutableDictionary *object = [[[self treeController] selectedObjects] lastObject];
    
    if ([object valueForKey:@"children"] != nil)
    {
        [[self outlineView] editColumn:0 row:[[self outlineView] selectedRow] withEvent:nil select:YES];
    }
    else
    {
        selectedPatternToEdit = [[self treeController] selectionIndexPath];
        
        [[self regexPatternSaveField] setStringValue:[object valueForKey:@"name"]];
        [[self regexDescriptionSaveField] setStringValue:[object valueForKey:@"description"]];
        
        [self displayRegexSheet];
    }
}

- (void)highlightMatchesWithRegex:(NSString *)regex
{
    [self setMatchCount:0];
    
    __block NSInteger i = 0;                                                      
    NSMutableString *mutableString = [NSMutableString stringWithString:[[self textView] string]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[[self textView] string]];
    
    [mutableString enumerateStringsMatchedByRegex:regex usingBlock:^(NSInteger captureCount,
                                                                     NSString *const __unsafe_unretained *capturedStrings,
                                                                     const NSRange *capturedRanges,
                                                                     volatile BOOL *const stop)
     {
         NSColor *highlightColor = [self primaryHighlightColor];
         
         if ([self useSecondaryHighlightColor])
             highlightColor = i % 2 == 0 ? [self primaryHighlightColor] : [self secondaryHighlightColor];
         
         textEditorAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 highlightColor, NSBackgroundColorAttributeName,
                                 ([highlightColor pc_isDarkColor] ? [NSColor whiteColor] : [NSColor blackColor]), NSForegroundColorAttributeName,
                                 nil];
        
         [attrString setAttributes:textEditorAttributes range:capturedRanges[0]];
         
         if (capturedRanges[0].length >= 1)
             [self setMatchCount:[self matchCount] + 1];
         
         i++;
    }];
    
    NSRange currentRange = [[self textView] selectedRange];
    
    [[[self textView] textStorage] setAttributedString:attrString];
    
    if ([self editorFont] != nil)
        [[[self textView] textStorage] setFont:[self editorFont]];
    
    [[self textView] setSelectedRange:currentRange];    
}

- (void)insertRegex:(id)sender
{
    if ([[[self treeController] selection] valueForKey:@"children"] == nil)
    {
        [[self regexField] setStringValue:[NSString stringWithFormat:@"%@%@", [[self regexField] stringValue], [[[self treeController] selection] valueForKey:@"name"]]];
        [self highlightMatchesWithRegex:[self constructRegularExpression]];
    }
}

- (IBAction)saveRegexPattern:(id)sender
{
    NSMutableDictionary *newPattern = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [[self regexPatternSaveField] stringValue], @"name",
                                       [[self regexDescriptionSaveField] stringValue], @"description", nil];
    
    if (selectedPatternToEdit != nil)
    {
        [[self treeController] removeObjectAtArrangedObjectIndexPath:selectedPatternToEdit];
        [[self treeController] insertObject:newPattern atArrangedObjectIndexPath:selectedPatternToEdit];
        
        selectedPatternToEdit = nil;
    }
    else
    {
        [[self treeController] addChild:newPattern];
    }
    
    [self closeRegexSheet:self];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
    [[self window] makeKeyWindow];
}

@end
