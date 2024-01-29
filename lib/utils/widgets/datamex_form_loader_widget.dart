import 'package:flutter/material.dart';

class DatamexLoaderWidget extends StatelessWidget {
  const DatamexLoaderWidget({required this.loadingStatusMessage, super.key});
  final String loadingStatusMessage;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15)),
        height: MediaQuery.of(context).size.height * .9,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.blue.shade500,
                backgroundColor: Colors.blue.shade700,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                loadingStatusMessage,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              )
            ],
          ),
        ));
  }
}
