#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/FrameProcessorPluginRegistry.h>
#import <VisionCamera/Frame.h>
#import <MLKit.h>

@interface PoseDetectorPlugin : FrameProcessorPlugin

+ (MLKPoseDetector*) detector;

@end

@implementation PoseDetectorPlugin

- (instancetype) initWithOptions:(NSDictionary*)options; {
  self = [super init];
  return self;
}

+ (MLKPoseDetector*) detector {
  static MLKPoseDetector* detector = nil;
  if (detector == nil) {
    MLKAccuratePoseDetectorOptions* options = [[MLKAccuratePoseDetectorOptions alloc] init];
    options.detectorMode = MLKPoseDetectorModeStream;
    detector = [MLKPoseDetector poseDetectorWithOptions:options];
  }
  return detector;
}

+ (NSDictionary *)getLandmarkPosition:(MLKPoseLandmark *)landmark {
  MLKVision3DPoint *position = landmark.position;
  return @{
    @"x": [NSNumber numberWithDouble:position.x],
    @"y": [NSNumber numberWithDouble:position.y],
    @"confidence": [NSNumber numberWithDouble:landmark.inFrameLikelihood],
  };
}

- (id)callback:(Frame*)frame withArguments:(NSDictionary*)arguments {
  CMSampleBufferRef buffer = frame.buffer;
  UIImageOrientation orientation = frame.orientation;

  MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:buffer];
  image.orientation = orientation;

  MLKPoseDetector *detector = [PoseDetectorPlugin detector];
  NSError *error;
  NSArray<MLKPose *> *poses = [detector resultsInImage:image error:&error];

  if (error != nil) {
    return nil;
  }

  if (poses.count == 0) {
    return nil;
  }

  for (MLKPose *pose in poses) {
    return @{
      @"nose": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeNose]],
      @"leftEyeInner": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftEyeInner]],
      @"leftEye": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftEye]],
      @"leftEyeOuter": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftEyeOuter]],
      @"rightEyeInner": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightEyeInner]],
      @"rightEye": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightEye]],
      @"rightEyeOuter": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightEyeOuter]],
      @"leftEar": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftEar]],
      @"rightEar": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightEar]],
      @"mouthLeft": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeMouthLeft]],
      @"mouthRight": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeMouthRight]],
      @"leftShoulder": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftShoulder]],
      @"rightShoulder": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightShoulder]],
      @"leftElbow": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftElbow]],
      @"rightElbow": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightElbow]],
      @"leftWrist": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftWrist]],
      @"rightWrist": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightWrist]],
      @"leftPinkyFinger": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftPinkyFinger]],
      @"rightPinkyFinger": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightPinkyFinger]],
      @"leftIndexFinger": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftIndexFinger]],
      @"rightIndexFinger": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightIndexFinger]],
      @"leftThumb": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftThumb]],
      @"rightThumb": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightThumb]],
      @"leftHip": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftHip]],
      @"rightHip": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightHip]],
      @"leftKnee": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftKnee]],
      @"rightKnee": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightKnee]],
      @"leftAnkle": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftAnkle]],
      @"rightAnkle": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightAnkle]],
      @"leftHeel": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftHeel]],
      @"rightHeel": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightHeel]],
      @"leftFootIndex": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeLeftToe]],
      @"rightFootIndex": [PoseDetectorPlugin getLandmarkPosition:[pose landmarkOfType:MLKPoseLandmarkTypeRightToe]]
    };
  }
  return nil;
}

+ (void) load {
  [FrameProcessorPluginRegistry addFrameProcessorPlugin:@"detectPose"
                                        withInitializer:^FrameProcessorPlugin*(NSDictionary* options) {
    return [[PoseDetectorPlugin alloc] initWithOptions:options];
  }];
}

@end
