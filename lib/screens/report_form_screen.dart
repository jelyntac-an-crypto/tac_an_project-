
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _state = ReportUiState.idle;
  bool _simulateFailure = false;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
  if (_state == ReportUiState.idle &&
      !_formKey.currentState!.validate()) {
    return;
  }
    setState(() => _state = ReportUiState.loading);

    try {
      await Future<void>.delayed(const Duration(seconds: 3));

      if (_simulateFailure) {
        throw Exception('Simulated failure');
      }

      if (!mounted) return;
      setState(() => _state = ReportUiState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = ReportUiState.error);
    }
  }

  Widget _messageState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          AppButton(
            text: buttonText,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-FORECAST Report Form')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case ReportUiState.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading report... Please wait.'),
            ],
          ),
        );

      case ReportUiState.success:
        return _messageState(
          icon: Icons.check_circle,
          color: Colors.green,
          title: 'Report Submitted Successfully!',
          message: 'This is a simulated response. '
              'No report was saved to a database.',
          buttonText: 'Submit Another Report',
          onPressed: () => setState(() {
            _state = ReportUiState.idle;
          }),
        );

      case ReportUiState.empty:
        return _messageState(
          icon: Icons.inbox_outlined,
          title: 'No Reports Available',
          message: 'There are currently no report records. '
              'The database is not connected yet.',
          buttonText: 'Back to Report Form',
          onPressed: () => setState(() {
            _state = ReportUiState.idle;
          }),
        );

      case ReportUiState.error:
        return _messageState(
          icon: Icons.error_outline,
          color: Colors.red,
          title: 'Report Submission Failed',
          message: 'A simulated error occurred. You can retry '
              'or correct the form.',
          buttonText: 'Retry Submission',
          onPressed: _submitReport,
        );

      case ReportUiState.idle:
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Submit a Consumption Report',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Report an electricity consumption concern.',
                ),
                const SizedBox(height: 24),

                AppTextField(
                  label: 'Report Title',
                  controller: _titleController,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter a report title.'
                          : null,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Category',
                  controller: _categoryController,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter a category.'
                          : null,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter a description.'
                          : null,
                ),
                const SizedBox(height: 12),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Simulate submission failure'),
                  subtitle: const Text('For testing the Error state'),
                  value: _simulateFailure,
                  onChanged: (value) => setState(() {
                    _simulateFailure = value ?? false;
                  }),
                ),
                const SizedBox(height: 12),

                AppButton(
                  text: 'Submit Report',
                  onPressed: _submitReport,
                ),
                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () => setState(() {
                    _state = ReportUiState.empty;
                  }),
                  child: const Text('View Reports / Empty State'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
