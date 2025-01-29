abstract class SummaryState {}

class SummaryInitial extends SummaryState {}

class SummaryFilePicked extends SummaryState {
  final String filePath;
  SummaryFilePicked({required this.filePath});
}

class SummaryRangeUpdated extends SummaryState {
  final String summaryRange;
  SummaryRangeUpdated({required this.summaryRange});
}

class SummaryThemeUpdated extends SummaryState {
  final String summaryTheme;
  SummaryThemeUpdated({required this.summaryTheme});
}

class SummaryLoading extends SummaryState {}

class SummarySuccess extends SummaryState {
  SummarySuccess();
}

class SummaryDownload extends SummaryState {
  final String downloadPath;
  SummaryDownload({required this.downloadPath});
}

class SummaryError extends SummaryState {
  final String errorMessage;
  SummaryError({required this.errorMessage});
}

