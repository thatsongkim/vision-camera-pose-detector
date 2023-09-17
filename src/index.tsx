import { VisionCameraProxy, type Frame } from 'react-native-vision-camera';

const _detectPose = VisionCameraProxy.getFrameProcessorPlugin('detectPose');
export function detectPose(frame: Frame): any {
  'worklet';
  // @ts-ignore
  return _detectPose?.call(frame);
}
