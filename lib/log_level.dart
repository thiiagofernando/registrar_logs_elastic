enum LogLevel {
  trace('Trace'),
  debug('Debug'),
  information('Information'),
  warning('Information'),
  error('Error'),
  critical('Critical'),
  none('None');

  const LogLevel(this.logLevel);

  final String logLevel;
}
