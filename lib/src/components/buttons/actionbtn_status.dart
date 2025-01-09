enum ActionBtnStatus {
  idle,
  listening,
  // Insert other status here if needed
}

ActionBtnStatus cycle(ActionBtnStatus status) {
  final nextIndex = (status.index + 1) % ActionBtnStatus.values.length;
  return ActionBtnStatus.values[nextIndex];
}