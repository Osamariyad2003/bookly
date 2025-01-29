import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/text_style.dart';
import '../controller/summary_cubit.dart';
import '../controller/summary_state.dart';



class DownloadSummaryPage extends StatelessWidget {

  var FontSize;
  String? Title;
  DownloadSummaryPage({required this.FontSize,required this.Title});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SummaryCubit>();

    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        title: DefaultAppBar(context),
        backgroundColor: ColorStyles.buttonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Title??"",style: TextStyles.headerStyle,),
            // Display the summary
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  cubit.summaryResult.isNotEmpty
                      ? cubit.summaryResult
                      : "No summary available.",
                  style: TextStyle(fontSize: FontSize??0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Download button
            BlocBuilder<SummaryCubit, SummaryState>(
              builder: (context, state) {
                if (state is SummaryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SummaryDownload) {
                  return Text(
                    "Summary downloaded to: Start Doenloading ",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  );
                } else if (state is SummaryError) {
                  return Text(
                    state.errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      cubit.downloadSummary();
                    },
                    child: Text("Download Summary"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 64.0),
                      backgroundColor: ColorStyles.buttonColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
