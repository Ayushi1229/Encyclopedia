import '../utils/import_export.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String photo;

  const DetailScreen({super.key, required this.name, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 250, // Adjust height as needed
              width: double.infinity,
              child: Image.asset(
                photo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Button 1')),
                ElevatedButton(onPressed: () {}, child: const Text('Button 2')),
                ElevatedButton(onPressed: () {}, child: const Text('Button 3')),
              ],
            ),

            const SizedBox(height: 20),

            // Placeholder card (can add info later)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Additional details or content card goes here.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
