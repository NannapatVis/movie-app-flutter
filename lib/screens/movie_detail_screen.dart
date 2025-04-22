import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: movie.imageUrl.isNotEmpty
                  ? Uri.tryParse(movie.imageUrl)?.isAbsolute ?? false
                      ? Image.network(
                          movie.imageUrl,
                          width: 500,
                          height: 500,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 150),
                        )
                      : Image.asset(
                          movie.imageUrl,
                          width: 500,
                          height: 500,
                          fit: BoxFit.cover,
                        )
                  : const Icon(Icons.movie, size: 250),
            ),
            const SizedBox(height: 20),
            Text('Movie Name: ${movie.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Rating: ${movie.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Watched Date: ${movie.watchedDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (movie.description != null && movie.description!.isNotEmpty) ...[
              const Text('Description:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(movie.description!, style: const TextStyle(fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }
}
