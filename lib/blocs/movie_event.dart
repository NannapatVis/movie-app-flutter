import 'package:equatable/equatable.dart';
import '../models/movie.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class AddMovie extends MovieEvent {
  final Movie movie;

  const AddMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}

class UpdateMovie extends MovieEvent {
  final int index;
  final Movie updatedMovie;

  const UpdateMovie(this.index, this.updatedMovie);

  @override
  List<Object?> get props => [index, updatedMovie];
}

class DeleteMovie extends MovieEvent {
  final int index;

  const DeleteMovie(this.index);

  @override
  List<Object?> get props => [index];
}
