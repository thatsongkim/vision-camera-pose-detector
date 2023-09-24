# vision-camera-pose-detector

MLKit PoseDetectionAccurate for react-native-vision-camera V3

## 🚨Warning: iOS only for now
[Related issue](https://github.com/mrousavy/react-native-vision-camera/issues/1771)

## Installation

```sh
npm install vision-camera-pose-detector
```
or
```sh
yarn add vision-camera-pose-detector
```

## Usage

```js
import { detectPose } from "vision-camera-pose-detector";

// ...

const frameProcessor = useFrameProcessor((frame) => {
  'worklet';
  const pose = detectPose(frame);
}, []);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
