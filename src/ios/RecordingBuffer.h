//
//  RecordingBuffer.h
//  AudioRecorder Plugin
//
//  Created by acr on 24/12/2012.
//  Copyright (c) 2012 University of Southampton. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "Settings.h"

#define RECORDING_BUFFER_LENGTH     1024 * CEILING(BUFFER_SECONDS * SAMPLES_PER_SECOND, 1024)

typedef struct {
    int index;
    AudioSampleType mainBuffer[RECORDING_BUFFER_LENGTH];
    AudioSampleType copyBuffer[RECORDING_BUFFER_LENGTH];
} RecordingBuffer;

void RecordingBuffer_initialise(RecordingBuffer *recordingBuffer);

void RecordingBuffer_update(AudioSampleType sample, RecordingBuffer *recordingBuffer);

void RecordingBuffer_copyBuffer(RecordingBuffer *recordingBuffer);

void RecordingBuffer_clearBuffer(RecordingBuffer *recordingBuffer);

bool RecordingBuffer_getSample(AudioSampleType *sample, RecordingBuffer *recordingBuffer, int index, int duration);

OSStatus RecordingBuffer_writeRecording(AudioFileID *audioFile, RecordingBuffer *recordingBuffer, int duration);

