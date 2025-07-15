import 'package:flutter/material.dart';

class Imageview extends StatelessWidget {
  final String url;
  const Imageview({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                padding: const EdgeInsets.only(left: 8),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios,),
            ),
          ],
        ),

      ),
      body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Hero(
              tag: url,
              child: Image.network(
                url,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.file_download_off_outlined,
                    color: Colors.red.shade900,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!
                              : null
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ),
    );
  }
}
