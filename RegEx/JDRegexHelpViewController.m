//
//  JDRegexHelpViewController.m
//  Regex
//
//  Created by Joe Dakroub on 8/29/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDRegexHelpViewController.h"

@interface JDRegexHelpViewController ()
{
    JDRegexHelpViewController *vc;
}

@property (unsafe_unretained) IBOutlet NSPopover *helpPopover;
@property (unsafe_unretained) IBOutlet WebView *webView;
@property (unsafe_unretained) IBOutlet NSWindow *detachedWindow;

@end

@implementation JDRegexHelpViewController

- (void)awakeFromNib
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"RegexReference" ofType:@"html"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [[[self webView] mainFrame] loadRequest:request];
}

#pragma -
#pragma Popover delegate

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
    if (vc == nil)
    {
        vc = [[JDRegexHelpViewController alloc] init];
        [vc loadView];
    }

    [[self detachedWindow] setContentView:[vc view]];

    return [self detachedWindow];
}

#pragma -
#pragma WebView delegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id )listener
{
    NSString *host = [[request URL] host];
    
    if (host)
    {
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    }
    else
    {
        [listener use];
    }
}

#pragma -
#pragma Actions

- (IBAction)showHelp:(id)sender
{
    [[self helpPopover] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

@end
