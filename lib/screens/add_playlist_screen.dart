import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';

class AddPlaylistScreen extends StatefulWidget {
  const AddPlaylistScreen({super.key});

  @override
  State<AddPlaylistScreen> createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _directoryController = TextEditingController();
  String _selectedFormat = 'mp3';

  @override
  void dispose() {
    _urlController.dispose();
    _directoryController.dispose();
    super.dispose();
  }

  void _browseDirectory() async {
    // Simulate directory selection
    // Only update the controller without using `setState`
    _directoryController.text = "/path/to/selected/directory";
  }

  void _addPlaylist() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, true); // Indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Add Playlist',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( // ListView for smooth scrolling, especially with long forms
            children: [
              // Playlist URL Input
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Playlist URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a playlist URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Save Directory Input
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _directoryController,
                      readOnly: true, // Prevent manual input
                      decoration: const InputDecoration(
                        labelText: 'Save Directory',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a save directory';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _browseDirectory,
                    child: const Text('Browse'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Save as Format Dropdown
              DropdownButtonFormField<String>(
                value: _selectedFormat,
                items: const [
                  DropdownMenuItem(value: 'mp3', child: Text('MP3')),
                  DropdownMenuItem(value: 'mp4', child: Text('MP4')),
                ],
                onChanged: (value) {
                  // Update `_selectedFormat` directly without `setState`
                  _selectedFormat = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Save as',
                ),
              ),
              const SizedBox(height: 32),

              // Add Playlist Button
              Center(
                child: ElevatedButton(
                  onPressed: _addPlaylist,
                  child: const Text('Add Playlist'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
