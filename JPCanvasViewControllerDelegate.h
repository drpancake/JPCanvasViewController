//
//  JPCanvasViewControllerDelegate.h
//  CubicusClient
//
//  Created by James Potter on 13/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPCanvasViewController;

@protocol JPCanvasViewControllerDelegate <NSObject>

- (void)canvas:(JPCanvasViewController *)canvas didDrawPoints:(NSArray *)points;

@end
