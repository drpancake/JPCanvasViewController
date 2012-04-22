//
//  JPCanvasViewController.h
//  Created by James Potter on 05/03/2012.
//

#import "JPCanvasViewControllerDelegate.h"
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

- (void)didDrawPoints:(WebScriptObject *)scriptObject;

@property (nonatomic, strong, readonly) WebView *webView;

// Must be assign rather than weak (as NSViewController doesn't support it yet)
@property (nonatomic, assign) id<JPCanvasViewControllerDelegate> delegate;

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
@property (nonatomic, weak) id<JPCanvasViewControllerDelegate> delegate;

#endif

/*
  Shared
*/

// TODO: eventually this should be shared when NSViewController supports weak
//@property (nonatomic, weak) id<JPCanvasViewControllerDelegate> delegate;

- (NSString *)execute:(NSString *)js;

- (void)drawPoints:(NSArray *)points; // Does not notify delegate
- (void)drawPoints:(NSArray *)points notifyDelegate:(BOOL)notify;

// e.g. "rgba(255, 0, 0, 0.5)"
@property (nonatomic, strong, readwrite) NSString *strokeColor;

@end
