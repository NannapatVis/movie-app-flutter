import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/add_movie_screen.dart';
import 'package:movie_app/screens/movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [
    Movie(
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.jpg',
      name: 'Inception',
      rating: 9.0,
      watchedDate: DateTime(2020, 8, 10),
      description: 'A mind-bending thriller by Christopher Nolan.',
    ),
    Movie(
      imageUrl:
          'https://lh4.googleusercontent.com/proxy/S7gg9eh50TQatrbr5wb_Ql7bj7TmPA8fW3hPYZnIPgIl6yfCmjjZV26bgaEMAbvYbdUU460QozUAHiP4-CybDgoacsiSlHyiuYp9',
      name: 'The Dark Knight',
      rating: 9.5,
      watchedDate: DateTime(2019, 6, 12),
      description: 'The legendary Batman film by Christopher Nolan.',
    ),
    Movie(
      imageUrl:
          'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg',
      name: 'Interstellar',
      rating: 8.7,
      watchedDate: DateTime(2021, 7, 18),
      description:
          'A space exploration film that explores the concept of time.',
    ),
  ];

  // ฟังก์ชันเพิ่มหนังใหม่
  void addMovie(Movie newMovie) {
    setState(() {
      movies.add(newMovie);
    });
  }

  // ฟังก์ชันแก้ไขหนัง
  void editMovie(int index, Movie updatedMovie) {
    setState(() {
      movies[index] = updatedMovie;
    });
  }

  // ฟังก์ชันลบหนัง
  void deleteMovie(int index) {
    setState(() {
      movies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: movies.isEmpty
          ? const Center(
              child: Text(
                'No movies added yet. Click + to add a movie.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      // ส่วนรูปภาพ
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: movie.imageUrl.isNotEmpty
                            ? Uri.tryParse(movie.imageUrl)?.isAbsolute ?? false
                                ? Image.network(
                                    movie.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    movie.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                            : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.movie,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      // ส่วนข้อความ
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  'Rating: ${movie.rating.toStringAsFixed(1)}'),
                              Text(
                                  'Watched: ${movie.watchedDate.toLocal().toString().split(' ')[0]}'),
                            ],
                          ),
                        ),
                      ),
                      // ปุ่มแก้ไขและลบ
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedMovie = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieAddScreen(movie: movie),
                                ),
                              );
                              if (updatedMovie != null) {
                                editMovie(index, updatedMovie);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Movie'),
                                  content: const Text(
                                      'Are you sure you want to delete this movie?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteMovie(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMovie = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieAddScreen(),
            ),
          );
          if (newMovie != null) {
            addMovie(newMovie);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
