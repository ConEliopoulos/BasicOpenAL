//
//  AudioSamplePlayer.m
//  BasicOpenAL
//
//  Created by Con Eliopoulos on 1/08/13.
//  Copyright (c) 2013 Con Eliopoulos. All rights reserved.
//

#import "AudioSamplePlayer.h"

@implementation AudioSamplePlayer

/* The device we are using */
static ALCdevice *openALDevice;

/* The context we are using */
static ALCcontext *openALContext;

- (id)init
{
    self = [super init];
    if (self)
    {
        /* The device is a physical thing, like a sound card.
         'NULL' indicates that we want the default device
         */
        openALDevice = alcOpenDevice(NULL);
        
        /* The context is used to track the state of OpenAL.
         We need to create a single context and associate
         it with the device.
         */
        openALContext = alcCreateContext(openALDevice, NULL);
        
        /* Set the context we just created to the current context. */
        alcMakeContextCurrent(openALContext);
    }
    return self;
}

- (void) playSound
{
    /* Create a single OpenAL source */
    NSUInteger sourceID;
    alGenSources(1, &sourceID);
    
    /* Get a reference to the audio file.
     Note: we are only dealing with .caf files.
     */
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"ting" ofType:@"caf"];
    NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
    
    /* Audio File Services uses an AudioFileID to reference the audio file.
     To get the AudioFileID, open the audio file and read in the data.
     
     CFURLRef inFileRef = the file URL <- Note: __bridge is used for ARC
     SInt8 inPermissions = the permissions used for opening the file
     AudioFileTypeID inFileTypeHing = a hint for the file type. Note: '0' indicates that we are not providing a hint
     AudioFileID *outAudioFile = reference to the audio file
     */
    AudioFileID afid;
    OSStatus openAudioFileResult = AudioFileOpenURL((__bridge CFURLRef)audioFileURL, kAudioFileReadPermission, 0, &afid);
    
    /* Check to make sure the file opened properly. */
    if (0 != openAudioFileResult)
    {
        NSLog(@"An error occurred when attempting to open the audio file %@: %ld", audioFilePath, openAudioFileResult);
        return;
    }
    
    /* With the audio file open, get the file size
     
     when getting properties, you provide a reference to a variable
     containing the size of the property value. this variable is then
     set to the actual size of the property value.
     */
    UInt64 audioDataByteCount = 0;
    UInt32 propertySize = sizeof(audioDataByteCount);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &audioDataByteCount);
    
    if (0 != getSizeResult)
    {
        NSLog(@"An error occurred when attempting to determine the size of audio file %@: %ld", audioFilePath, getSizeResult);
    }
    
    UInt32 bytesRead = (UInt32)audioDataByteCount;
    
    /* Read the audio data and place it into an output buffer. */
    void *audioData = malloc(bytesRead);
    
    /* false means we don't want the data cached.
     0 means read from the beginning.
     bytesRead will end up containing the actual number of bytes read.
     */
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    
    if (0 != readBytesResult)
    {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %ld", audioFilePath, readBytesResult);
    }
    
    /* We are done with the AudioFileID. Close it. */
    AudioFileClose(afid);
    
    /* Create a buffer to hold the audio data. */
    ALuint outputBuffer;
    alGenBuffers(1, &outputBuffer);
    
    /* Now, copy the audio data into the output buffer. */
    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 44100);
    
    /* Finally, do some clean up. */
    if (audioData)
    {
        free(audioData);
        audioData = NULL;
    }
    
    /* Set the source parameters */
    alSourcef(sourceID, AL_PITCH, 1.0f);
    alSourcef(sourceID, AL_GAIN, 1.0f);
    
    /* Attach the buffer to a source. */
    alSourcei(sourceID, AL_BUFFER, outputBuffer);
    
    /* Now play the audio sample. */
    alSourcePlay(sourceID);
}

@end
