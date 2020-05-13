import 'package:obs_station/types/classes/responses/base.dart';
import 'package:obs_station/types/classes/scene.dart';

class GetSceneListResponse extends BaseResponse {
  GetSceneListResponse(Map<String, dynamic> json) : super(json);

  String get currentScene => this.json['current-scene'];

  Iterable<Scene> get scenes => (this.json['scenes'] as List<dynamic>)
      .map((scene) => Scene.fromJSON(scene));
}