//
//  MPCopyableLabel.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 2/6/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//
#import <UIKit/UIKit.h>
@class MPCopyableLabel;

@protocol MPCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(MPCopyableLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(MPCopyableLabel *)copyableLabel;

@end

@interface MPCopyableLabel : UILabel

@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) id<MPCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end
