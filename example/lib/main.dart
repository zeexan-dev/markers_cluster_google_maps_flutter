import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markers_cluster_google_maps_flutter/markers_cluster_google_maps_flutter.dart';

class MarkersClusterExampleBasic extends StatefulWidget {
  const MarkersClusterExampleBasic({super.key});

  @override
  State<MarkersClusterExampleBasic> createState() =>
      _MarkersClusterExampleBasicState();
}

class _MarkersClusterExampleBasicState
    extends State<MarkersClusterExampleBasic> {
  // Completer to hold the GoogleMapController
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  // Instance of the custom MarkersClusterManager
  late MarkersClusterManager _clusterManager;
  // Initial zoom level of the map
  double _currentZoom = 5.5;

  @override
  void initState() {
    super.initState();
    // Initialize the cluster manager with custom settings
    _clusterManager = MarkersClusterManager(
      clusterMarkerSize: 35.0,
      clusterColor: Colors.blue,
      clusterBorderThickness: 4.0,
      clusterBorderColor: Colors.blue[900]!,
      clusterOpacity: 1.0,
      clusterTextStyle: TextStyle(fontSize: 15, color: Colors.white),
      onMarkerTap: (LatLng position) {
        _handleMarkerTap(position);
      },
    );
    // Add initial markers to the cluster manager
    _addMarkers();
  }

  // Function to add markers for different cities
  void _addMarkers() {
    // Coordinates for Islamabad
    List<LatLng> islamabadCoordinates = [
      LatLng(33.6844, 73.0479),
      LatLng(33.7070, 73.0551),
      LatLng(33.7215, 73.0433),
      LatLng(33.7398, 73.0372),
      LatLng(33.7380, 73.0845),
      LatLng(33.7029, 73.0591),
      LatLng(33.7297, 73.0735),
      LatLng(33.6826, 73.0606),
      LatLng(33.6913, 73.0383),
      LatLng(33.6786, 73.0320)
    ];

    // Coordinates for Lahore
    List<LatLng> lahoreCoordinates = [
      LatLng(31.5497, 74.3436),
      LatLng(31.5525, 74.3587),
      LatLng(31.5603, 74.3263),
      LatLng(31.5204, 74.3587),
      LatLng(31.5331, 74.3440),
      LatLng(31.5783, 74.3673),
      LatLng(31.5615, 74.3106),
      LatLng(31.5733, 74.3644),
      LatLng(31.5094, 74.3536),
      LatLng(31.5150, 74.3437)
    ];

    // Coordinates for Karachi
    List<LatLng> karachiCoordinates = [
      LatLng(24.8607, 67.0011),
      LatLng(24.8701, 67.0234),
      LatLng(24.8472, 67.0322),
      LatLng(24.8952, 67.0280),
      LatLng(24.8615, 67.0099),
      LatLng(24.8846, 67.0681),
      LatLng(24.8595, 67.0425),
      LatLng(24.8731, 67.0212),
      LatLng(24.8683, 67.0301),
      LatLng(24.8865, 67.0512)
    ];

    // Coordinates for Peshawar
    List<LatLng> peshawarCoordinates = [
      LatLng(34.0124, 71.5785),
      LatLng(34.0125, 71.5786),
      LatLng(34.0126, 71.5787),
      LatLng(34.0167, 71.5249),
      LatLng(34.0222, 71.5760),
      LatLng(34.0059, 71.5374),
      LatLng(34.0077, 71.5718),
      LatLng(34.0161, 71.5357),
      LatLng(34.0033, 71.5444),
      LatLng(34.0195, 71.5651)
    ];

    // Coordinates for Quetta
    List<LatLng> quettaCoordinates = [
      LatLng(30.1798, 66.9750),
      LatLng(30.1916, 66.9904),
      LatLng(30.1738, 67.0040),
      LatLng(30.1623, 67.0098),
      LatLng(30.1425, 66.9978),
      LatLng(30.1964, 66.9466),
      LatLng(30.2092, 66.9212),
      LatLng(30.2189, 66.8999),
      LatLng(30.2362, 66.8741),
      LatLng(30.2523, 66.9112)
    ];

    // Add markers for Islamabad
    for (var i = 0; i < islamabadCoordinates.length; i++) {
      _clusterManager.addMarker(Marker(
          markerId: MarkerId('islamabad_$i'),
          position: islamabadCoordinates[i],
          infoWindow: InfoWindow(title: 'Islamabad Marker $i')));
    }

    // Add markers for Lahore
    for (var i = 0; i < lahoreCoordinates.length; i++) {
      _clusterManager.addMarker(Marker(
          markerId: MarkerId('lahore_$i'),
          position: lahoreCoordinates[i],
          infoWindow: InfoWindow(title: 'Lahore Marker $i')));
    }

    // Add markers for Karachi
    for (var i = 0; i < karachiCoordinates.length; i++) {
      _clusterManager.addMarker(Marker(
          markerId: MarkerId('karachi_$i'),
          position: karachiCoordinates[i],
          infoWindow: InfoWindow(title: 'Karachi Marker $i')));
    }

    // Add markers for Peshawar
    for (var i = 0; i < peshawarCoordinates.length; i++) {
      _clusterManager.addMarker(Marker(
          markerId: MarkerId('peshawar_$i'),
          position: peshawarCoordinates[i],
          infoWindow: InfoWindow(title: 'Peshawar Marker $i')));
    }

    // Add markers for Quetta
    for (var i = 0; i < quettaCoordinates.length; i++) {
      _clusterManager.addMarker(Marker(
          markerId: MarkerId('quetta_$i'),
          position: quettaCoordinates[i],
          infoWindow: InfoWindow(title: 'Quetta Marker $i')));
    }
  }

  // Handle marker tap event
  void _handleMarkerTap(LatLng position) async {
    // Add your code for handling marker tap
  }

  // Update clusters based on the current zoom level
  Future<void> _updateClusters() async {
    await _clusterManager.updateClusters(zoomLevel: _currentZoom);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Markers Cluster")),
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) async {
            _mapController.complete(controller);
            // Update clusters when the map is created
            await _updateClusters();
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(30.3753, 69.3451),
            zoom: _currentZoom,
          ),
          onCameraMove: (CameraPosition position) async {
            _currentZoom = position.zoom;
            // Update clusters on camera move
            debugPrint("current zoom: ${_currentZoom}");
            await _updateClusters();
          },
          myLocationEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: Set<Marker>.of(_clusterManager.getClusteredMarkers()),
        ),
      ]),
    );
  }
}
