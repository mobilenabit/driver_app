import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

class CustomLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == "vi";

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final localizations =
        await GlobalMaterialLocalizations.delegate.load(locale);
    return _CustomMaterialLocalizations(localizations);
  }

  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;
}

class _CustomMaterialLocalizations implements MaterialLocalizations {
  final MaterialLocalizations _original;

  _CustomMaterialLocalizations(this._original);

  @override
  String formatMonthYear(dynamic date) {
    // Customize this method to format the date as "Tháng m, yyyy"
    return "Tháng ${date.month}, ${date.year}";
  }

  @override
  String aboutListTileTitle(String applicationName) {
    return _original.aboutListTileTitle(applicationName);
  }

  @override
  String get alertDialogLabel => _original.alertDialogLabel;

  @override
  String get anteMeridiemAbbreviation => _original.anteMeridiemAbbreviation;

  @override
  String get backButtonTooltip => _original.backButtonTooltip;

  @override
  String get bottomSheetLabel => _original.bottomSheetLabel;

  @override
  String get calendarModeButtonLabel => _original.calendarModeButtonLabel;

  @override
  String get cancelButtonLabel => _original.cancelButtonLabel;

  @override
  String get closeButtonLabel => _original.closeButtonLabel;

  @override
  String get closeButtonTooltip => _original.closeButtonTooltip;

  @override
  String get collapsedHint => _original.collapsedHint;

  @override
  String get collapsedIconTapHint => _original.collapsedIconTapHint;

  @override
  String get continueButtonLabel => _original.continueButtonLabel;

  @override
  String get copyButtonLabel => _original.copyButtonLabel;

  @override
  String get currentDateLabel => _original.currentDateLabel;

  @override
  String get cutButtonLabel => _original.cutButtonLabel;

  @override
  String get dateHelpText => _original.dateHelpText;

  @override
  String get dateInputLabel => _original.dateInputLabel;

  @override
  String get dateOutOfRangeLabel => _original.dateOutOfRangeLabel;

  @override
  String get datePickerHelpText => _original.datePickerHelpText;

  @override
  String dateRangeEndDateSemanticLabel(String formattedDate) {
    return _original.dateRangeEndDateSemanticLabel(formattedDate);
  }

  @override
  String get dateRangeEndLabel => _original.dateRangeEndLabel;

  @override
  String get dateRangePickerHelpText => _original.dateRangePickerHelpText;

  @override
  String dateRangeStartDateSemanticLabel(String formattedDate) {
    return _original.dateRangeStartDateSemanticLabel(formattedDate);
  }

  @override
  String get dateRangeStartLabel => _original.dateRangeStartLabel;

  @override
  String get dateSeparator => _original.dateSeparator;

  @override
  String get deleteButtonTooltip => _original.deleteButtonTooltip;

  @override
  String get dialModeButtonLabel => _original.dialModeButtonLabel;

  @override
  String get dialogLabel => _original.dialogLabel;

  @override
  String get drawerLabel => _original.drawerLabel;

  @override
  String get expandedHint => _original.expandedHint;

  @override
  String get expandedIconTapHint => _original.expandedIconTapHint;

  @override
  String get expansionTileCollapsedHint => _original.expansionTileCollapsedHint;

  @override
  String get expansionTileCollapsedTapHint =>
      _original.expansionTileCollapsedTapHint;

  @override
  String get expansionTileExpandedHint => _original.expansionTileExpandedHint;

  @override
  String get expansionTileExpandedTapHint =>
      _original.expansionTileExpandedTapHint;

  @override
  int get firstDayOfWeekIndex => _original.firstDayOfWeekIndex;

  @override
  String get firstPageTooltip => _original.firstPageTooltip;

  @override
  String formatCompactDate(DateTime date) {
    return _original.formatCompactDate(date);
  }

  @override
  String formatDecimal(int number) {
    return _original.formatDecimal(number);
  }

  @override
  String formatFullDate(DateTime date) {
    return _original.formatFullDate(date);
  }

  @override
  String formatHour(TimeOfDay timeOfDay, {bool alwaysUse24HourFormat = false}) {
    return _original.formatHour(timeOfDay,
        alwaysUse24HourFormat: alwaysUse24HourFormat);
  }

  @override
  String formatMediumDate(DateTime date) {
    return _original.formatMediumDate(date);
  }

  @override
  String formatMinute(TimeOfDay timeOfDay) {
    return _original.formatMinute(timeOfDay);
  }

  @override
  String formatShortDate(DateTime date) {
    return _original.formatShortDate(date);
  }

  @override
  String formatShortMonthDay(DateTime date) {
    return _original.formatShortMonthDay(date);
  }

  @override
  String formatTimeOfDay(TimeOfDay timeOfDay,
      {bool alwaysUse24HourFormat = false}) {
    return _original.formatTimeOfDay(timeOfDay,
        alwaysUse24HourFormat: alwaysUse24HourFormat);
  }

  @override
  String formatYear(DateTime date) {
    return _original.formatYear(date);
  }

  @override
  String get hideAccountsLabel => _original.hideAccountsLabel;

  @override
  String get inputDateModeButtonLabel => _original.inputDateModeButtonLabel;

  @override
  String get inputTimeModeButtonLabel => _original.inputTimeModeButtonLabel;

  @override
  String get invalidDateFormatLabel => _original.invalidDateFormatLabel;

  @override
  String get invalidDateRangeLabel => _original.invalidDateRangeLabel;

  @override
  String get invalidTimeLabel => _original.invalidTimeLabel;

  @override
  String get keyboardKeyAlt => _original.keyboardKeyAlt;

  @override
  String get keyboardKeyAltGraph => _original.keyboardKeyAltGraph;

  @override
  String get keyboardKeyBackspace => _original.keyboardKeyBackspace;

  @override
  String get keyboardKeyCapsLock => _original.keyboardKeyCapsLock;

  @override
  String get keyboardKeyChannelDown => _original.keyboardKeyChannelDown;

  @override
  String get keyboardKeyChannelUp => _original.keyboardKeyChannelUp;

  @override
  String get keyboardKeyControl => _original.keyboardKeyControl;

  @override
  String get keyboardKeyDelete => _original.keyboardKeyDelete;

  @override
  String get keyboardKeyEject => _original.keyboardKeyEject;

  @override
  String get keyboardKeyEnd => _original.keyboardKeyEnd;

  @override
  String get keyboardKeyEscape => _original.keyboardKeyEscape;

  @override
  String get keyboardKeyFn => _original.keyboardKeyFn;

  @override
  String get keyboardKeyHome => _original.keyboardKeyHome;

  @override
  String get keyboardKeyInsert => _original.keyboardKeyInsert;

  @override
  String get keyboardKeyMeta => _original.keyboardKeyMeta;

  @override
  String get keyboardKeyMetaMacOs => _original.keyboardKeyMetaMacOs;

  @override
  String get keyboardKeyMetaWindows => _original.keyboardKeyMetaWindows;

  @override
  String get keyboardKeyNumLock => _original.keyboardKeyNumLock;

  @override
  String get keyboardKeyNumpad0 => _original.keyboardKeyNumpad0;

  @override
  String get keyboardKeyNumpad1 => _original.keyboardKeyNumpad1;

  @override
  String get keyboardKeyNumpad2 => _original.keyboardKeyNumpad2;

  @override
  String get keyboardKeyNumpad3 => _original.keyboardKeyNumpad3;

  @override
  String get keyboardKeyNumpad4 => _original.keyboardKeyNumpad4;

  @override
  String get keyboardKeyNumpad5 => _original.keyboardKeyNumpad5;

  @override
  String get keyboardKeyNumpad6 => _original.keyboardKeyNumpad6;

  @override
  String get keyboardKeyNumpad7 => _original.keyboardKeyNumpad7;

  @override
  String get keyboardKeyNumpad8 => _original.keyboardKeyNumpad8;

  @override
  String get keyboardKeyNumpad9 => _original.keyboardKeyNumpad9;

  @override
  String get keyboardKeyNumpadAdd => _original.keyboardKeyNumpadAdd;

  @override
  String get keyboardKeyNumpadComma => _original.keyboardKeyNumpadComma;

  @override
  String get keyboardKeyNumpadDecimal => _original.keyboardKeyNumpadDecimal;

  @override
  String get keyboardKeyNumpadDivide => _original.keyboardKeyNumpadDivide;

  @override
  String get keyboardKeyNumpadEnter => _original.keyboardKeyNumpadEnter;

  @override
  String get keyboardKeyNumpadEqual => _original.keyboardKeyNumpadEqual;

  @override
  String get keyboardKeyNumpadMultiply => _original.keyboardKeyNumpadMultiply;

  @override
  String get keyboardKeyNumpadParenLeft => _original.keyboardKeyNumpadParenLeft;

  @override
  String get keyboardKeyNumpadParenRight =>
      _original.keyboardKeyNumpadParenRight;

  @override
  String get keyboardKeyNumpadSubtract => _original.keyboardKeyNumpadSubtract;

  @override
  String get keyboardKeyPageDown => _original.keyboardKeyPageDown;

  @override
  String get keyboardKeyPageUp => _original.keyboardKeyPageUp;

  @override
  String get keyboardKeyPower => _original.keyboardKeyPower;

  @override
  String get keyboardKeyPowerOff => _original.keyboardKeyPowerOff;

  @override
  String get keyboardKeyPrintScreen => _original.keyboardKeyPrintScreen;

  @override
  String get keyboardKeyScrollLock => _original.keyboardKeyScrollLock;

  @override
  String get keyboardKeySelect => _original.keyboardKeySelect;

  @override
  String get keyboardKeyShift => _original.keyboardKeyShift;

  @override
  String get keyboardKeySpace => _original.keyboardKeySpace;

  @override
  String get lastPageTooltip => _original.lastPageTooltip;

  @override
  String licensesPackageDetailText(int licenseCount) {
    return _original.licensesPackageDetailText(licenseCount);
  }

  @override
  String get licensesPageTitle => _original.licensesPageTitle;

  @override
  String get lookUpButtonLabel => _original.lookUpButtonLabel;

  @override
  String get menuBarMenuLabel => _original.menuBarMenuLabel;

  @override
  String get menuDismissLabel => _original.menuDismissLabel;

  @override
  String get modalBarrierDismissLabel => _original.modalBarrierDismissLabel;

  @override
  String get moreButtonTooltip => _original.moreButtonTooltip;

  @override
  List<String> get narrowWeekdays => _original.narrowWeekdays;

  @override
  String get nextMonthTooltip => _original.nextMonthTooltip;

  @override
  String get nextPageTooltip => _original.nextPageTooltip;

  @override
  String get okButtonLabel => _original.okButtonLabel;

  @override
  String get openAppDrawerTooltip => _original.openAppDrawerTooltip;

  @override
  String pageRowsInfoTitle(
      int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return _original.pageRowsInfoTitle(
        firstRow, lastRow, rowCount, rowCountIsApproximate);
  }

  @override
  DateTime? parseCompactDate(String? inputString) {
    return _original.parseCompactDate(inputString);
  }

  @override
  String get pasteButtonLabel => _original.pasteButtonLabel;

  @override
  String get popupMenuLabel => _original.popupMenuLabel;

  @override
  String get postMeridiemAbbreviation => _original.postMeridiemAbbreviation;

  @override
  String get previousMonthTooltip => _original.previousMonthTooltip;

  @override
  String get previousPageTooltip => _original.previousPageTooltip;

  @override
  String get refreshIndicatorSemanticLabel =>
      _original.refreshIndicatorSemanticLabel;

  @override
  String remainingTextFieldCharacterCount(int remaining) {
    return _original.remainingTextFieldCharacterCount(remaining);
  }

  @override
  String get reorderItemDown => _original.reorderItemDown;

  @override
  String get reorderItemLeft => _original.reorderItemLeft;

  @override
  String get reorderItemRight => _original.reorderItemRight;

  @override
  String get reorderItemToEnd => _original.reorderItemToEnd;

  @override
  String get reorderItemToStart => _original.reorderItemToStart;

  @override
  String get reorderItemUp => _original.reorderItemUp;

  @override
  String get rowsPerPageTitle => _original.rowsPerPageTitle;

  @override
  String get saveButtonLabel => _original.saveButtonLabel;

  @override
  String get scanTextButtonLabel => _original.scanTextButtonLabel;

  @override
  String get scrimLabel => _original.scrimLabel;

  @override
  String scrimOnTapHint(String modalRouteContentName) {
    return _original.scrimOnTapHint(modalRouteContentName);
  }

  @override
  ScriptCategory get scriptCategory => _original.scriptCategory;

  @override
  String get searchFieldLabel => _original.searchFieldLabel;

  @override
  String get searchWebButtonLabel => _original.searchWebButtonLabel;

  @override
  String get selectAllButtonLabel => _original.selectAllButtonLabel;

  @override
  String get selectYearSemanticsLabel => _original.selectYearSemanticsLabel;

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    return _original.selectedRowCountTitle(selectedRowCount);
  }

  @override
  String get shareButtonLabel => _original.shareButtonLabel;

  @override
  String get showAccountsLabel => _original.showAccountsLabel;

  @override
  String get showMenuTooltip => _original.showMenuTooltip;

  @override
  String get signedInLabel => _original.signedInLabel;

  @override
  String tabLabel({required int tabIndex, required int tabCount}) {
    return _original.tabLabel(tabIndex: tabIndex, tabCount: tabCount);
  }

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) {
    return _original.timeOfDayFormat(
        alwaysUse24HourFormat: alwaysUse24HourFormat);
  }

  @override
  String get timePickerDialHelpText => _original.timePickerDialHelpText;

  @override
  String get timePickerHourLabel => _original.timePickerHourLabel;

  @override
  String get timePickerHourModeAnnouncement =>
      _original.timePickerHourModeAnnouncement;

  @override
  String get timePickerInputHelpText => _original.timePickerInputHelpText;

  @override
  String get timePickerMinuteLabel => _original.timePickerMinuteLabel;

  @override
  String get timePickerMinuteModeAnnouncement =>
      _original.timePickerHourModeAnnouncement;

  @override
  String get unspecifiedDate => _original.unspecifiedDate;

  @override
  String get unspecifiedDateRange => _original.unspecifiedDateRange;

  @override
  String get viewLicensesButtonLabel => _original.viewLicensesButtonLabel;

  @override
  // TODO: implement clearButtonTooltip
  String get clearButtonTooltip => _original.clearButtonTooltip;

  @override
  // TODO: implement selectedDateLabel
  String get selectedDateLabel => _original.selectedDateLabel;
}
