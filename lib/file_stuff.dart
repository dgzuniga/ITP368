import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:path_provider/path_provider.dart";


void main99() // FS
{ runApp( FileStuff () );
}

class FileStuff extends StatelessWidget
{
  const FileStuff({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "file stuff - barrett",
      home: FileStuffHome(),
    );
  }
}

class FileStuffHome extends StatelessWidget
{
   const FileStuffHome({super.key});

  @override
  Widget build( BuildContext context ) 
  { 
    Future<String> mainDirPath = whereAmI();
    String contents = readFile();
    writeFile();
    return Scaffold
    ( appBar: AppBar( title: const Text("file stuff - barrett") ),
      body: Text(contents),
    );
  }

  Future<String> whereAmI() async
  {
    Directory mainDir = await getApplicationDocumentsDirectory();
    String mainDirPath = mainDir.path;
    print("mainDirPath is $mainDirPath");
    return mainDirPath;
  }
  
  String readFile()
  {
    String myStuff = "C:\\Users\\david\\OneDrive\\Desktop\\ITP368\\GroceryList.txt";
    String filePath = "$myStuff/things.txt";
    File fodder = File(filePath);
    String contents = fodder.readAsStringSync();
    print(contents);
    return contents;
  }
  

  void writeFile()
  { String myStuff = "C:\\Users\\david\\OneDrive\\Desktop\\ITP368\\GroceryList.txt";
    String filePath = "$myStuff/otherStuff.txt";
    File fodder = File(filePath);
    fodder.writeAsStringSync("put this in the file");
  }
}