library markers_cluster_google_maps_flutter;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;


class MarkersClusterManager {
  final Map<double, double> zoomLevelRadius;
  List<Marker> _markers = [];
  List<Marker> _clusteredMarkers = [];
  Function(LatLng)? onMarkerTap;
  final Color clusterColor;
  final TextStyle clusterTextStyle;
  final ShapeBorder clusterShape;
  final double clusterBorderThickness;
  final Color clusterBorderColor;
  final double clusterOpacity;

  // Default values for zoomLevelRadius
  static Map<double, double> _defaultZoomLevelRadius = {
    3.0: 20000.0,
    5.0: 10000.0,
    8.0: 5000.0,
    10.0: 2000.0,
    12.0: 100.0,
    15.0: 0.0,
  };
  static const double _minZoomLevel = 3.0; //  minimum zoom level

  MarkersClusterManager({
    Map<double, double>? zoomLevelRadius,
    this.onMarkerTap,
    this.clusterColor = Colors.blue,
    this.clusterShape = const CircleBorder(),
    this.clusterBorderThickness = 15,
    this.clusterBorderColor = Colors.black,
    this.clusterOpacity = 1.0,
    this.clusterTextStyle = const TextStyle(
      fontSize: 40,
      color: Colors.white,
    ),
  }) : zoomLevelRadius = zoomLevelRadius ?? _defaultZoomLevelRadius;

  void addMarker(Marker marker) {
    _markers.add(marker);
  }

  Future<void> updateClusters({required double zoomLevel}) async {
     // Ensure the zoom level does not go below the minimum threshold
    if (zoomLevel < _minZoomLevel) {
      zoomLevel = _minZoomLevel;
    }
    double radius = _getRadiusForZoomLevel(zoomLevel);

    if (radius == 0.0) {
      _clusteredMarkers = _markers;
      return;
    }

    _clusteredMarkers = await _createClusters(_markers, radius);
  }

  double _getRadiusForZoomLevel(double zoomLevel) {
    double? radius;
    for (var entry in zoomLevelRadius.entries) {
      if (zoomLevel >= entry.key) {
        radius = entry.value;
      } else {
        break;
      }
    }
    return radius ?? 0.0; // Default to 0.0 if no match found
  }

  Future<List<Marker>> _createClusters(
      List<Marker> markers, double radius) async {
    List<Marker> clusters = [];
    Set<Marker> processed = Set<Marker>();

    for (var marker in markers) {
      if (processed.contains(marker)) continue;

      List<Marker> cluster = [];
      cluster.add(marker);
      processed.add(marker);

      for (var otherMarker in markers) {
        if (processed.contains(otherMarker)) continue;
        if (_calculateDistance(marker.position, otherMarker.position) <
            radius) {
          cluster.add(otherMarker);
          processed.add(otherMarker);
        }
      }

      if (cluster.length > 1) {
        LatLng clusterPosition = LatLng(
          cluster.map((m) => m.position.latitude).reduce((a, b) => a + b) /
              cluster.length,
          cluster.map((m) => m.position.longitude).reduce((a, b) => a + b) /
              cluster.length,
        );

        final clusterMarker =
            await _createClusterMarker(clusterPosition, cluster.length);
        clusters.add(clusterMarker);
      } else {
        clusters.add(marker.copyWith(onTapParam: () {
          if (onMarkerTap != null) {
            onMarkerTap!(marker.position);
          }
        }));
      }
    }

    return clusters;
  }

  Future<Marker> _createClusterMarker(LatLng position, int clusterSize) async {
    final bitmapDescriptor = await _createCustomClusterBitmap(clusterSize);

    return Marker(
      markerId: MarkerId('cluster_${position.toString()}'),
      position: position,
      infoWindow: InfoWindow(title: '$clusterSize markers'),
      icon: bitmapDescriptor,
      onTap: () {
        if (onMarkerTap != null) {
          onMarkerTap!(position);
        }
      },
    );
  }

  Future<BitmapDescriptor> _createCustomClusterBitmap(int clusterSize) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = clusterColor.withOpacity(clusterOpacity);
    final borderPaint = Paint()
      ..color = clusterBorderColor
      ..strokeWidth = clusterBorderThickness
      ..style = PaintingStyle.stroke;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    const double size = 100.0;

    // Draw shape
    final shape = clusterShape.getOuterPath(
      Rect.fromCircle(center: Offset(size / 2, size / 2), radius: size / 2),
    );
    canvas.drawPath(shape, paint);
    
    if (clusterBorderThickness > 0) {
      if (clusterShape is CircleBorder) {
        canvas.drawCircle(Offset(size / 2, size / 2),
            size / 2 - clusterBorderThickness / 2, borderPaint);
      } else {
        canvas.drawPath(shape, borderPaint);
      }
    }

    // Draw text
    textPainter.text =
        TextSpan(text: clusterSize.toString(), style: clusterTextStyle);
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size / 2) - (textPainter.width / 2),
        (size / 2) - (textPainter.height / 2),
      ),
    );

    final image = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  double _calculateDistance(LatLng pos1, LatLng pos2) {
    const double earthRadius = 6371000; // meters
    double lat1 = pos1.latitude * math.pi / 180;
    double lon1 = pos1.longitude * math.pi / 180;
    double lat2 = pos2.latitude * math.pi / 180;
    double lon2 = pos2.longitude * math.pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  List<Marker> getClusteredMarkers() {
    return _clusteredMarkers;
  }
}
