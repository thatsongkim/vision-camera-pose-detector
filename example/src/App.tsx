import React from 'react';
import { Platform, StyleSheet, View } from 'react-native';
import {
  Camera,
  useCameraDevice,
  useFrameProcessor,
} from 'react-native-vision-camera';
import { detectPose } from 'vision-camera-pose-detector';

export default function App() {
  const device = useCameraDevice('front');
  const isIOS = Platform.OS === 'ios';

  const frameProcessor = useFrameProcessor((frame) => {
    'worklet';
    const pose = detectPose(frame);
    console.log(pose);
  }, []);

  if (device == null) return <View />;
  return (
    <Camera
      style={StyleSheet.absoluteFill}
      device={device}
      isActive={!!device}
      pixelFormat={isIOS ? 'native' : 'yuv'}
      video={true}
      orientation="portrait"
      onError={(err) => console.log(err)}
      fps={30}
      frameProcessor={frameProcessor}
    />
  );
}
