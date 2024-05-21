import 'package:flutter/material.dart';
import 'package:kobi_3/menu/citybuspage.dart';
import 'package:kobi_3/menu/shuttlebuspage.dart';

class BusChoosePage extends StatelessWidget {
  const BusChoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버스정보선택'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShuttlebusPage()),
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.orange,
                    minimumSize: Size.fromHeight(double.infinity),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('셔틀버스', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                      Icon(Icons.directions_bus_rounded, size: 24,)
                    ],
                  ))),),
            Flexible(flex: 1,child: Container(color:Colors.white,),),
            Flexible(
              flex: 8,
              child: Container(
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CitybusPage()),
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Color(0xff30619c),
                    minimumSize: Size.fromHeight(double.infinity),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('시내버스', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                      Icon(Icons.directions_bus_rounded, size: 24,)
                    ],
                  ))),),
          ],
        ),
      ),
    );
  }
}