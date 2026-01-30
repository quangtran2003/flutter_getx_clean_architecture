class AdviceEntity {
  final SlipEntity? slip;

  AdviceEntity({
    this.slip,
  });
}

class SlipEntity {
  final int? id;
  final String? advice;

  SlipEntity({
     this.id,
     this.advice,
  });
}
