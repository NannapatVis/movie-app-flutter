import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/models/movie.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(const MovieState()) {
    on<AddMovie>((event, emit) {
      final updatedMovies = List<Movie>.from(state.movies)..add(event.movie);
      emit(state.copyWith(movies: updatedMovies));
    });

    on<UpdateMovie>((event, emit) {
      final updatedMovies = List<Movie>.from(state.movies)
        ..[event.index] = event.updatedMovie;
      emit(state.copyWith(movies: updatedMovies));
    });

    on<DeleteMovie>((event, emit) {
      final updatedMovies = List<Movie>.from(state.movies)
        ..removeAt(event.index);
      emit(state.copyWith(movies: updatedMovies));
    });
  }
}
