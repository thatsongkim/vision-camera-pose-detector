import React from 'react';
import { StyleSheet, View } from 'react-native';
import {
  Camera,
  useCameraDevices,
  useFrameProcessor,
} from 'react-native-vision-camera';
import { detectPose } from 'vision-camera-pose-detector';

export default function App() {
  const devices = useCameraDevices();
  const device = devices.front;

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
      video={true}
      orientation="portrait"
      onError={(err) => console.log(err)}
      fps={30}
      frameProcessor={frameProcessor}
    />
  );
}
