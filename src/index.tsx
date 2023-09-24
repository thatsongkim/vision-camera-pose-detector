import { VisionCameraProxy, type Frame } from 'react-native-vision-camera';

const _detectPose = VisionCameraProxy.getFrameProcessorPlugin('detectPose');

type Landmark = {
  x: number;
  y: number;
  confidence: number;
};

export type Landmarks = {
  nose: Landmark;
  leftEyeInner: Landmark;
  leftEye: Landmark;
  leftEyeOuter: Landmark;
  rightEyeInner: Landmark;
  rightEye: Landmark;
  rightEyeOuter: Landmark;
  leftEar: Landmark;
  rightEar: Landmark;
  mouthLeft: Landmark;
  mouthRight: Landmark;
  leftShoulder: Landmark;
  rightShoulder: Landmark;
  leftElbow: Landmark;
  rightElbow: Landmark;
  leftWrist: Landmark;
  rightWrist: Landmark;
  leftPinkyFinger: Landmark;
  rightPinkyFinger: Landmark;
  leftIndexFinger: Landmark;
  rightIndexFinger: Landmark;
  leftThumb: Landmark;
  rightThumb: Landmark;
  leftHip: Landmark;
  rightHip: Landmark;
  leftKnee: Landmark;
  rightKnee: Landmark;
  leftAnkle: Landmark;
  rightAnkle: Landmark;
  leftHeel: Landmark;
  rightHeel: Landmark;
  leftFootIndex: Landmark;
  rightFootIndex: Landmark;
};

export function detectPose(frame: Frame): Landmarks | undefined {
  'worklet';
  // @ts-ignore
  return _detectPose?.call(frame);
}
