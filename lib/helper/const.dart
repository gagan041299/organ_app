import 'package:orgone_app/Models/dropdown_model.dart';
import 'package:orgone_app/Models/user_model.dart';

const String baseUrl = 'https://api.orgone.solutions/orgon_api/api/';

const String loginUrl = baseUrl + 'login';
const String userDetailsUrl = baseUrl + 'user-details';
const String dashboardUrl = baseUrl + 'dashboard';
const String dropdownUrl = baseUrl + 'dropdowns';
const String rescheduleUrl = baseUrl + 'reschedule';
const String mistechUrl = baseUrl + 'mistech';
const String ndmaUrl = baseUrl + 'ndma';
const String caseStautsFormUrl = baseUrl + 'case-status-upload';
const String mmSheetUrl = baseUrl + 'mmsheet';
const String boundriesUrl = baseUrl + 'boundarie-dimension';
const String logoutUrl = baseUrl + 'logout';
const String multipleImageUploadUrl = baseUrl + 'multiple-image-upload';
const String singleImageUploadUrl = baseUrl + 'single-image-upload';
const String physicalInspectionOneUrl = baseUrl + 'physicalinspection1';
const String physicalInspectionTwoUrl = baseUrl + 'physicalinspection2';
const String caseDetailUrl = baseUrl + 'case-edit';
const String historyUrl = baseUrl + 'submitted-cases';
const String caseStatusParamUrl = baseUrl + 'case-status-parameter';
const String appContentUrl = baseUrl + 'appContent';
const String updatePassUrl = baseUrl + 'password-update';
const String attendaceUrl = baseUrl + 'check-in-out';
const String caseCountUrl = baseUrl + 'get-case-count';
const String reimburstmentUrl = baseUrl + 'rebasement-add';
const String reimburstmentListUrl = baseUrl + 'rebasement-list';
const String reimburstmentEditUrl = baseUrl + 'rebasement-edit';
const String reimburstmentFinalSubmitUrl = baseUrl + 'rebasement-final-submit';

const String reimburstmentDeleteUrl = baseUrl + 'rebasement-single-delete';

String? constToken, constUserName, constUserMobile;
UserModel? constUserModel;
DropdownModel? constDropdownList;
double constperKmPrice = 0;
bool constShowLogin = true;
