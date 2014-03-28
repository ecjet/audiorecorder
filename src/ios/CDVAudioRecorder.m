//
//  AudioRecorderPlugin.m
//  AudioRecorder Plugin
//
//  Created by acr on 02/03/2014.
//  Copyright (c) 2014 University of Southampton. All rights reserved.
//

#import "AudioRecorder.h"
#import "CDVAudioRecorder.h"

@interface CDVAudioRecorder () {

    AudioRecorder *_audioRecorder;

    BOOL _started;

    NSString *_fileName;

}

- (NSString *)createFormattedDateString;

@end

@implementation CDVAudioRecorder

- (NSString *)createFormattedDateString {

    NSDateFormatter *formatter;
    NSString *dateString;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];

    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;

}

- (void)initialiseAudioRecorder:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        NSLog(@"Detector initialised.");

        /* Initialise the audio recorder */
        
        _audioRecorder = [AudioRecorder getInstance];

        BOOL success = [_audioRecorder initialiseAudioRecorder];

        CDVPluginResult *pluginResult = nil;

        if (success == YES ) {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)startAudioRecorder:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        BOOL success = NO;

        if (_audioRecorder) {

            if (_started) {

                success = YES;

            } else {

                NSLog(@"Detector started.");

                success = [_audioRecorder startAudioRecorder];

            }

        }

        CDVPluginResult *pluginResult = nil;

        if (success) {

            _started = YES;

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)stopAudioRecorder:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        BOOL success = NO;

        if (_started) {

            if (_audioRecorder) {

                NSLog(@"Detector stopped.");

                success = [_audioRecorder stopAudioRecorder];

            }

        } else {

            success = YES;

        }

        CDVPluginResult *pluginResult = nil;

        if (success) {

            _started = NO;

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)startWhiteNoise:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
            
        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            NSLog(@"White noise started");

            [_audioRecorder startWhiteNose];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];

}

- (void)stopWhiteNoise:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{

        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            NSLog(@"White noise stopped");

            [_audioRecorder stopWhiteNoise];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    }];

}

- (void)startHeterodyne:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            NSLog(@"Heterodyne started");

            [_audioRecorder startHeterodyne];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];

}

- (void)stopHeterodyne:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{

        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            NSLog(@"Heterodyne stopped");

            [_audioRecorder stopHeterodyne];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];

}

- (void)setHeterodyneFrequency:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *pluginResult = nil;

        int frequency = 15000;

        @try {

            frequency = [[command.arguments objectAtIndex:0] intValue];

        } @catch (NSException *e) {

            NSLog(@"Couldn't get frequency. Using default value of %d.", frequency);

        }

        if (_audioRecorder) {

            NSLog(@"Set heterodyne frequency to %d.", frequency);

            [_audioRecorder setHeterodyneFrequency:frequency];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];

}

- (void)getAmplitude:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
            
        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            NSNumber *amplitude = [_audioRecorder getAmplitude:AUDIORECORDER_RAW];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:[amplitude doubleValue]];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)getScaledAmplitude:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *pluginResult = nil;
    
        if (_audioRecorder) {
            
            NSNumber *amplitude = [_audioRecorder getAmplitude:AUDIORECORDER_SCALED];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:[amplitude doubleValue]];
            
        } else {
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    
}

- (void)getFrequencies:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            NSArray *array = [_audioRecorder getFrequencies:AUDIORECORDER_RAW];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];

}

- (void)getScaledFrequencies:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
            
        CDVPluginResult *pluginResult = nil;
    
        if (_audioRecorder) {
            
            NSArray *array = [_audioRecorder getFrequencies:AUDIORECORDER_SCALED];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
            
        } else {
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 
    }];
    
}

- (void)getFrequencyColours:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult *pluginResult = nil;
    
        if (_audioRecorder) {
            
            NSArray *array = [_audioRecorder getFrequencies:AUDIORECORDER_COLOURS];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
            
        } else {
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    
}

- (void)captureRecording:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        CDVPluginResult *pluginResult = nil;

        if (_audioRecorder) {

            [_audioRecorder captureRecording];

            _fileName = [self createFormattedDateString];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:_fileName];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)writeSonogram:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        int x = 320;

        @try {

            x = [[command.arguments objectAtIndex:0] intValue];

        } @catch (NSException *e) {

            NSLog(@"Couldn't get sonogram x dimensions. Using default value of %d.", x);

        }

        int y = 120;

        @try {

            y = [[command.arguments objectAtIndex:1] intValue];

        } @catch (NSException *e) {

            NSLog(@"Couldn't get sonogram y dimensions. Using default value of %d.", y);

        }

        int duration = 30;

        @try {

            duration = [[command.arguments objectAtIndex:2] intValue];

        } @catch (NSException *e) {

            NSLog(@"Couldn't get sonogram duration. Using default value of %d.", duration);

        }

        NSString *fileName = [_fileName stringByAppendingString:@".png"];

        NSLog(@"File : %@, Duration : %d", fileName, duration);

        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];

        NSURL *url = [NSURL fileURLWithPath:filePath];

        NSString *songramString = nil;

        if (_audioRecorder) {

            songramString = [_audioRecorder writeSonogramWithURL:url withX:x andY:y forDuration:duration];

        }

        CDVPluginResult *pluginResult = nil;

        if (songramString) {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:songramString];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)writeRecording:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        int duration = 30;

        @try {

            duration = [[command.arguments objectAtIndex:0] intValue];

        } @catch (NSException *e) {

            NSLog(@"Couldn't get recording duration. Using default value of %d.", duration);

        }

        NSString *fileName = [_fileName stringByAppendingString:@".wav"];

        NSLog(@"File : %@, Duration : %d", fileName, duration);

        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];

        NSURL *url = [NSURL fileURLWithPath:filePath];

        BOOL success = NO;

        if (_audioRecorder) {

            success = [_audioRecorder writeRecordingWithURL:url forDuration:duration];

        }

        CDVPluginResult *pluginResult = nil;

        if (success) {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        } else {

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

@end