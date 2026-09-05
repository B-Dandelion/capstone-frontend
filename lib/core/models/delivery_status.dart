enum DeliveryStatus {
  received,
  loaded,
  buildingEntered,
  movingToFloor,
  nearDoor,
  arrived,
  completed,
  delayed,
  failed,
}

extension DeliveryStatusX on DeliveryStatus {
  String get label {
    switch (this) {
      case DeliveryStatus.received:
        return '접수됨';
      case DeliveryStatus.loaded:
        return '로봇 적재 완료';
      case DeliveryStatus.buildingEntered:
        return '건물 진입';
      case DeliveryStatus.movingToFloor:
        return '층 이동 중';
      case DeliveryStatus.nearDoor:
        return '문 앞 도착 임박';
      case DeliveryStatus.arrived:
        return '문 앞 도착';
      case DeliveryStatus.completed:
        return '배송 완료';
      case DeliveryStatus.delayed:
        return '지연';
      case DeliveryStatus.failed:
        return '실패';
    }
  }
}