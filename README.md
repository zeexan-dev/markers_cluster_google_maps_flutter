# markers_cluster_google_maps_flutter

A flutter package for clustering the markers on google maps flutter.

## Installation

To use this plugin, add markers_cluster_google_maps_flutter as a dependency in your pubspec.yaml file.

## Usage
1. Import the package with:
```dart
import 'package:markers_cluster_google_maps_flutter/markers_cluster_google_maps_flutter.dart';
```

2. Initialize the MarkersClusterManager:
```dart
final clusterManager = MarkersClusterManager();
```

3. Add markers using following method:
```dart
clusterManager.addMarker()
```

4. Update clusters at a specific zoom level:
```dart
await clusterManager.updateClusters(zoomLevel: 12);
```

5. Get the clustered markers with following method
```dart
final clusteredMarkers = clusterManager.getClusteredMarkers();
```

6. Use the clustered markers in your GoogleMap widget:
```dart
GoogleMap(
  mapType: MapType.normal,
  onMapCreated: (GoogleMapController controller) {
    // Complete controller and update clusters
  },
  initialCameraPosition: CameraPosition(
    target: LatLng(33.6937, 73.0653),
    zoom: 10.0,
  ),
  onCameraMove: (CameraPosition position) {
    // Update clusters based on zoom level
  },
  markers: Set<Marker>.of(clusteredMarkers),
);
```

## Support and Contribute
For support, please star on Github repository. Contributions are welcome! Please submit issues and pull requests on the GitHub repository.
