import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'booking.dart';
import 'dashboard.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController _mapController;
  BitmapDescriptor? _customIcon;

  final LatLng _mumbaiCenter = const LatLng(19.0760, 72.8777);

  final List<Map<String, dynamic>> _events = [
    {
      "id": "1",
      "title": "Beach Party",
      "description": "Get ready for a fun-filled evening at the beach!",
      "image": "assets/images/spotlight1.png",
      "location": LatLng(19.0822, 72.8410),
    },
    {
      "id": "2",
      "title": "Comedy Night",
      "description": "Laugh out loud with the best comedians in town.",
      "image": "assets/images/spotlight2.png",
      "location": LatLng(19.0210, 72.8556),
    },
    {
      "id": "3",
      "title": "Adventure Trek",
      "description": "Join us for an unforgettable mountain trek adventure.",
      "image": "assets/images/spotlight3.png",
      "location": LatLng(19.2167, 72.9833),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/images/purple_location_pin.png",
    );
    setState(() {
      _customIcon = icon;
    });
  }

  Set<Marker> _buildMarkers() {
    if (_customIcon == null) return {};
    return _events.map((event) {
      return Marker(
        markerId: MarkerId(event["id"]),
        position: event["location"],
        icon: _customIcon!,
        onTap: () => _showEventDetails(event),
      );
    }).toSet();
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2E0B5C).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                event["image"],
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event["description"],
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2E0B5C),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingPage(
                              title: event["title"],
                              image: event["image"],
                              description: event["description"],
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_customIcon == null) {
      // Show loading while marker is loading
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _mumbaiCenter,
              zoom: 11,
            ),
            markers: _buildMarkers(),
            onMapCreated: (controller) => _mapController = controller,
          ),
          // Custom AppBar overlay
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.black.withOpacity(0.4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "Event Map",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
