
import 'package:equatable/equatable.dart';

import '../models/movie.dart';

class MovieState extends Equatable {
  final List<Movie> movies;

  const MovieState({this.movies = const []});

  MovieState copyWith({List<Movie>? movies}) {
    return MovieState(movies: movies ?? this.movies);
  }

  @override
  List<Object?> get props => [movies];
}
