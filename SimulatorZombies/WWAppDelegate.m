//
//  WWAppDelegate.m
//  SimulatorZombies
//
//  Created by Ben Rigas on 3/16/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "WWAppDelegate.h"

#import <sys/proc_info.h>
#import <libproc.h>
#import <sys/param.h>


@implementation WWAppDelegate
{
    NSTimer* timer;
    NSInteger currentZombieCount;
    NSInteger currentAllProcessCount;
    NSInteger currentMaximumProcessSetting;
    BOOL notifyOnChange;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:5.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.shareButton.image = [NSImage imageNamed:NSImageNameShareTemplate];
    [self.shareButton sendActionOn:NSLeftMouseDownMask];
}

- (void) timerTick:(NSTimer*)timer {
    [self updateZombieCount];
}

- (void) updateLevelIndicator {
    self.levelIndicator.maxValue = currentMaximumProcessSetting;
    self.levelIndicator.minValue = 0;
    self.levelIndicator.warningValue = currentMaximumProcessSetting - 200;
    self.levelIndicator.criticalValue = currentMaximumProcessSetting - 50;
    
    [self.levelIndicator setIntegerValue:currentAllProcessCount];
    
    self.zombieCountLabel.stringValue = [NSString stringWithFormat:@"%ld", currentZombieCount];
    self.totalProcessCountLabel.stringValue = [NSString stringWithFormat:@"%ld", currentAllProcessCount];
    self.maximumProcessUserSettingLabel.stringValue = [NSString stringWithFormat:@"%ld", currentMaximumProcessSetting];
}

- (void) updateZombieCount {
    NSArray* allProcesses = [self allProcesses];

    NSInteger zombieCount = [self countZombies:allProcesses];
    NSInteger allProcessCount = [self countAllProcesses:allProcesses];
    NSInteger maximumUserProcessSetting = [self maximumUserProcessSetting];
    
    if (zombieCount > currentZombieCount) {
        currentZombieCount = zombieCount;
        
        if (notifyOnChange) {
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"More zombies!";
            notification.informativeText = [NSString stringWithFormat:@"Your zombie count increased to %ld", (long)currentZombieCount];
            notification.soundName = @"Zombie Moan-SoundBible.com-565291980.mp3";
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }
    }
    
    currentAllProcessCount = allProcessCount;
    currentMaximumProcessSetting = maximumUserProcessSetting;
    
    [self updateLevelIndicator];
}

- (NSArray*) allProcesses {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    NSMutableData *readData = [[NSMutableData alloc] init];
    NSData* data = nil;
    
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = @"/bin/ps";
    task.arguments = @[@"-el"];
    task.standardOutput = pipe;
    
    [task launch];
    
    while ((task != nil) && ([task isRunning]))	{
        data = [fileHandle availableData];
        [readData appendData:data];
    }
    
    NSString* output = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    NSArray* lines = [output componentsSeparatedByString:@"\n"];
    
    return lines;
}

- (NSInteger) countZombies:(NSArray*)lines {
    NSInteger zombieCount = 0;
    
    for (NSString* line in lines) {
        //    501   299   135     6000   0   0  0        0      0 -      Z                   0 ??         0:00.00 (Fireside)
        NSArray* parts = [line componentsSeparatedByString:@" "];
        for (NSString* part in parts) {
            if ([part isEqualToString:@"Z"]) {
                zombieCount++;
                break;
            }
        }
    }
    
    return zombieCount;
}

- (NSInteger) countAllProcesses:(NSArray*)lines {
    NSInteger allProcessCount = 0;
    
    allProcessCount = [lines count];
    
    return allProcessCount;
}

- (NSInteger) maximumUserProcessSetting {
    NSInteger maximumUserProcesses = 0;
    
    //ulimit -u
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    NSMutableData *readData = [[NSMutableData alloc] init];
    NSData* data = nil;
    
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/ulimit";
    task.arguments = @[@"-u"];
    task.standardOutput = pipe;
    
    [task launch];
    
    while ((task != nil) && ([task isRunning]))	{
        data = [fileHandle availableData];
        [readData appendData:data];
    }
    
    NSString* output = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    maximumUserProcesses = [output integerValue];
    
    return maximumUserProcesses;
}

- (IBAction)notifyButtonValueChanged:(id)sender {
    NSButton* button = (NSButton*)sender;
    
    notifyOnChange = button.intValue;
}

- (IBAction)shareButtonClicked:(id)sender {
    
    NSString* message = [NSString stringWithFormat:@"I've got %ld zombies, only %ld more before I get to reboot! #xcode #zombies https://github.com/benrigas/SimulatorZombies", currentZombieCount, currentMaximumProcessSetting - currentAllProcessCount];
    
    NSArray* items = @[message];
    NSSharingServicePicker *sharingServicePicker = [[NSSharingServicePicker alloc] initWithItems:items];
    sharingServicePicker.delegate = self;
    
    [sharingServicePicker showRelativeToRect:[sender bounds]
                                      ofView:sender
                               preferredEdge:NSMinYEdge];
    
}
@end
