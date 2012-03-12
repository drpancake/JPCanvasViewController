//
//  JPCanvasViewController.h
//  Created by James Potter on 05/03/2012.
//

#import "SBJson.h"

/*
  OS X
*/

#if (TARGET_OS_MAC && !TARGET_OS_IPHONE)

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface JPCanvasViewController : NSViewController {
    @private
    WebView *_webView;
}

@property (nonatomic, strong, readonly) WebView *webView;

/*
  iOS
*/

#elif TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface JPCanvasViewController : UIViewController<UIWebViewDelegate> {
    @private
    UIWebView *_webView;
    SBJsonParser *_parser;
}

@property (nonatomic, strong, readonly) UIWebView *webView;

#endif

/*
  Shared methods
*/

- (NSString *)execute:(NSString *)js;

@end
