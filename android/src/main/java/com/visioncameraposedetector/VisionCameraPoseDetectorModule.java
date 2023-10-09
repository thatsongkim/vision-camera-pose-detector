package com.visioncameraposedetector;

import android.media.Image;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.common.PointF3D;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetection;
import com.google.mlkit.vision.pose.PoseDetector;
import com.google.mlkit.vision.pose.PoseLandmark;
import com.google.mlkit.vision.pose.accurate.AccuratePoseDetectorOptions;
import com.mrousavy.camera.frameprocessor.Frame;
import com.mrousavy.camera.frameprocessor.FrameProcessorPlugin;
import com.mrousavy.camera.parsers.Orientation;

import java.util.HashMap;
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
        Pose pose = Tasks.await(result);

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

        Map<String, Object> landmarks = new HashMap<>();

        for (var i = 0; i < landMarkNames.length; i++) {
          PoseLandmark landmark = pose.getPoseLandmark(i);
          Map<String, Object> map = new HashMap<>();
          if (landmark == null) {
            map.put("x", 0);
            map.put("y", 0);
            map.put("z", 0);
            map.put("confidence", 0);
            landmarks.put(landMarkNames[i], map);
            continue;
          }
          PointF3D positions = landmark.getPosition3D();
          double x = positions.getX();
          double y = positions.getY();
          double z = positions.getZ();
          double confidence = landmark.getInFrameLikelihood();

          map.put("x", x);
          map.put("y", y);
          map.put("z", z);
          map.put("confidence", confidence);
          landmarks.put(landMarkNames[i], map);
        }

        return landmarks;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }
}
