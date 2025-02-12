import 'package:flutter/material.dart';

class ExpandableListScreen extends StatefulWidget {
  const ExpandableListScreen({super.key});

  @override
  ExpandableListScreenState createState() => ExpandableListScreenState();
}

class ExpandableListScreenState extends State<ExpandableListScreen> {
  String selectedOption = "Select an Option";
  final ExpansionTileController _controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(7), // Rounded corners
          border:
              Border.all(color: Colors.grey.shade300, width: 1), // Border color
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              selectedOption,
              /* style: TextStyle(color: Color.fromARGB(100, 0, 0, 0)) */
            ),
            controller: _controller,
            children: [
              ListTile(
                //option 1
                title: const Text("20' Standard"),
                onTap: () {
                  setState(() {
                    selectedOption = "20' Standard";
                  });
                  _controller.collapse();
                },
              ),
              ListTile(
                //option 2
                title: const Text("40' Standard"),
                onTap: () {
                  setState(() {
                    selectedOption = "40' Standard";
                  });
                  _controller.collapse();
                },
              ),
              ListTile(
                //option 3
                title: const Text("40' High Cube"),
                onTap: () {
                  setState(() {
                    selectedOption = "40' High Cube";
                  });
                  _controller.collapse();
                },
              ),
              ListTile(
                //option 4
                title: const Text("40' Open Top"),
                onTap: () {
                  setState(() {
                    selectedOption = "40' Open Top";
                  });
                  _controller.collapse();
                },
              ),
              ListTile(
                //option 5
                title: const Text("40' Reefer"),
                onTap: () {
                  setState(() {
                    selectedOption = "40' Reefer";
                  });
                  _controller.collapse();
                },
              ),
              ListTile(
                //option 6
                title: const Text("40' Standard"),
                onTap: () {
                  setState(() {
                    selectedOption = "40' Standard";
                  });
                  _controller.collapse();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
