import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'package:flutter/services.dart';

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
  bool _isAdding = false;

  @override
  void dispose() {
    _urlController.dispose();
    _directoryController.dispose();
    super.dispose();
  }

  Future<void> _browseDirectory() async {
    String? initialDirectory;

    // Determine initial directory based on platform and format
    if (Platform.isWindows) {
      if (_selectedFormat == 'mp3') {
        initialDirectory = '${Platform.environment['USERPROFILE']}\\Music';
      } else if (_selectedFormat == 'mp4') {
        initialDirectory = '${Platform.environment['USERPROFILE']}\\Videos';
      }
    } else if (Platform.isLinux || Platform.isMacOS) {
      if (_selectedFormat == 'mp3') {
        final musicDir = Directory('${Platform.environment['HOME']}/Music');
        if (musicDir.existsSync()) {
          initialDirectory = musicDir.path;
        }
      } else if (_selectedFormat == 'mp4') {
        final videosDir = Directory('${Platform.environment['HOME']}/Videos');
        if (videosDir.existsSync()) {
          initialDirectory = videosDir.path;
        }
      }
    }

    // Fallback to home directory
    initialDirectory ??= Platform.isWindows
        ? Platform.environment['USERPROFILE']
        : Platform.environment['HOME'];

    // Use file_selector to open directory picker
    final selectedDirectory = await getDirectoryPath(
      initialDirectory: initialDirectory,
      confirmButtonText: 'Select Directory',
    );

    if (selectedDirectory != null) {
      _directoryController.text = selectedDirectory;
    }
  }

void _addPlaylist() {
  if (_isAdding) return;
  _isAdding = true;
  if (_formKey.currentState!.validate()) {
    // Pop latest ScaffoldMessenger defined in playlist_screen.dart
    // since it shows there. its sketch but cant bother right now.
    Navigator.pop(context, true);
  }
  _isAdding = false;
}


  String? _validateDirectory(String? text) {
    if (text == null || text.isEmpty) {
      return 'Please select a save directory';
    }
    return null;
  }

  String? _validateUrl(String? text) {
    if (text == null || text.isEmpty) {
      return 'Please enter a playlist URL';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Add Playlist',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Playlist URL Input with Paste Button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'Playlist URL',
                      ),
                      validator: _validateUrl,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100, // Match size with Browse button
                    child: ElevatedButton(
                      onPressed: () async {
                        final clipboardData =
                            await Clipboard.getData('text/plain');
                        if (clipboardData != null && clipboardData.text != null) {
                          setState(() {
                            _urlController.text = clipboardData.text!;
                          });
                        }
                      },
                      child: const Text('Paste'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Save Directory Input with Browse Button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _directoryController,
                      decoration: const InputDecoration(
                        labelText: 'Save Directory',
                      ),
                      validator: _validateDirectory,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100, // Match size with Paste button
                    child: ElevatedButton(
                      onPressed: _browseDirectory,
                      child: const Text('Browse'),
                    ),
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
