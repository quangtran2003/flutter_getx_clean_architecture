import 'dart:convert';

import 'package:flutter_getx_clean_architecture/features/advice/domain/entity/advice_entity.dart';

class AdviceModel {
  final SlipModel? slip;

  AdviceModel({
    this.slip,
  });

  factory AdviceModel.fromJson(String data) {
    final Map json = jsonDecode(data);
    return AdviceModel(
      slip: SlipModel.fromJson(json["slip"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "slip": slip?.toJson(),
      };

  AdviceEntity toEntity() => AdviceEntity(
        slip: slip?.toEntity() ?? SlipEntity(id: 0, advice: ''),
      );
}

class SlipModel {
  final int? id;
  final String? advice;

  SlipModel({
    this.id,
    this.advice,
  });

  factory SlipModel.fromJson(Map<String, dynamic> json) => SlipModel(
        id: json["id"],
        advice: json["advice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "advice": advice,
      };
  SlipEntity toEntity() => SlipEntity(
        id: id ?? 0,
        advice: advice ?? '',
      );
}
