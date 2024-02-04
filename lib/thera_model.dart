class Unit {
  int? unitId;
  String? unitNumber;

  Unit({this.unitId, this.unitNumber});
}

class Thera {
  String? meterNumber;
  String? unitNumber;
  List<PriceList>? priceList;
  List<TransactionHistory>? transactionHistory;

  Thera(
      {this.meterNumber,
      this.unitNumber,
      this.priceList,
      this.transactionHistory});

  Thera.fromJson(Map<String, dynamic> json) {
    meterNumber = json['meter_number'];
    unitNumber = json['unit_number'];
    if (json['price_list'] != null) {
      priceList = <PriceList>[];
      json['price_list'].forEach((v) {
        priceList!.add(new PriceList.fromJson(v));
      });
    }
    if (json['transaction_history'] != null) {
      transactionHistory = <TransactionHistory>[];
      json['transaction_history'].forEach((v) {
        transactionHistory!.add(new TransactionHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meter_number'] = this.meterNumber;
    data['unit_number'] = this.unitNumber;
    if (this.priceList != null) {
      data['price_list'] = this.priceList!.map((v) => v.toJson()).toList();
    }
    if (this.transactionHistory != null) {
      data['transaction_history'] =
          this.transactionHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceList {
  int? id;
  int? amount;
  double? kwh;

  PriceList({this.id, this.amount, this.kwh});

  PriceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    kwh = json['kwh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['kwh'] = this.kwh;
    return data;
  }
}

class TransactionHistory {
  String? trxCode;
  int? amount;
  int? paymentFee;
  double? kwh;
  String? paymentDate;

  TransactionHistory(
      {this.trxCode, this.amount, this.paymentFee, this.kwh, this.paymentDate});

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    trxCode = json['trx_code'];
    amount = json['amount'];
    paymentFee = json['payment_fee'];
    kwh = json['kwh'];
    paymentDate = json['payment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trx_code'] = this.trxCode;
    data['amount'] = this.amount;
    data['payment_fee'] = this.paymentFee;
    data['kwh'] = this.kwh;
    data['payment_date'] = this.paymentDate;
    return data;
  }
}

class TheraDetail {
  String? meterNumber;
  String? unitNumber;
  String? trxCode;
  int? amount;
  int? paymentFee;
  double? kwh;
  String? paymentDate;
  String? tokenCode;
  String? paymentBank;
  String? paymentMethod;

  TheraDetail({
    this.meterNumber,
    this.unitNumber,
    this.trxCode,
    this.amount,
    this.paymentFee,
    this.kwh,
    this.paymentDate,
    this.tokenCode,
    this.paymentBank,
    this.paymentMethod,
  });

  int get totalAmount => (amount! + paymentFee!);

  TheraDetail.fromJson(Map<String, dynamic> json) {
    meterNumber = json['meter_number'];
    unitNumber = json['unit_number'];
    trxCode = json['trx_code'];
    amount = json['amount'];
    paymentFee = json['payment_fee'];
    kwh = json['kwh'];
    paymentDate = json['payment_date'];
    tokenCode = json['token_code'];
    paymentBank = json['payment_bank'];
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meter_number'] = this.meterNumber;
    data['unit_number'] = this.unitNumber;
    data['trx_code'] = this.trxCode;
    data['amount'] = this.amount;
    data['payment_fee'] = this.paymentFee;
    data['kwh'] = this.kwh;
    data['payment_date'] = this.paymentDate;
    data['token_code'] = this.tokenCode;
    data['payment_method'] = this.paymentMethod;
    data['payment_bank'] = this.paymentBank;
    return data;
  }
}

class SelectedPriceList {
  int index;
  String? meterNumber;
  int? unitId;
  int? amount;

  SelectedPriceList(
      {this.index = 0, this.meterNumber, this.unitId, this.amount});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = this.index;
    data['meter_number'] = this.meterNumber;
    data['unitId'] = this.unitId;
    data['amount'] = this.amount;

    return data;
  }
}
