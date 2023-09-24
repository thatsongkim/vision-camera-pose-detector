package com.visioncameraposedetector;

import android.graphics.PointF;
import android.media.Image;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.WritableNativeMap;
import com.google.android.gms.tasks.Task;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetection;
import com.google.mlkit.vision.pose.accurate.AccuratePoseDetectorOptions;
import com.google.mlkit.vision.pose.PoseDetector;

import com.google.mlkit.vision.pose.PoseLandmark;
import com.mrousavy.camera.frameprocessor.Frame;
import com.mrousavy.camera.frameprocessor.FrameProcessorPlugin;
import com.mrousavy.camera.parsers.Orientation;

import java.util.Map;

public class VisionCameraPoseDetectorModule extends FrameProcessorPlugin {
  private final AccuratePoseDetectorOptions options =
    new AccuratePoseDetectorOptions.Builder()
      .setDetectorMode(AccuratePoseDetectorOptions.STREAM_MODE)
      .build();

  private final PoseDetector detector = PoseDetection.getClient(options);

  @Nullable
  @Override
  public Object callback(@NonNull Frame frame, @Nullable Map<String, Object> arguments) {
    try {
      Image mediaImage = frame.getImage();
      Log.e("Log", frame.getPixelFormat());
      if (mediaImage != null) {
        InputImage image = InputImage.fromMediaImage(mediaImage, Orientation.Companion.fromUnionValue(frame.getOrientation()).toDegrees());
        Task<Pose> result = detector.process(image);
        Pose pose = result.getResult();

        if (pose == null) {
          return null;
        }

        String[] landMarkNames = {
          "nose",
          "leftEyeInner",
          "leftEye",
          "leftEyeOuter",
          "rightEyeInner",
          "rightEye",
          "rightEyeOuter",
          "leftEar",
          "rightEar",
          "leftMouth",
          "rightMouth",
          "leftShoulder",
          "rightShoulder",
          "leftElbow",
          "rightElbow",
          "leftWrist",
          "rightWrist",
          "leftPinky",
          "rightPinky",
          "leftIndex",
          "rightIndex",
          "leftThumb",
          "rightThumb",
          "leftHip",
          "rightHip",
          "leftKnee",
          "rightKnee",
          "leftAnkle",
          "rightAnkle",
          "leftHeel",
          "rightHeel",
          "leftFootIndex",
          "rightFootIndex"
        };

        WritableNativeMap landmarks = new WritableNativeMap();
        for (var i = 0; i < landMarkNames.length; i++) {
          PoseLandmark landmark = pose.getPoseLandmark(i);
          WritableNativeMap map = new WritableNativeMap();
          if (landmark == null) {
            map.putDouble("x", 0);
            map.putDouble("y", 0);
            map.putDouble("confidence", 0);
            landmarks.putMap(landMarkNames[i], map);
            continue;
          }
          PointF positions = landmark.getPosition();
          map.putDouble("x", positions.x);
          map.putDouble("y", positions.y);
          map.putDouble("confidence", landmark.getInFrameLikelihood());
          landmarks.putMap(landMarkNames[i], map);
        }

        return landmarks;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }
}
