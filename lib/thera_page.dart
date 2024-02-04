import 'package:electricity_token/thera_model.dart';
import 'package:electricity_token/thera_viewmodel.dart';
import 'package:electricity_token/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TheraPage extends StatefulWidget {
  const TheraPage({super.key});

  @override
  State<TheraPage> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TheraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Token Listrik')),
      body: Consumer<TheraViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }

          if (vm.thera == null) {
            return RefreshIndicator(
              color: Colors.red,
              onRefresh: () => vm.getElectricityTokens(),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate:
                          SliverChildListDelegate([Text("${vm.errMsg}")])),
                ],
              ),
            );
          }
          return RefreshIndicator(
            color: Colors.red,
            onRefresh: () => vm.getElectricityTokens(),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      keyValue("No. Meter", vm.thera!.meterNumber.toString()),
                      SizedBox(height: 4),
                      keyValue("Unit", vm.thera!.unitNumber.toString()),
                    ],
                  ),
                ),
                Divider(
                  indent: 16,
                  endIndent: 16,
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Pilih Nominal Token', style: TextStyle()),
                      SizedBox(height: 15),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.1,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: vm.thera!.priceList!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => vm.setselectedNominal(
                                index, vm.thera!.priceList![index].amount!),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: vm.selected.index == index
                                    ? Colors.red.withOpacity(0.1)
                                    : null,
                                border: Border.all(
                                    color: vm.selected.index == index
                                        ? Colors.red
                                        : Colors.grey),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    moneyFormatter(
                                        vm.thera!.priceList![index].amount),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "${vm.thera!.priceList![index].kwh} kWh",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // TheraInfo(),
                      SizedBox(height: 16),

                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          color: const Color(0xfffff4dc),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.info_outline,
                                    color: Colors.yellow[700]),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      createRichText(1, [
                                        TextSpan(
                                            text:
                                                "Proses verifikasi transaksi"),
                                        TextSpan(
                                            text: " maksimal 1 × 24 jam.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ]),
                                      SizedBox(height: 8),
                                      createRichText(2, [
                                        TextSpan(text: "Mohon"),
                                        TextSpan(
                                            text: " cek limit kWh",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                " anda sebelum membeli token listrik.")
                                      ])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),

                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, primary: Colors.red[500]),
                        onPressed: vm.isPaymentProcessing
                            ? null
                            : () async => await vm.payment(context),
                        child: Text(
                          vm.isPaymentProcessing
                              ? "Proses ... "
                              : "Pilih Pembayaran",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(
                      "Transaction History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Divider(indent: 16, endIndent: 16, height: 16),
                TheraHistory(histories: vm.thera!.transactionHistory!),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TheraHistory extends StatefulWidget {
  final List<TransactionHistory>? histories;

  const TheraHistory({super.key, required this.histories});

  @override
  State<TheraHistory> createState() => _TheraHistoryState();
}

class _TheraHistoryState extends State<TheraHistory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.histories?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/detail", arguments: {
                    "trx_code": widget.histories?[index].trxCode
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: Icon(Icons.bolt),
                        foregroundColor: Colors.yellow,
                        radius: 30,
                        backgroundColor: Colors.redAccent[100],
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: <Widget>[
                          Text(
                              "Nominal ${moneyFormatter(widget.histories?[index].amount)}"),
                          Text(
                            formatDate(
                                widget.histories![index].paymentDate ?? ""),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              moneyFormatter(
                                  widget.histories?[index].paymentFee),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

RichText createRichText(int num, List<TextSpan> textSpans) {
  return RichText(
      text: TextSpan(
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
          children: [
                TextSpan(
                  text: '$num. ',
                ),
              ] +
              textSpans));
}
