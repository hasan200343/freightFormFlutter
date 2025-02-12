import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AutoCompleteWidget extends StatefulWidget {
  final Function(String) onSelected; // Callback when an item is selected
  final String query; // Query from the parent text field

  const AutoCompleteWidget(
      {super.key, required this.onSelected, required this.query});

  @override
  AutoCompleteWidgetState createState() => AutoCompleteWidgetState();
}

class AutoCompleteWidgetState extends State<AutoCompleteWidget> {
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  final _debouncer = Debouncer(milliseconds: 300);
  bool _ignoreNextQueryUpdate = false; // New flag

  @override
  void didUpdateWidget(AutoCompleteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_ignoreNextQueryUpdate) {
      // Skip API call if selection just happened
      _ignoreNextQueryUpdate = false;
      return;
    }

    if (widget.query != oldWidget.query) {
      _debouncer.run(() => _fetchSuggestions());
    }
  }

  Future<void> _fetchSuggestions() async {
    if (widget.query.isEmpty || widget.query.length < 3) {
      _hideSuggestions();
      return;
    }

    try {
      final response = await http.get(Uri.parse(
        "http://universities.hipolabs.com/search?name=${widget.query}",
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _suggestions = data.map((e) => e['name'].toString()).toList();
          _showSuggestions = true;
        });
      }
    } catch (e) {
      _hideSuggestions();
    }
  }

  void _hideSuggestions() {
    setState(() {
      _showSuggestions = false;
      _suggestions.clear();
    });
  }

  void _handleSuggestionSelected(String value) {
    widget.onSelected(value); // Update parent text field
    _hideSuggestions(); // Hide list immediately
    _ignoreNextQueryUpdate = true; // Prevent new API call for this query
    _debouncer.cancel(); // Cancel pending API calls
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _showSuggestions,
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _suggestions.take(10).length,
          itemBuilder: (context, index) => ListTile(
            title: Text(_suggestions[index]),
            onTap: () => _handleSuggestionSelected(_suggestions[index]),
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
