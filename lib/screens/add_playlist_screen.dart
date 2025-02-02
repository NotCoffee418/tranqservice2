import 'package:flutter/material.dart';
import 'package:tranqservice2/widgets/screen_layout.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tranqservice2/services/ytdlp_service.dart';
import 'package:tranqservice2/services/database_access/log_access.dart';
import 'package:tranqservice2/services/database_access/playlist_access.dart';

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
    String? selectedDirectory = await getDirectoryPath(confirmButtonText: 'Select Directory');
    if (selectedDirectory != null) {
      _directoryController.text = selectedDirectory;
    }
  }

  void _addPlaylist() async {
    if (_isAdding) return;
    setState(() => _isAdding = true);

    if (_formKey.currentState!.validate()) {
      final url = _urlController.text.trim();
      final directory = _directoryController.text.trim();
      final format = _selectedFormat;

      await LogAccess.addLog(LogVerbosity.debug, 'Validating playlist URL: $url');

      final info = await YtdlpService.fetchPlaylistInfo(url);
      if (info == null) {
        await LogAccess.addLog(LogVerbosity.error, 'Invalid playlist URL: $url');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid playlist URL')),
          );
        }
        setState(() => _isAdding = false);
        return;
      }

      final name = info['title'] ?? 'Unknown Playlist';
      final thumbnail = info['thumbnail'] ?? '';

      await LogAccess.addLog(LogVerbosity.info, 'Adding playlist: $name');
      await PlaylistAccess.addPlaylist(name, url, directory, format, thumbnail);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }

    setState(() => _isAdding = false);
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      decoration: const InputDecoration(labelText: 'Playlist URL'),
                      validator: (text) => text == null || text.isEmpty ? 'Please enter a playlist URL' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        final clipboardData = await Clipboard.getData('text/plain');
                        if (clipboardData?.text != null) {
                          setState(() {
                            _urlController.text = clipboardData!.text!;
                          });
                        }
                      },
                      child: const Text('Paste'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _directoryController,
                      decoration: const InputDecoration(labelText: 'Save Directory'),
                      validator: (text) => text == null || text.isEmpty ? 'Please select a save directory' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _browseDirectory,
                      child: const Text('Browse'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFormat,
                items: const [
                  DropdownMenuItem(value: 'mp3', child: Text('MP3')),
                  DropdownMenuItem(value: 'mp4', child: Text('MP4')),
                ],
                onChanged: (value) => _selectedFormat = value!,
                decoration: const InputDecoration(labelText: 'Save as'),
              ),
              const SizedBox(height: 32),
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