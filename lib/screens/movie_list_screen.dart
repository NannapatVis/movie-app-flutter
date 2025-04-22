import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie_bloc.dart';
import '../blocs/movie_event.dart';
import '../blocs/movie_state.dart';
import '../models/movie.dart';
import 'add_movie_screen.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie List')),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies added yet. Click + to add a movie.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(movie: movie),
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
                            Text('Rating: ${movie.rating.toStringAsFixed(1)}'),
                            Text('Watched: ${movie.watchedDate.toLocal().toString().split(' ')[0]}'),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final updatedMovie = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMovieScreen(
                                  movie: movie,
                                  index: index,
                                ),
                              ),
                            );
                            if (updatedMovie != null) {
                              context.read<MovieBloc>().add(UpdateMovie(index, updatedMovie));
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
                                content: const Text('Are you sure you want to delete this movie?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<MovieBloc>().add(DeleteMovie(index));
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMovie = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMovieScreen(),
            ),
          );
          if (newMovie != null) {
            context.read<MovieBloc>().add(AddMovie(newMovie));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

