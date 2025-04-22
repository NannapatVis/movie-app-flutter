import 'package:flutter/material.dart';
import '../models/movie.dart';

class AddMovieScreen extends StatefulWidget {
  final Movie? movie;
  final int? index;

  const AddMovieScreen({super.key, this.movie, this.index});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  DateTime? _watchedDate;

  @override
  void initState() {
    super.initState();
    final movie = widget.movie;
    _nameController = TextEditingController(text: movie?.name ?? '');
    _ratingController = TextEditingController(text: movie?.rating.toString() ?? '');
    _imageUrlController = TextEditingController(text: movie?.imageUrl ?? '');
    _descriptionController = TextEditingController(text: movie?.description ?? '');
    _watchedDate = movie?.watchedDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratingController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _watchedDate != null) {
      final movie = Movie(
        name: _nameController.text,
        rating: double.parse(_ratingController.text),
        imageUrl: _imageUrlController.text,
        description: _descriptionController.text,
        watchedDate: _watchedDate!,
      );
      Navigator.pop(context, movie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Movie Name'),
                validator: (value) => value!.isEmpty ? 'Enter movie name' : null,
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter rating' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL or asset path'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(_watchedDate == null
                        ? 'No date chosen'
                        : 'Watched: ${_watchedDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _watchedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _watchedDate = picked;
                        });
                      }
                    },
                    child: const Text('Pick Date'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.movie == null ? 'Add Movie' : 'Update Movie'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
