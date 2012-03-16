//
//  JPCanvasViewController.m
//  Created by James Potter on 05/03/2012.
//

#import "JPCanvasViewController.h"

@implementation JPCanvasViewController

@synthesize webView=_webView;
@synthesize delegate;

/*
  OS X specific methods for preparing a WebView
*/

#if (TARGET_OS_MAC && !TARGET_OS_IPHONE)

- (WebView *)webView
{
    if (_webView == nil) {
        _webView = [[WebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}

- (void)loadView
{
    // Load nib
    [super loadView];
    
    [self.webView setFrameLoadDelegate:self];

    WebFrame *webFrame = [self.webView mainFrame];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"canvas" ofType:@"html"];
    [webFrame loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    [self setView:self.webView];
}

// WebFrameLoadDelegate
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    NSString *js = @"window.context.fillStyle='red'; window.context.fillRect(50, 50, 100, 100);";
    [self execute:js];
}

/*
  iOS-specific methods for preparing a UIWebView
*/

#elif TARGET_OS_IPHONE

- (UIWebView *)webView
{
    if (_webView == nil) {        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        
        //[_webView loadHTMLString:JPCANVAS_BASE_HTML baseURL:[NSURL URLWithString:@""]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"canvas" ofType:@"html"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        
        // Disable panning
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

// UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSString *js = @"window.context.fillStyle='red'; window.context.fillRect(50, 50, 100, 100);";
    [self execute:js];
}

- (BOOL)webView:(UIWebView *)theWebView
    shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
	NSString *requestString = [[request URL] absoluteString];
    
    if (_parser == nil)
        _parser = [[SBJsonParser alloc] init];
    
    if ([requestString hasPrefix:@"js-frame:"]) {
        NSLog(@"request : %@", requestString);
        
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        NSString *function = (NSString *)[components objectAtIndex:1];
        
        NSString *stringArgs = [(NSString *)[components objectAtIndex:3] 
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *args = (NSArray *)[_parser objectWithString:stringArgs];
        
        // TODO: handler method
        if ([function isEqualToString:@"didDrawPoints"]) {
            NSLog(@"JPCanvas got %i points", [args count]);
            [self.delegate canvas:self didDrawPoints:args];
        }
        
        return NO;
    }
    
    return YES;
}

- (UIView *)view
{
    return self.webView;
}

#endif

/*
  Past this point only stringByEvaluatingJavaScriptFromString: is needed, which is
  provided in both WebView and UIWebView, so we can just refer to self.webView
*/

- (NSString *)execute:(NSString *)js
{
    return [self.webView stringByEvaluatingJavaScriptFromString:js];
}

@end
