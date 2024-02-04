import 'package:electricity_token/thera_viewmodel.dart';
import 'package:electricity_token/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TheraDetailPage extends StatefulWidget {
  const TheraDetailPage({
    super.key,
  });

  @override
  State<TheraDetailPage> createState() => _TheraDetailPageState();
}

class _TheraDetailPageState extends State<TheraDetailPage> {
  @override
  Widget build(BuildContext context) {
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments as Map;

    context.read<TheraViewModel>().getDetail(data['trx_code']);
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Transaction Detail')),
      body: Consumer<TheraViewModel>(
        builder: (context, vm, _) {
          if (vm.isDetailLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }

          if (vm.theraDetail == null) {
            return RefreshIndicator(
              color: Colors.red,
              onRefresh: () => vm.getDetail(data['trx_code']),
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
            onRefresh: () => vm.getDetail(data['trx_code']),
            child: ListView(
              children: [
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text("Rp")),
                                SizedBox(width: 2),
                                Text(
                                  moneyFormatter(vm.theraDetail!.totalAmount)
                                      .substring(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(height: 5),
                        keyValue("No. Meter",
                            vm.theraDetail!.meterNumber.toString()),
                        SizedBox(height: 10),
                        keyValue("Unit", vm.theraDetail!.unitNumber.toString()),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: vm.theraDetail!.tokenCode!.isEmpty
                      ? Text(
                          "Token Sedang Diproses. Silahkan cek riwayat transaksi untuk melihat nomor token.",
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Token :",
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 5),
                            Text(
                              vm.tokenCode,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 140,
                              height: 30,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side:
                                          BorderSide(color: Colors.redAccent)),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        new ClipboardData(text: vm.tokenCode));
                                    // showToast('Copied to Clipboard');
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Salin Token",
                                          style: TextStyle(fontSize: 13)),
                                      SizedBox(width: 5),
                                      Icon(Icons.copy, size: 16),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                ),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        keyValue("No. Transaksi", vm.theraDetail!.tokenCode!),
                        Divider(height: 15),
                        keyValue("Waktu",
                            "${DateFormat("d MMM y, HH:mm").format(DateTime.parse(vm.theraDetail!.paymentDate!))}"),
                        Divider(height: 15),
                        keyValue("Jumlah Tagihan",
                            "${moneyFormatter(vm.theraDetail!.amount)}"),
                        Divider(height: 15),
                        keyValue("Convenience fee",
                            "${moneyFormatter(vm.theraDetail!.paymentFee)}"),
                        Divider(height: 15),
                        keyValue("Payment Method",
                            vm.theraDetail!.paymentBank!.toUpperCase()),
                        // CustomDivider(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
