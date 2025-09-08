enum FixedCommand {
  help('/help'),
  settings('/settings');

  const FixedCommand(this.commandText);
  final String commandText;
}
