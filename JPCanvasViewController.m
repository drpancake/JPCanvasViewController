//
//  JPCanvasViewController.m
//  Created by James Potter on 05/03/2012.
//

#import "JPCanvasViewController.h"

/*
  Shared HTML for a canvas spanning its entire WebView/UIWebView
  with no margins
*/
NSString *const JPCANVAS_BASE_HTML = 
    @"<html><body style='margin: 0'>"
    "<canvas style='width: 100%; height=100%' id='canvas'></canvas>"
    "<script type='text/javascript'>"
    "window.canvas = document.getElementById('canvas');"
    "window.context = window.canvas.getContext('2d');"
    "</script>"
    "</body></html>";

@implementation JPCanvasViewController

@synthesize webView=_webView;

/*
  OS X specific methods for preparing a WebView
*/

#if (TARGET_OS_MAC && !TARGET_OS_IPHONE)

- (WebView *)webView
{
    if (_webView == nil) {
        // Dummy size for now (TODO: figure out how to inherit sizing)
        _webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    }
    return _webView;
}

- (void)loadView
{
    // Load nib
    [super loadView];
    
    [self.webView setFrameLoadDelegate:self];
    
    WebFrame *webFrame = [self.webView mainFrame];
    [webFrame loadHTMLString:JPCANVAS_BASE_HTML baseURL:[NSURL URLWithString:@""]];
    
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
        [_webView loadHTMLString:JPCANVAS_BASE_HTML baseURL:[NSURL URLWithString:@""]];
    }
    return _webView;
}

// UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSString *js = @"window.context.fillStyle='red'; window.context.fillRect(50, 50, 100, 100);";
    [self execute:js];
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
