import 'package:electricity_token/api_error.dart';
import 'package:electricity_token/thera_model.dart';
import 'package:electricity_token/thera_repository.dart';
import 'package:flutter/material.dart';

class TheraViewModel extends ChangeNotifier {
  TheraViewModel() {
    getElectricityTokens();
  }

  String? errMsg;
  Thera? thera;
  TheraDetail? theraDetail;
  bool usePeymentForThera = false;
  bool isLoading = false;
  bool isDetailLoading = false;
  bool isPaymentProcessing = false;

  late SelectedPriceList selected;

  // String get tokenCode => theraDetail!.tokenCode!.isEmpty ? "" : theraTokenFormatter(theraDetail!.tokenCode!);
  String get tokenCode =>
      theraDetail!.tokenCode!.isEmpty ? "" : theraDetail!.tokenCode!;

  void setselectedNominal(int index, int amount) {
    selected.index = index;
    selected.amount = amount;
    notifyListeners();
  }

  Future<void> getElectricityTokens() async {
    isLoading = true;
    thera = null;
    errMsg = null;
    // final unit = await PreferenceHelper.getUnit();
    final unit =
        Unit(unitId: 1, unitNumber: "111"); // Simulate unit in sharedPreference
    final response =
        await TheraRepository().getElectricityTokens(unitId: unit!.unitId!);

    if (response is Thera) {
      thera = response;

      selected = SelectedPriceList(
        index: 0,
        meterNumber: thera!.meterNumber,
        unitId: unit.unitId,
        amount: thera!.priceList!.first.amount,
      );
      notifyListeners();
    } else if (response is ApiError) {
      errMsg = response.errMsg;
      thera = null;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> payment(BuildContext context) async {
    // Get Trx Code;
    isPaymentProcessing = true;
    notifyListeners();

    final isOutstanding = await TheraRepository().checkOutstanding();

    if (isOutstanding) {
      showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          height: 270,
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 6,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
                // child: Image.asset(ImageAssets.logo_full_color)
              ),
              SizedBox(height: 20),
              Text(
                "Kamu Punya Tagihan Yang Belum Dibayar",
                style: TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                "Yuk bayar dahulu tagihan kamu untuk dapat mengakses fitur ini.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/billing");
                },
                child: Text('Bayar Sekarang'),
              )
              // PrimaryButton(
              //   text: 'Bayar Sekarang',
              //   callback: () {
              //     Navigate.to(context, BillingPage());
              //   },
              // )
            ],
          ),
        ),
      );

      isPaymentProcessing = false;
      notifyListeners();
      return;
    }

    final trxCode = await TheraRepository().createTrx(
        meterNumber: selected.meterNumber!,
        unitId: selected.unitId!,
        amount: selected.amount!);

    isPaymentProcessing = false;
    notifyListeners();

    if (trxCode is String) {
      usePeymentForThera = true;
      Navigator.pushNamed(context, '/payment_method', arguments: {
        "trx_code": trxCode,
        "selected_price": selected.amount,
      });
    }
  }

  Future<void> getDetail(String trxCode) async {
    print("getDetail trxCode: $trxCode");
    isDetailLoading = true;
    theraDetail = null;
    final response = await TheraRepository().getDetail(trx_code: trxCode);

    if (response is TheraDetail) {
      theraDetail = response;
    } else if (response is ApiError) {
      errMsg = response.errMsg;
      thera = null;
    }
    isDetailLoading = false;
    notifyListeners();
  }
}
