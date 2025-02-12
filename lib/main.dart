import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:freight_weight/exampleapi_fetch.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'expandable_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search the best Freight Rates'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: TextButton.icon(
                onPressed: () {},
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'History',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 14, 1, 255)),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromRGBO(230, 235, 255, 1)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        width: 1.0,
                        color: Color.fromARGB(255, 14, 1, 255),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: Color.fromRGBO(250, 252, 255, 1), // Customize color
          elevation: 1,
        ),
        backgroundColor: Color.fromRGBO(230, 234, 248, 1),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(32),
            child: FreightForm(),
          ),
        ),
      ),
    );
  }
}

class FreightForm extends StatefulWidget {
  const FreightForm({super.key});

  @override
  _FreightFormState createState() => _FreightFormState();
}

class _FreightFormState extends State<FreightForm> {
  String? origin;
  String? destination;
  String? commodity;
  final List<String> commodities = [
    'com1',
    'com2',
    'com3',
    'com4',
    'com5',
  ]; // List of items
  String? shipmentType = 'FCL';
  String? containerSize = '40\' Standard';
  int noOfBoxes = 0;
  double weight = 0.0;
  bool includeNearbyOriginPorts = false;
  bool includeNearbyDestinationPorts = false;

  // Initialize the TextEditingController for the 'Cut Off Date', origin and destination fields
  final TextEditingController _dateController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the widget tree
    _dateController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2000), // Set the start date
      lastDate: DateTime(2101), // Set the end date
    );
    if (picked != null) {
      setState(() {
        // Format the selected date and update the TextField
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //main root origin of the form fields
        children: [
          Row(
            //section for the input fields
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                //for equal size distribution
                child: Column(
                  //for textfield origin and it's checkbox
                  children: [
                    TextField(
                      //child1 inputfield
                      controller: _originController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: 1,
                          height: 1,
                          child: SvgPicture.asset(
                            'assets/images/location.svg',
                            height: 1,
                            width: 1,
                            fit: BoxFit.none,
                          ),
                        ),
                        hintText: 'Origin',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    AutoCompleteWidget(
                      query: _originController.text,
                      onSelected: (value) {
                        setState(() {
                          _originController.text = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      //child2 checkbox
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          value: includeNearbyOriginPorts,
                          activeColor: Color.fromRGBO(21, 94, 239, 1),
                          checkColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              includeNearbyOriginPorts = value!;
                            });
                          },
                        ),
                        Text('Include nearby origin ports'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                //for equal size distribution
                child: Column(
                  //for textfield destination and it's checkbox
                  children: [
                    TextField(
                      controller: _destinationController,
                      onChanged: (_) => setState(() {}),
                      //child1 text input field
                      decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: 1,
                          height: 1,
                          child: SvgPicture.asset(
                            'assets/images/location.svg',
                            height: 1,
                            width: 1,
                            fit: BoxFit.none,
                          ),
                        ),
                        hintText: 'Destination',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    AutoCompleteWidget(
                      query: _destinationController.text,
                      onSelected: (value) {
                        setState(() {
                          _destinationController.text = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      //child2 checkbox
                      children: [
                        Checkbox(
                          value: includeNearbyDestinationPorts,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          activeColor: Color.fromRGBO(21, 94, 239, 1),
                          checkColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              includeNearbyDestinationPorts = value!;
                            });
                          },
                        ),
                        Text('Include nearby destination ports'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            //for commodity and cut off date
            children: [
              //child1 dropdownbutton
              Expanded(
                //for equal size distribution of commodity drop down
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 231, 231, 231),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Commodity',
                  ),
                  items: commodities
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please Select a commodity.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //will populate it later
                  },
                  onSaved: (value) {
                    commodity = value.toString();
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 25,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  //child1 inputfield
                  decoration: InputDecoration(
                    suffixIcon: SizedBox(
                      width: 1,
                      height: 1,
                      child: SvgPicture.asset(
                        'assets/images/calendar-2.svg',
                        height: 1,
                        width: 1,
                        fit: BoxFit.none,
                      ),
                    ),
                    hintText: 'Cut Off Date',
                    hintStyle: TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 231, 231, 231),
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Column(
            //shipment type tick boxes
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shipment Type :',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: shipmentType == 'FCL',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        activeColor: Color.fromRGBO(21, 94, 239, 1),
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          setState(() {
                            shipmentType = value! ? 'FCL' : 'LCL';
                          });
                        },
                      ),
                      Text(
                        'FCL',
                      ),
                    ],
                    //next check box
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Checkbox(
                    value: shipmentType == 'LCL',
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    activeColor: Color.fromRGBO(21, 94, 239, 1),
                    checkColor: Colors.white,
                    onChanged: (bool? value) {
                      setState(() {
                        shipmentType = value! ? 'LCL' : 'FCL';
                      });
                    },
                  ),
                  Text('LCL'),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Column(
            //for container size, no; of boxes, weight and the text
            children: [
              Row(
                // for container size, no; of boxes, weight
                children: [
                  ExpandableListScreen(),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      //child1 inputfield
                      decoration: InputDecoration(
                        hintText: 'No of Boxes',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      //child1 inputfield
                      decoration: InputDecoration(
                        hintText: 'Weight (Kg)',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(100, 0, 0, 0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                //for the warning text
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outlined,
                        size: 20.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              //for the container dimensions
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Container Internal Dimensions :',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  //for length width height and the container image
                  children: [
                    Column(
                      //for the length width height with equal text start
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Length'),
                            SizedBox(width: 15.0),
                            Text(
                              '39.46 ft',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            Text(
                              'Width',
                              textAlign: TextAlign.end,
                            ),
                            SizedBox(width: 24.0),
                            Text(
                              '7.70 ft',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            Text('Height'),
                            SizedBox(width: 20.0),
                            Text(
                              '7.84 ft',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                    SizedBox(width: 50.0),
                    Container(
                      //container image
                      child: Image.asset(
                        width: 200.0,
                        'assets/images/container.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Image.asset(
                  'assets/images/search-normal.png',
                  height: 30.0,
                ),
              ),
              onPressed: () {},
              label: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Text(
                  'Search',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 14, 1, 255)),
                ),
              ),
              style: ButtonStyle(
                //for the button styling
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromRGBO(230, 235, 255, 1)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 14, 1, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
