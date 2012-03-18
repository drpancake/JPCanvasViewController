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

// TODO: fix runtime error if this is set to a weak reference (ARC bug?)
@property (nonatomic, strong) id<JPCanvasViewControllerDelegate> delegate;

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

// TODO: this should be shared
//@property (nonatomic, weak) id<JPCanvasViewControllerDelegate> delegate;

- (NSString *)execute:(NSString *)js;
- (void)drawPoints:(NSArray *)points;

@end
