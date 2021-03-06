import 'package:obs_blade/types/classes/stream/responses/base.dart';

class GetCurrentSceneCollectionResponse extends BaseResponse {
  GetCurrentSceneCollectionResponse(Map<String, dynamic> json) : super(json);

  /// Name of the currently active scene collection
  String get scName => this.json['sc-name'];
}
