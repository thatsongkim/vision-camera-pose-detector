
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNVisionCameraPoseDetectorSpec.h"

@interface VisionCameraPoseDetector : NSObject <NativeVisionCameraPoseDetectorSpec>
#else
#import <React/RCTBridgeModule.h>

@interface VisionCameraPoseDetector : NSObject <RCTBridgeModule>
#endif

@end
