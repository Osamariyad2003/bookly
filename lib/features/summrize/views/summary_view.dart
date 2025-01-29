import 'dart:io';
import 'package:bookly/core/aseets_data.dart';
import 'package:bookly/core/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/colors_app.dart';
import '../../../core/text_style.dart';

import '../controller/summary_cubit.dart';
import '../controller/summary_state.dart';
import 'download.dart';

class SummaryView extends StatelessWidget {
    SummaryView({Key?key});
    TextEditingController fontSizecontroller =TextEditingController();
    TextEditingController TitleController =TextEditingController();

    void pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      BlocProvider.of<SummaryCubit>(context).pickFile(result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SummaryCubit, SummaryState>(
      listener: (BuildContext context, state) {
        if (state is SummarySuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DownloadSummaryPage(Title: TitleController.text,FontSize: fontSizecontroller.value,)),
          );
        } else if (state is SummaryError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: ColorStyles.buttonColor,
                content: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    state.errorMessage,
                    style: TextStyle(color: ColorStyles.backgroundColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          );
        }
      },
      builder: (BuildContext context, state) {
        final cubit = context.read<SummaryCubit>();
        return Scaffold(
          backgroundColor: ColorStyles.backgroundColor,
          appBar: DefaultAppBar(context),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => pickFile(context),
                  child: Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      color: ColorStyles.backgroundColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorStyles.buttonColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Icon(
                            Icons.file_copy_outlined,
                            color: ColorStyles.buttonColor,
                            size: 40,
                          ),
                          Text(
                            cubit.filePath == null
                                ? 'Click here or drag file to upload'
                                : 'File Selected Successfully: ${File(cubit.filePath!).uri.pathSegments.last}',
                            style: TextStyle(
                              color: ColorStyles.textFieldBorderColor,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: cubit.summaryRange,
                  onChanged: (value) {
                    if (value != null) {
                      cubit.updateRange(value);
                    }
                  },
                  items: ['Full', 'Partial', 'Custom'].map((range) {
                    return DropdownMenuItem(
                      value: range,
                      child: Text(range),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    cubit.updateTheme(value);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Theme of summary',
                  ),
                ),
                SizedBox(height: 30),
                myFormField(hint: 'FontSize', type: TextInputType.number, maxLines: 1,controller: fontSizecontroller),
                SizedBox(height: 20,),
                myFormField(hint: 'Tile of Summrized pdf', type: TextInputType.text, maxLines: 2,controller: TitleController),

                SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: () {
                    try {
                      cubit.summarize();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Summarization started!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Center(child: Text('Summrize',style: TextStyles.buttonTextStyle,))),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    backgroundColor: ColorStyles.buttonColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
