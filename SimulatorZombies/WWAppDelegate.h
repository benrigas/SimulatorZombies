//
//  WWAppDelegate.h
//  SimulatorZombies
//
//  Created by Ben Rigas on 3/16/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WWAppDelegate : NSObject <NSApplicationDelegate, NSSharingServicePickerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSLevelIndicator *levelIndicator;

@property (weak) IBOutlet NSView *zombieCountBackgroundView;
@property (weak) IBOutlet NSTextField *zombieCountLabel;
@property (weak) IBOutlet NSTextField *totalProcessCountLabel;
@property (weak) IBOutlet NSTextField *maximumProcessUserSettingLabel;
@property (weak) IBOutlet NSButton *notifyCheckBox;
- (IBAction)notifyButtonValueChanged:(id)sender;
@property (weak) IBOutlet NSButton *shareButton;

- (IBAction)shareButtonClicked:(id)sender;

@end
