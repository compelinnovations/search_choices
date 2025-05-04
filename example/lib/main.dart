import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutster/flutster.dart';

import 'package:search_choices/search_choices.dart';
import 'package:search_choices_example/custom_object_sample.dart';

class ExampleNumber {
  int number;

  static final Map<int, String> map = {
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
  };

  String get numberString {
    return ((map.containsKey(number) ? map[number] : "unknown") ?? "unknown");
  }

  ExampleNumber(this.number);

  @override
  String toString() {
    return ("$number $numberString");
  }

  static List<ExampleNumber> get list {
    return (map.keys.map((exampleNumber) {
      return (ExampleNumber(exampleNumber));
    })).toList();
  }
}

void main({bool testing = false}) {
  const flutsterKey = String.fromEnvironment("flutsterKey");
  const flutsterUser = String.fromEnvironment("flutsterUser");
  const flutsterUrl = String.fromEnvironment("flutsterUrl");
  FlutsterTestRecord.defaultRecord.apiUrl = flutsterUrl;
  FlutsterTestRecord.defaultRecord.apiUser = flutsterUser;
  FlutsterTestRecord.defaultRecord.apiKey = flutsterKey;
  FlutsterTestRecord.defaultRecord.active = testing;
  if (testing) {
    SearchChoices.dialogBoxMenuWrapper = (Widget menuWidget) {
      return (FlutsterTestRecorder(
        name: "wrappedMenuWidget",
        child: menuWidget,
      ));
    };
  }

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final navKey = GlobalKey<NavigatorState>();

  const MyApp({Key? navKey}) : super(key: navKey);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool asTabs = false;
  String? selectedValueSingleDialog;
  String? selectedValueSingleDoneButtonDialog;
  String? selectedValueSingleMenu;
  String? selectedValueSingleDialogCustomKeyboard;
  String? selectedValueSingleDialogOverflow;
  String? selectedValueSingleDialogEditableItems;
  String? selectedValueSingleMenuEditableItems;
  String? selectedValueSingleDialogDarkMode;
  String? selectedValueSingleDialogEllipsis;
  String? selectedValueSingleDialogRightToLeft;
  String? selectedValueUpdateFromOutsideThePlugin;
  dynamic selectedValueSingleDialogPaged;
  dynamic selectedValueSingleDialogPagedFuture;
  dynamic selectedValueSingleDialogFuture;
  ExampleNumber? selectedNumber;
  List<int> selectedItemsMultiDialog = [];
  List<int> selectedItemsMultiCustomDisplayDialog = [];
  List<int> selectedItemsMultiSelect3Dialog = [];
  List<int> selectedItemsMultiMenu = [];
  List<int> selectedItemsMultiMenuSelectAllNone = [];
  List<int> selectedItemsMultiDialogSelectAllNoneWoClear = [];
  List<int> editableSelectedItems = [];
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> editableItems = [];
  List<DropdownMenuItem> futureItems = [];
  final _formKey = GlobalKey<FormState>();
  final _formKeyForValidator = GlobalKey<FormState>();
  String inputString = "";
  TextFormField? input;
  List<DropdownMenuItem<ExampleNumber>> numberItems = ExampleNumber.list.map((exNum) {
    return (DropdownMenuItem(value: exNum, child: Text(exNum.numberString)));
  }).toList();
  List<int> selectedItemsMultiSelect3Menu = [];
  List<int> selectedItemsMultiDialogWithCountAndWrap = [];
  List<int> selectedItemsMultiDialogPaged = [];
  List<Map<String, dynamic>> selectedItemsMultiMenuPagedFuture = [];
  List<Map<String, dynamic>> selectedItemsMultiDialogPagedFuture = [];

  static const String appTitle = "Search Choices demo";
  final String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Function? openDialog;

  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);

  bool noResult = false;

  String widgetSearchString = "";

  TextEditingController widgetSearchController = TextEditingController();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  String? formResult;

  @override
  void initState() {
    String wordPair = "";
    loremIpsum.toLowerCase().replaceAll(",", "").replaceAll(".", "").split(" ").forEach((word) {
      if (wordPair.isEmpty) {
        wordPair = "$word ";
      } else {
        wordPair += word;
        if (items.indexWhere((item) {
              return (item.value == wordPair);
            }) ==
            -1) {
          items.add(DropdownMenuItem(
            value: wordPair,
            child: Text(wordPair),
          ));
        }
        wordPair = "";
      }
    });
    input = TextFormField(
      validator: (value) {
        return ((value?.length ?? 0) < 6 ? "must be at least 6 characters long" : null);
      },
      initialValue: inputString,
      onChanged: (value) {
        inputString = value;
      },
      autofocus: true,
    );
    super.initState();
  }

  List<Widget> get appBarActions {
    return ([
      FlutsterTestRecord.defaultRecord.active
          ? SizedBox.shrink()
          : ElevatedButton(
              onPressed: () {
                setState(() {
                  SearchChoices.dialogBoxMenuWrapper = (Widget menuWidget) {
                    return (FlutsterTestRecorder(
                      name: "wrappedMenuWidget",
                      child: menuWidget,
                    ));
                  };
                  FlutsterTestRecord.defaultRecord.active = true;
                });
              },
              child: Text(
                "Test",
              ),
            ),
      Column(
        children: [
          Text(
            "Tabs:",
          ),
          SizedBox(
            height: 30,
            child: Switch(
              activeColor: Colors.white,
              value: asTabs,
              onChanged: (value) {
                setState(() {
                  asTabs = value;
                });
              },
            ),
          ),
        ],
      ),
    ]);
  }

  addItemDialog() async {
    return await showDialog(
      context: MyApp.navKey.currentState?.overlay?.context ?? context,
      builder: (BuildContext alertContext) {
        Widget dialogWidget = AlertDialog(
          title: const Text("Add an item"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                input ?? const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        editableItems.add(DropdownMenuItem(
                          value: inputString,
                          child: Text(inputString),
                        ));
                      });
                      Navigator.pop(alertContext, inputString);
                    }
                  },
                  child: const Text("Ok"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(alertContext, null);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        );
        if (FlutsterTestRecord.defaultRecord.active) {
          dialogWidget = FlutsterTestRecorder(
            name: "addItemDialog",
            child: dialogWidget,
          );
        }
        return (dialogWidget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    widgets = {
      "Single dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        displayClearIcon: false,
        padding: const EdgeInsets.only(right: 0),
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
      ),
      "Multi dialog": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiDialog,
        hint: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Select any"),
        ),
        searchHint: "Select any",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialog = value;
          });
        },
        closeButton: (selectedItems) {
          return (selectedItems.isNotEmpty
              ? "Save ${selectedItems.length == 1 ? '"${items[selectedItems.first].value}"' : '(${selectedItems.length})'}"
              : "Save without selection");
        },
        isExpanded: true,
      ),
      "Single done button dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDoneButtonDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDoneButtonDialog = value;
          });
        },
        doneButton: "Done",
        displayItem: (item, selected) {
          return (Row(children: [
            selected
                ? const Icon(
                    Icons.radio_button_checked,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                  ),
            const SizedBox(width: 7),
            Expanded(
              child: item,
            ),
          ]));
        },
        isExpanded: true,
      ),
      "Multi custom display dialog": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiCustomDisplayDialog,
        hint: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Select any"),
        ),
        searchHint: "Select any",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiCustomDisplayDialog = value;
          });
        },
        displayItem: (item, selected) {
          return (Row(children: [
            selected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey,
                  ),
            const SizedBox(width: 7),
            Expanded(
              child: item,
            ),
          ]));
        },
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.brown,
                      width: 0.5,
                    ),
                  ),
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(item.toString()),
                  ))));
        },
        doneButton: (selectedItemsDone, doneContext) {
          return (ElevatedButton(
              onPressed: () {
                Navigator.pop(doneContext);
                setState(() {});
              },
              child: const Text("Save")));
        },
        closeButton: null,
        style: const TextStyle(fontStyle: FontStyle.italic),
        searchFn: (String keyword, items) {
          List<int> ret = [];
          if (items != null && keyword.isNotEmpty) {
            keyword.split(" ").forEach((k) {
              int i = 0;
              items.forEach((item) {
                if (!ret.contains(i) && k.isNotEmpty && (item.value.toString().toLowerCase().contains(k.toLowerCase()))) {
                  ret.add(i);
                }
                i++;
              });
            });
          }
          if (keyword.isEmpty) {
            ret = Iterable<int>.generate(items.length).toList();
          }
          return (ret);
        },
        clearIcon: const Icon(Icons.clear_all),
        icon: const Icon(Icons.arrow_drop_down_circle),
        label: "Label for multi",
        underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.teal, width: 3.0))),
        ),
        iconDisabledColor: Colors.brown,
        iconEnabledColor: Colors.indigo,
        dropDownDialogPadding: const EdgeInsets.symmetric(
          vertical: 80,
          horizontal: 80,
        ),
        isExpanded: true,
        clearSearchIcon: const Icon(
          Icons.backspace,
          color: Colors.teal,
        ),
      ),
      "Multi select 3 dialog": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiSelect3Dialog,
        hint: "Select 3 items",
        searchHint: "Select 3",
        listValidator: (List<dynamic> selectedItemsForValidator) {
          if (selectedItemsForValidator.length != 3) {
            return ("Must select 3");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedItemsMultiSelect3Dialog = value;
          });
        },
        doneButton: (selectedItemsDone, doneContext) {
          return (ElevatedButton(
              onPressed: selectedItemsDone.length != 3
                  ? null
                  : () {
                      Navigator.pop(doneContext);
                      setState(() {});
                    },
              child: const Text("Save")));
        },
        closeButton: (selectedItemsClose) {
          return (selectedItemsClose.length == 3 ? "Ok" : null);
        },
        isExpanded: true,
      ),
      "Single menu": SearchChoices.single(
        items: items,
        value: selectedValueSingleMenu,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            selectedValueSingleMenu = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
      ),
      "Multi menu": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiMenu,
        hint: "Select any",
        searchHint: "",
        doneButton: "Close",
        closeButton: const SizedBox.shrink(),
        onChanged: (value) {
          setState(() {
            selectedItemsMultiMenu = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
      ),
      "Multi menu select all/none": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiMenuSelectAllNone,
        hint: "Select any",
        searchHint: "Select any",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiMenuSelectAllNone = value;
          });
        },
        dialogBox: false,
        closeButton: (selectedItemsClose, closeContext, Function updateParent) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                      selectedItemsClose.addAll(Iterable<int>.generate(items.length).toList());
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: const Text("Select all")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: const Text("Select none")),
            ],
          );
        },
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
      ),
      "Multi dialog select all/none without clear": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiDialogSelectAllNoneWoClear,
        hint: "Select any",
        searchHint: "Select any",
        displayClearIcon: false,
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialogSelectAllNoneWoClear = value;
          });
        },
        dialogBox: true,
        closeButton: (selectedItemsClose, closeContext, Function updateParent) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                      selectedItemsClose.addAll(Iterable<int>.generate(items.length).toList());
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: const Text("Select all")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: const Text("Select none")),
            ],
          );
        },
        isExpanded: true,
      ),
      "Single dialog custom keyboard": SearchChoices.single(
        items: Iterable<int>.generate(20).toList().map((i) {
          return (DropdownMenuItem(
            value: i.toString(),
            child: Text(i.toString()),
          ));
        }).toList(),
        value: selectedValueSingleDialogCustomKeyboard,
        hint: "Select one number",
        searchHint: "Select one number",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogCustomKeyboard = value;
          });
        },
        dialogBox: true,
        keyboardType: TextInputType.number,
        isExpanded: true,
      ),
      "Single dialog object": SearchChoices.single(
        items: numberItems,
        value: selectedNumber,
        hint: "Select one number",
        searchHint: "Select one number",
        onChanged: (value) {
          setState(() {
            selectedNumber = value;
          });
        },
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog overflow": SearchChoices.single(
        items: const [
          DropdownMenuItem(
            value:
                "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now",
            child: Text(
                "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now"),
          )
        ],
        value: selectedValueSingleDialogOverflow,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogOverflow = value;
          });
        },
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog readOnly": SearchChoices.single(
        items: const [
          DropdownMenuItem(
            value: "one item",
            child: Text("one item"),
          )
        ],
        value: "one item",
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: "Disabled",
        onChanged: (value) {
          setState(() {});
        },
        dialogBox: true,
        isExpanded: true,
        readOnly: true,
      ),
      "Single dialog disabled": SearchChoices.single(
        items: const [
          DropdownMenuItem(
            value: "one item",
            child: Text("one item"),
          )
        ],
        value: "one item",
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: "Disabled",
        onChanged: null,
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog editable items": SearchChoices.single(
        items: editableItems,
        value: selectedValueSingleDialogEditableItems,
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: (Function updateParent) {
          return (TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                updateParent(value);
              });
            },
            child: const Text("No choice, click to add one"),
          ));
        },
        closeButton: (String? value, BuildContext closeContext, Function updateParent) {
          return (editableItems.length >= 100
              ? "Close"
              : TextButton(
                  onPressed: () {
                    addItemDialog().then((value) async {
                      if (value != null && editableItems.indexWhere((element) => element.value == value) != -1) {
                        Navigator.pop(MyApp.navKey.currentState?.overlay?.context ?? context);
                        updateParent(value);
                      }
                    });
                  },
                  child: const Text("Add and select item"),
                ));
        },
        onChanged: (String? value) {
          setState(() {
            if (value is! NotGiven) {
              selectedValueSingleDialogEditableItems = value;
            }
          });
        },
        displayItem: (item, selected, Function updateParent) {
          return (Row(children: [
            selected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.transparent,
                  ),
            const SizedBox(width: 7),
            Expanded(
              child: item,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                editableItems.removeWhere((element) => item == element);
                updateParent(null);
                setState(() {});
              },
            ),
          ]));
        },
        dialogBox: true,
        isExpanded: true,
        doneButton: "Done",
      ),
      "Single menu editable items": SearchChoices.single(
        items: editableItems,
        value: selectedValueSingleMenuEditableItems,
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: (Function updateParent) {
          return (TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                updateParent(value);
              });
            },
            child: const Text("No choice, click to add one"),
          ));
        },
        closeButton: (String? value, BuildContext closeContext, Function updateParent) {
          return (editableItems.length >= 100
              ? "Close"
              : TextButton(
                  onPressed: () {
                    addItemDialog().then((value) async {
                      if (value != null && editableItems.indexWhere((element) => element.value == value) != -1) {
                        updateParent(value, true);
                      }
                    });
                  },
                  child: const Text("Add and select item"),
                ));
        },
        onChanged: (String? value, Function? pop) {
          setState(() {
            if (value is! NotGiven) {
              selectedValueSingleMenuEditableItems = value;
            }
          });
          if (pop != null && value is! NotGiven && value != null) {
            pop();
          }
        },
        displayItem: (DropdownMenuItem item, selected, Function updateParent) {
          bool deleteRequested = false;
          return ListTile(
            leading: selected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.transparent,
                  ),
            title: item,
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteRequested = true;
                editableItems.removeWhere((element) => item == element);
                updateParent(selected ? null : const NotGiven(), false);
                setState(() {});
              },
            ),
            onTap: () {
              if (!deleteRequested) {
                updateParent(item.value, true);
              }
            },
            horizontalTitleGap: 0,
          );
        },
        dialogBox: false,
        isExpanded: true,
        doneButton: "Done",
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
      ),
      "Multi dialog editable items": SearchChoices.multiple(
        items: editableItems,
        selectedItems: editableSelectedItems,
        hint: "Select any",
        searchHint: "Select any",
        disabledHint: (Function updateParent) {
          return (TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                if (value != null) {
                  editableSelectedItems = [0];
                  updateParent(editableSelectedItems);
                }
              });
            },
            child: const Text("No choice, click to add one"),
          ));
        },
        closeButton: (List<int> values, BuildContext closeContext, Function updateParent) {
          return (editableItems.length >= 100
              ? "Close"
              : TextButton(
                  onPressed: () {
                    addItemDialog().then((value) async {
                      if (value != null) {
                        int itemIndex = editableItems.indexWhere((element) => element.value == value);
                        if (itemIndex != -1) {
                          editableSelectedItems.add(itemIndex);
                          Navigator.pop(MyApp.navKey.currentState?.overlay?.context ?? context);
                          updateParent(editableSelectedItems);
                        }
                      }
                    });
                  },
                  child: const Text("Add and select item"),
                ));
        },
        onChanged: (values) {
          setState(() {
            if (values is! NotGiven) {
              editableSelectedItems = values;
            }
          });
        },
        displayItem: (item, selected, Function updateParent) {
          return (Row(children: [
            selected
                ? const Icon(
                    Icons.check_box,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.black,
                  ),
            const SizedBox(width: 7),
            Expanded(
              child: item,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                int indexOfItem = editableItems.indexOf(item);
                editableItems.removeWhere((element) => item == element);
                editableSelectedItems.removeWhere((element) => element == indexOfItem);
                for (int i = 0; i < editableSelectedItems.length; i++) {
                  if (editableSelectedItems[i] > indexOfItem) {
                    editableSelectedItems[i]--;
                  }
                }
                updateParent(editableSelectedItems);
                setState(() {});
              },
            ),
          ]));
        },
        dialogBox: true,
        isExpanded: true,
        doneButton: "Done",
      ),
      "Single dialog dark mode": Card(
        color: Colors.black,
        child: SearchChoices.single(
          items: items.map((item) {
            return (DropdownMenuItem(
              value: item.value,
              child: Text(
                item.value.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ));
          }).toList(),
          value: selectedValueSingleDialogDarkMode,
          hint: const Text(
            "Select one",
            style: TextStyle(color: Colors.white),
          ),
          searchHint: const Text(
            "Select one",
            style: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white, backgroundColor: Colors.black),
          closeButton: TextButton(
            onPressed: () {
              Navigator.pop(MyApp.navKey.currentState?.overlay?.context ?? context);
            },
            child: const Text(
              "Close",
              style: TextStyle(color: Colors.white),
            ),
          ),
          menuBackgroundColor: Colors.black,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
          onChanged: (value) {
            setState(() {
              selectedValueSingleDialogDarkMode = value;
            });
          },
          isExpanded: true,
        ),
      ),
      "Single dialog ellipsis": SearchChoices.single(
        items: const [
          DropdownMenuItem(
            value:
                "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now",
            child: Text(
              "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now",
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
        value: selectedValueSingleDialogEllipsis,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogEllipsis = value;
          });
        },
        selectedValueWidgetFn: (item) {
          return DropdownMenuItem(
            child: (Text(
              item,
              overflow: TextOverflow.ellipsis,
            )),
          );
        },
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog right to left": SearchChoices.single(
        items: [
          "طنجة",
          "فاس‎",
          "أكادير‎",
          "تزنيت‎",
          "آكــلــو",
          "سيدي بيبي",
        ].map<DropdownMenuItem<String>>((string) {
          return (DropdownMenuItem<String>(
            value: string,
            child: Text(
              string,
              textDirection: TextDirection.rtl,
            ),
          ));
        }).toList(),
        value: selectedValueSingleDialogRightToLeft,
        hint: Row(
          textDirection: TextDirection.rtl,
          children: const [
            Text(
              "ختار",
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        searchHint: const Text(
          "ختار",
          textDirection: TextDirection.rtl,
        ),
        closeButton: TextButton(
          onPressed: () {
            Navigator.pop(MyApp.navKey.currentState?.overlay?.context ?? context);
          },
          child: const SizedBox(
            width: 50,
            child: Text(
              "سدّ",
              maxLines: 1,
              softWrap: false,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogRightToLeft = value;
          });
        },
        isExpanded: true,
        rightToLeft: true,
        displayItem: (item, selected) {
          return (Row(textDirection: TextDirection.rtl, children: [
            selected
                ? const Icon(
                    Icons.radio_button_checked,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                  ),
            const SizedBox(width: 7),
            item,
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ]));
        },
        selectedValueWidgetFn: (item) {
          return DropdownMenuItem(
            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                (Text(
                  item,
                  textDirection: TextDirection.rtl,
                )),
              ],
            ),
          );
        },
      ),
      "Update value from outside the plugin": Column(
        children: [
          SearchChoices.single(
            items: items,
            value: selectedValueUpdateFromOutsideThePlugin,
            hint: const Text('Select One'),
            searchHint: const Text(
              'Select One',
              style: TextStyle(fontSize: 20),
            ),
            onChanged: (value) {
              setState(() {
                selectedValueUpdateFromOutsideThePlugin = value;
              });
            },
            isExpanded: true,
          ),
          TextButton(
            child: const Text("Select dolor sit"),
            onPressed: () {
              setState(() {
                selectedValueUpdateFromOutsideThePlugin = "dolor sit";
              });
            },
          ),
        ],
      ),
      "Multi select 3 menu no-autofocus": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiSelect3Menu,
        hint: "Select 3 items",
        searchHint: "Select 3",
        listValidator: (List<dynamic> selectedItemsForValidatorWithMenu) {
          if (selectedItemsForValidatorWithMenu.length != 3) {
            return ("Must select 3");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedItemsMultiSelect3Menu = value;
          });
        },
        isExpanded: true,
        dialogBox: false,
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
        autofocus: false,
      ),
      "Multi dialog with count and wrap": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiDialogWithCountAndWrap,
        hint: "Select items",
        searchHint: "Select items",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialogWithCountAndWrap = value;
          });
        },
        isExpanded: true,
        selectedValueWidgetFn: (item) {
          return (Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          ));
        },
        selectedAggregateWidgetFn: (List<Widget> list) {
          return (Column(children: [
            Text("${list.length} items selected"),
            Wrap(children: list),
          ]));
        },
      ),
      "Single dialog open and set search terms": SearchChoices.single(
        label: Column(
          children: items.map((item) {
            return (ElevatedButton(
              child: item.child,
              onPressed: () {
                openDialog!(item.value.toString());
              },
            ));
          }).toList(),
        ),
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        setOpenDialog: (externalOpenDialog) {
          openDialog = externalOpenDialog;
        },
      ),
      "Single dialog custom dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        buildDropDownDialog: (
          Widget titleBar,
          Widget searchBar,
          Widget list,
          Widget closeButton,
          BuildContext dropDownContext,
        ) {
          return (AnimatedContainer(
            padding: MediaQuery.of(dropDownContext).viewInsets,
            duration: const Duration(milliseconds: 300),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    titleBar,
                    searchBar,
                    list,
                    closeButton,
                  ],
                ),
              ),
            ),
          ));
        },
      ),
      "Single dialog custom decorations": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: const Padding(
            padding: EdgeInsets.all(3),
            child: DropdownMenuItem(
              child: Text("Select one"),
            )),
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        searchInputDecoration: const InputDecoration(
          icon: Icon(Icons.airline_seat_flat),
          border: OutlineInputBorder(),
        ),
        fieldDecoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.blueGrey,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        selectedValueWidgetFn: (selectedValue) {
          return (Padding(
            padding: const EdgeInsets.all(3),
            child: DropdownMenuItem(child: Text(selectedValue)),
          ));
        },
      ),
      "Single dialog paged": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialogPaged,
        hint: "Select one",
        searchHint: "Search one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogPaged = value;
          });
        },
        isExpanded: true,
        itemsPerPage: 5,
        currentPage: currentPage,
      ),
      "Multi dialog paged rtl": SearchChoices.multiple(
        items: [
          "طنجة",
          "فاس‎",
          "أكادير‎",
          "تزنيت‎",
          "آكــلــو",
          "سيدي بيبي",
        ].map<DropdownMenuItem>((string) {
          return (DropdownMenuItem(
            value: string,
            child: Text(
              string,
              textDirection: TextDirection.rtl,
            ),
          ));
        }).toList(),
        selectedItems: selectedItemsMultiDialogPaged,
        hint: Row(
          textDirection: TextDirection.rtl,
          children: const [
            Text(
              "ختار",
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        searchHint: const Text(
          "ختار",
          textDirection: TextDirection.rtl,
        ),
        closeButton: TextButton(
          onPressed: () {
            Navigator.pop(MyApp.navKey.currentState?.overlay?.context ?? context);
          },
          child: const SizedBox(
            width: 50,
            child: Text(
              "سدّ",
              maxLines: 1,
              softWrap: false,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialogPaged = value;
          });
        },
        isExpanded: true,
        rightToLeft: true,
        displayItem: (item, selected) {
          return (Row(textDirection: TextDirection.rtl, children: [
            const SizedBox(width: 7),
            selected
                ? const Icon(
                    Icons.radio_button_checked,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                  ),
            const SizedBox(width: 7),
            item,
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ]));
        },
        selectedValueWidgetFn: (item) {
          return DropdownMenuItem(
            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                (Text(
                  item,
                  textDirection: TextDirection.rtl,
                )),
              ],
            ),
          );
        },
        itemsPerPage: 5,
        currentPage: currentPage,
        doneButton: "قريب",
      ),
      "Single dialog paged custom pagination": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialogPaged,
        hint: "Select one",
        searchHint: "Search one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogPaged = value;
          });
        },
        isExpanded: true,
        itemsPerPage: 5,
        currentPage: currentPage,
        customPaginationDisplay: (Widget listWidget, int totalFilteredItemsNb, Function updateSearchPage) {
          return (Expanded(
              child: Column(children: [
            listWidget,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                const Text("Page:"),
                const SizedBox(
                  width: 10,
                ),
                Wrap(
                  spacing: 10,
                  children: Iterable<int>.generate((totalFilteredItemsNb / 5).ceil()).toList().map((i) {
                    return (SizedBox(
                      width: (31 + 9 * (i + 1).toString().length) + 0.0,
                      height: 30.0,
                      child: ElevatedButton(
                        onPressed: (i + 1) == currentPage.value
                            ? null
                            : () {
                                currentPage.value = i + 1;
                                updateSearchPage();
                              },
                        child: Text("${i + 1}"),
                      ),
                    ));
                  }).toList(),
                ),
              ]),
            ),
          ])));
        },
      ),
      "Single menu paged": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialogPaged,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogPaged = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
        itemsPerPage: 5,
        currentPage: currentPage,
      ),
      "Single dialog paged future": SearchChoices.single(
        value: selectedValueSingleDialogPagedFuture,
        hint: kIsWeb ? "Example not for web" : "Select one capital",
        searchHint: "Search capitals",
        onChanged: kIsWeb
            ? null
            : (value) {
                setState(() {
                  selectedValueSingleDialogPagedFuture = value;
                });
              },
        isExpanded: true,
        itemsPerPage: 10,
        currentPage: currentPage,
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(item["capital"]),
                  ))));
        },
        futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
          String filtersString = "";
          int i = 1;
          filters?.forEach((element) {
            filtersString += "&filter$i=${element.item1},${element.item2}";
            i++;
          });
          Response response = await get(Uri.parse(
                  "https://searchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
              .timeout(const Duration(
            seconds: 10,
          ));
          if (response.statusCode != 200) {
            throw Exception("failed to get data from internet");
          }
          dynamic data = jsonDecode(response.body);
          int nbResults = data["results"];
          List<DropdownMenuItem> results = (data["records"] as List<dynamic>)
              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                    value: item,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
                      ),
                    ),
                  ))
              .toList();
          return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
        },
        futureSearchOrderOptions: {
          "country": {
            "icon": Wrap(children: const [
              Icon(Icons.flag),
              Text(
                "Country",
              )
            ]),
            "asc": true
          },
          "capital": {
            "icon": Wrap(children: const [Icon(Icons.location_city), Text("Capital")]),
            "asc": true
          },
          "continent": const {"icon": "Continent", "asc": true},
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "asc": false
          },
        },
        futureSearchFilterOptions: {
          "continent": const {
            "icon": Text("Continent"),
            "exclusive": true,
            "values": [
              {"eq,Africa": "Africa"},
              {"eq,Americas": "Americas"},
              {"eq,Asia": "Asia"},
              {"eq,Australia": "Australia"},
              {"eq,Europe": "Europe"},
              {"eq,Oceania": "Oceania"}
            ]
          },
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "exclusive": true,
            "values": [
              {
                "lt,1000": Wrap(children: const [Icon(Icons.person), Text("<1,000")])
              },
              {
                "lt,100000": Wrap(children: const [Icon(Icons.person_add), Text("<100,000")])
              },
              {
                "lt,1000000": Wrap(children: const [Icon(Icons.nature_people), Text("<1,000,000")])
              },
              {
                "gt,1000000": Wrap(children: const [Icon(Icons.people), Text(">1,000,000")])
              },
              {
                "gt,10000000": Wrap(children: const [Icon(Icons.location_city), Text(">10,000,000")])
              },
            ]
          },
        },
        closeButton: (selectedItemsDone, doneContext) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 25,
                width: 48,
                child: (ElevatedButton(
                    onPressed: () {
                      Navigator.pop(doneContext);
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close,
                      size: 17,
                    ))),
              ),
            ],
          );
        },
      ),
      "Multi menu paged future": SearchChoices.multiple(
        futureSelectedValues: selectedItemsMultiMenuPagedFuture,
        hint: kIsWeb ? "Example not for web" : "Select capitals",
        searchHint: "",
        dialogBox: false,
        onChanged: kIsWeb
            ? null
            : (value) {
                setState(() {
                  selectedItemsMultiMenuPagedFuture = value;
                });
              },
        isExpanded: true,
        itemsPerPage: 10,
        currentPage: currentPage,
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(item["capital"]),
                  ))));
        },
        futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
          String filtersString = "";
          int i = 1;
          filters?.forEach((element) {
            filtersString += "&filter$i=${element.item1},${element.item2}";
            i++;
          });
          Response response = await get(Uri.parse(
                  "https://searchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
              .timeout(const Duration(
            seconds: 10,
          ));
          if (response.statusCode != 200) {
            throw Exception("failed to get data from internet");
          }
          dynamic data = jsonDecode(response.body);
          int nbResults = data["results"];
          var results = (data["records"] as List<dynamic>)
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
                      ),
                    ),
                  ))
              .toList();
          return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
        },
        futureSearchOrderOptions: {
          "country": {
            "icon": Wrap(children: const [
              Icon(Icons.flag),
              Text(
                "Country",
              )
            ]),
            "asc": true
          },
          "capital": {
            "icon": Wrap(children: const [Icon(Icons.location_city), Text("Capital")]),
            "asc": true
          },
          "continent": const {"icon": "Continent", "asc": true},
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "asc": false
          },
        },
        futureSearchFilterOptions: {
          "continent": const {
            "icon": Text("Continent"),
            "exclusive": true,
            "values": [
              {"eq,Africa": "Africa"},
              {"eq,Americas": "Americas"},
              {"eq,Asia": "Asia"},
              {"eq,Australia": "Australia"},
              {"eq,Europe": "Europe"},
              {"eq,Oceania": "Oceania"}
            ]
          },
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "exclusive": true,
            "values": [
              {
                "lt,1000": Wrap(children: const [Icon(Icons.person), Text("<1,000")])
              },
              {
                "lt,100000": Wrap(children: const [Icon(Icons.person_add), Text("<100,000")])
              },
              {
                "lt,1000000": Wrap(children: const [Icon(Icons.nature_people), Text("<1,000,000")])
              },
              {
                "gt,1000000": Wrap(children: const [Icon(Icons.people), Text(">1,000,000")])
              },
              {
                "gt,10000000": Wrap(children: const [Icon(Icons.location_city), Text(">10,000,000")])
              },
            ]
          },
        },
        menuConstraints: BoxConstraints.tight(const Size.fromHeight(350)),
      ),
      "Single dialog custom empty list": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        emptyListWidget: (String keyword) => "No result with the \"$keyword\" keyword",
      ),
      "Single dialog future custom empty list": SearchChoices.single(
        value: selectedValueSingleDialogFuture,
        hint: kIsWeb ? "Example not for web" : "Select one capital",
        searchHint: "Search capitals",
        onChanged: kIsWeb
            ? null
            : (value) {
                setState(() {
                  selectedValueSingleDialogFuture = value;
                });
              },
        isExpanded: true,
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(item["capital"]),
                  ))));
        },
        futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
          String filtersString = "";
          int i = 1;
          filters?.forEach((element) {
            // This example doesn't have any futureSearchFilterOptions parameter, thus, this loop will never run anything.
            filtersString += "&filter$i=${element.item1},${element.item2}";
            i++;
          });
          Response response = await get(Uri.parse(
                  "https://searchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
              .timeout(const Duration(
            seconds: 10,
          ));
          if (response.statusCode != 200) {
            throw Exception("failed to get data from internet");
          }
          dynamic data = jsonDecode(response.body);
          int nbResults = data["results"];
          List<DropdownMenuItem> results = (data["records"] as List<dynamic>)
              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                    value: item,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
                      ),
                    ),
                  ))
              .toList();
          return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
        },
        emptyListWidget: () => const Text(
          "No result",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ),
      "Single dialog onTap": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        onTap: () {
          setState(() {
            selectedValueSingleDialog = null;
          });
        },
      ),
      "Multi dialog paged future": SearchChoices.multiple(
        futureSelectedValues: selectedItemsMultiDialogPagedFuture,
        hint: kIsWeb ? "Example not for web" : "Select capitals",
        searchHint: "",
        dialogBox: true,
        onChanged: kIsWeb
            ? null
            : (value) {
                setState(() {
                  selectedItemsMultiDialogPagedFuture = value;
                });
              },
        isExpanded: true,
        itemsPerPage: 10,
        currentPage: currentPage,
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(item["capital"]),
                  ))));
        },
        futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
          String filtersString = "";
          int i = 1;
          filters?.forEach((element) {
            filtersString += "&filter$i=${element.item1},${element.item2}";
            i++;
          });
          Response response = await get(Uri.parse(
                  "https://searchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
              .timeout(const Duration(
            seconds: 10,
          ));
          if (response.statusCode != 200) {
            throw Exception("failed to get data from internet");
          }
          dynamic data = jsonDecode(response.body);
          int nbResults = data["results"];
          List<DropdownMenuItem> results = (data["records"] as List<dynamic>)
              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                    value: item,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
                      ),
                    ),
                  ))
              .toList();
          return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
        },
        futureSearchOrderOptions: {
          "country": {
            "icon": Wrap(children: const [
              Icon(Icons.flag),
              Text(
                "Country",
              )
            ]),
            "asc": true
          },
          "capital": {
            "icon": Wrap(children: const [Icon(Icons.location_city), Text("Capital")]),
            "asc": true
          },
          "continent": const {"icon": "Continent", "asc": true},
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "asc": false
          },
        },
        futureSearchFilterOptions: {
          "continent": const {
            "icon": Text("Continent"),
            "exclusive": true,
            "values": [
              {"eq,Africa": "Africa"},
              {"eq,Americas": "Americas"},
              {"eq,Asia": "Asia"},
              {"eq,Australia": "Australia"},
              {"eq,Europe": "Europe"},
              {"eq,Oceania": "Oceania"}
            ]
          },
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "exclusive": true,
            "values": [
              {
                "lt,1000": Wrap(children: const [Icon(Icons.person), Text("<1,000")])
              },
              {
                "lt,100000": Wrap(children: const [Icon(Icons.person_add), Text("<100,000")])
              },
              {
                "lt,1000000": Wrap(children: const [Icon(Icons.nature_people), Text("<1,000,000")])
              },
              {
                "gt,1000000": Wrap(children: const [Icon(Icons.people), Text(">1,000,000")])
              },
              {
                "gt,10000000": Wrap(children: const [Icon(Icons.location_city), Text(">10,000,000")])
              },
            ]
          },
        },
      ),
      "Single dialog future custom error button": SearchChoices.single(
        value: selectedValueSingleDialogFuture,
        hint: kIsWeb ? "Example not for web" : "Select one capital",
        searchHint: "Search capitals",
        onChanged: kIsWeb
            ? null
            : (value) {
                setState(() {
                  selectedValueSingleDialogFuture = value;
                });
              },
        isExpanded: true,
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(item["capital"]),
                  ))));
        },
        futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
          String filtersString = "";
          int i = 1;
          filters?.forEach((element) {
            // This example doesn't have any futureSearchFilterOptions parameter, thus, this loop will never run anything.
            filtersString += "&filter$i=${element.item1},${element.item2}";
            i++;
          });
          Response response = await get(Uri.parse(
                  "https://FAULTYsearchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
              .timeout(const Duration(
            seconds: 10,
          ));
          if (response.statusCode != 200) {
            throw Exception("failed to get data from internet");
          }
          dynamic data = jsonDecode(response.body);
          int nbResults = data["results"];
          List<DropdownMenuItem> results = (data["records"] as List<dynamic>)
              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                    value: item,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
                      ),
                    ),
                  ))
              .toList();
          return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
        },
        futureSearchRetryButton: (Function onPressed) => Column(children: [
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton.icon(
                onPressed: () {
                  onPressed();
                },
                icon: const Icon(Icons.repeat),
                label: const Text("Intentional error - retry")),
          )
        ]),
      ),
      "Single dialog paged delayed": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialogPaged,
        hint: "Select one",
        searchHint: "Search one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogPaged = value;
          });
        },
        isExpanded: true,
        itemsPerPage: 5,
        currentPage: currentPage,
        searchDelay: 500,
      ),
      "Single dialog paged future delayed": SearchChoices.single(
        value: selectedValueSingleDialogPagedFuture,
        hint: kIsWeb ? "Example not for web" : "Select one capital",
        searchHint: "Search capitals",
        onChanged: kIsWeb
            ? null
            : (value) {
                setState(() {
                  selectedValueSingleDialogPagedFuture = value;
                });
              },
        isExpanded: true,
        itemsPerPage: 10,
        currentPage: currentPage,
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(item["capital"]),
                  ))));
        },
        futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
          String filtersString = "";
          int i = 1;
          filters?.forEach((element) {
            filtersString += "&filter$i=${element.item1},${element.item2}";
            i++;
          });
          Response response = await get(Uri.parse(
                  "https://searchchoices.jod.li/exampleList.php?page=${pageNb ?? 1},10${orderBy == null ? "" : "&order=$orderBy,${orderAsc ?? true ? "asc" : "desc"}"}${(keyword == null || keyword.isEmpty) ? "" : "&filter=capital,cs,$keyword"}$filtersString"))
              .timeout(const Duration(
            seconds: 10,
          ));
          if (response.statusCode != 200) {
            throw Exception("failed to get data from internet");
          }
          dynamic data = jsonDecode(response.body);
          int nbResults = data["results"];
          List<DropdownMenuItem> results = (data["records"] as List<dynamic>)
              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                    value: item,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
                      ),
                    ),
                  ))
              .toList();
          return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
        },
        futureSearchOrderOptions: {
          "country": {
            "icon": Wrap(children: const [
              Icon(Icons.flag),
              Text(
                "Country",
              )
            ]),
            "asc": true
          },
          "capital": {
            "icon": Wrap(children: const [Icon(Icons.location_city), Text("Capital")]),
            "asc": true
          },
          "continent": const {"icon": "Continent", "asc": true},
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "asc": false
          },
        },
        futureSearchFilterOptions: {
          "continent": const {
            "icon": Text("Continent"),
            "exclusive": true,
            "values": [
              {"eq,Africa": "Africa"},
              {"eq,Americas": "Americas"},
              {"eq,Asia": "Asia"},
              {"eq,Australia": "Australia"},
              {"eq,Europe": "Europe"},
              {"eq,Oceania": "Oceania"}
            ]
          },
          "population": {
            "icon": Wrap(children: const [Icon(Icons.people), Text("Population")]),
            "exclusive": true,
            "values": [
              {
                "lt,1000": Wrap(children: const [Icon(Icons.person), Text("<1,000")])
              },
              {
                "lt,100000": Wrap(children: const [Icon(Icons.person_add), Text("<100,000")])
              },
              {
                "lt,1000000": Wrap(children: const [Icon(Icons.nature_people), Text("<1,000,000")])
              },
              {
                "gt,1000000": Wrap(children: const [Icon(Icons.people), Text(">1,000,000")])
              },
              {
                "gt,10000000": Wrap(children: const [Icon(Icons.location_city), Text(">10,000,000")])
              },
            ],
          },
        },
        closeButton: (selectedItemsDone, doneContext) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 25,
                width: 48,
                child: (ElevatedButton(
                    onPressed: () {
                      Navigator.pop(doneContext);
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close,
                      size: 17,
                    ))),
              ),
            ],
          );
        },
        searchDelay: 500,
        // Here, buildFutureFilterOrOrderButton doesn't change anything.
        // This is a way to make sure this parameter still works with automated
        // integration testing.
        buildFutureFilterOrOrderButton: ({
          required BuildContext context,
          required bool filter,
          required Function onPressed,
          int? nbFilters,
          bool? orderAsc,
          String? orderBy,
        }) {
          if (filter) {
            return (SizedBox(
              height: 25,
              width: 48,
              child: (ElevatedButton(
                child: Icon(
                  nbFilters == null || nbFilters == 0
                      ? Icons.filter
                      : nbFilters == 1
                          ? Icons.filter_1
                          : nbFilters == 2
                              ? Icons.filter_2
                              : nbFilters == 3
                                  ? Icons.filter_3
                                  : nbFilters == 4
                                      ? Icons.filter_4
                                      : nbFilters == 5
                                          ? Icons.filter_5
                                          : nbFilters == 6
                                              ? Icons.filter_6
                                              : nbFilters == 7
                                                  ? Icons.filter_7
                                                  : nbFilters == 8
                                                      ? Icons.filter_8
                                                      : nbFilters == 9
                                                          ? Icons.filter_9
                                                          : Icons.filter_9_plus_sharp,
                  size: 17,
                ),
                onPressed: () {
                  onPressed();
                },
              )),
            ));
          }

          Widget icon = Icon(
            Icons.sort,
            size: 17,
          );

          return SizedBox(
            height: 25,
            width: orderBy == null ? 48 : 70,
            child: (orderBy == null
                ? ElevatedButton(
                    child: icon,
                    onPressed: () {
                      onPressed();
                    },
                  )
                : ElevatedButton.icon(
                    label: Icon(
                      orderAsc ?? true ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 17,
                    ),
                    icon: icon,
                    onPressed: () {
                      onPressed();
                    },
                  )),
          );
        },
        // Here, searchResultDisplayFn doesn't change anything.
        // This is a way to make sure this parameter still works with automated
        // integration testing.
        searchResultDisplayFn: ({
          required List<Tuple3<int, DropdownMenuItem, bool>> itemsToDisplay,
          required ScrollController scrollController,
          required bool thumbVisibility,
          required Widget emptyListWidget,
          required void Function(int index, dynamic value, bool itemSelected) itemTapped,
          required Widget Function(DropdownMenuItem item, bool isItemSelected) displayItem,
        }) {
          return Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: thumbVisibility,
              child: itemsToDisplay.isEmpty
                  ? emptyListWidget
                  : ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        int itemIndex = itemsToDisplay[index].item1;
                        DropdownMenuItem item = itemsToDisplay[index].item2;
                        bool isItemSelected = itemsToDisplay[index].item3;
                        return InkWell(
                          onTap: () {
                            itemTapped(
                              itemIndex,
                              item.value,
                              isItemSelected,
                            );
                          },
                          child: displayItem(
                            item,
                            isItemSelected,
                          ),
                        );
                      },
                      itemCount: itemsToDisplay.length,
                    ),
            ),
          );
        },
      ),
      "Single dialog custom field presentation": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Label',
                isDense: true,
                filled: true,
                fillColor: Colors.green.shade100,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: fieldWidget,
            ),
          );
        },
      ),
      "Single custom showDialogFn": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        hint: "Select one",
        isExpanded: true,
        showDialogFn: (
          BuildContext context,
          Widget Function({String searchTerms}) menuWidget,
          String searchTerms,
        ) async {
          await showDialog(
              barrierColor: Colors.pinkAccent,
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return (menuWidget(searchTerms: searchTerms));
              });
        },
      ),
      "Validator in form": Form(
        key: _formKeyForValidator,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              validator: (String? value) {
                if (value == "ok") {
                  return (null);
                }
                return ("Not the expected value");
              },
            ),
            SearchChoices.single(
              items: items,
              value: selectedValueSingleDialog,
              onChanged: (value) {
                setState(() {
                  selectedValueSingleDialog = value;
                });
              },
              isExpanded: true,
              validator: (dynamic value) {
                if (value == null) {
                  return ("Must select a value");
                }
                if (!(value is String)) {
                  return ("Selected value must be a String");
                }
                if (value.startsWith("l")) {
                  return (null);
                }
                return ("Must start with 'l'");
              },
            ),
            SearchChoices.multiple(
              items: items,
              selectedItems: selectedItemsMultiDialog,
              onChanged: (value) {
                setState(() {
                  selectedItemsMultiDialog = value;
                });
              },
              isExpanded: true,
              validator: (dynamic value) {
                if (value == null) {
                  return ("Must select some values");
                }
                if (!(value is List<int>)) {
                  return ("Selection is of unexpected type");
                }
                if (value.length < 3) {
                  return ("Must select at least 3");
                }
                return (null);
              },
            ),
            TextButton(
              onPressed: () {
                if (_formKeyForValidator.currentState?.validate() ?? false) {
                  setState(() {
                    formResult = "All good";
                  });
                } else {
                  setState(() {
                    formResult = "Form is not valid!";
                  });
                }
              },
              child: const Text("Ok"),
            ),
            formResult == null
                ? SizedBox.shrink()
                : Text(formResult ?? "",
                    style: TextStyle(
                      color: formResult == "All good" ? Colors.black : Colors.red,
                    )),
          ],
        ),
      ),
      "Custom objects single and multiple dialogs": CustomObjectSample(),
    };

    List<Widget> exampleWidgets = [];
    int? exampleId = int.tryParse(widgetSearchString);
    if (widgetSearchString.isNotEmpty && exampleId != null && exampleId >= 0 && exampleId < widgets.length) {
      exampleWidgets = [
        widgetToExample(
          widgets.values.toList()[exampleId],
          widgets.keys.toList()[exampleId],
          exampleId,
        )
      ];
    } else {
      exampleWidgets = widgets
          .map((k, v) {
            return (MapEntry(
              k,
              !k.toLowerCase().contains(widgetSearchString)
                  ? const SizedBox.shrink()
                  : widgetToExample(
                      v,
                      k,
                      widgets.keys.toList().indexOf(k),
                    ),
            ));
          })
          .values
          .toList();
    }

    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: FlutsterTestRecord.defaultRecord.active
              ?
              // This helps a lot for screenshot comparisons on tests
              Colors.white
              : null,
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navKey,
      home: asTabs
          ? DefaultTabController(
              length: widgets.length,
              child: FlutsterScaffold(
                name: "SearchChoicesDemoTabs",
                appBar: AppBar(
                  title: const Text(appTitle),
                  actions: appBarActions,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: Iterable<int>.generate(widgets.length).toList().map((i) {
                      return (Tab(
                        text: (i + 1).toString(),
                      ));
                    }).toList(),
                  ),
                ),
                body: Container(
                  padding: const EdgeInsets.all(20),
                  child: TabBarView(
                    children: widgets
                        .map((k, v) {
                          return (MapEntry(
                              k,
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(children: [
                                  Text(k),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  v,
                                ]),
                              )));
                        })
                        .values
                        .toList(),
                  ),
                ),
              ),
            )
          : FlutsterScaffold(
              name: "SearchChoicesDemoNoTabs",
              appBar: AppBar(
                title: const Text(appTitle),
                actions: appBarActions,
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: exampleWidgets
                    ..add(
                      //prevents scrolling issues at the end of the list of Widgets
                      const Center(
                        child: SizedBox(
                          height: 500,
                        ),
                      ),
                    )
                    ..insert(
                      0,
                      Center(
                        child: searchField(),
                      ),
                    ),
                ),
              ),
            ),
    );
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widgetSearchController,
              decoration: const InputDecoration(hintText: 'Search for an example'),
              onChanged: (value) {
                setState(() {
                  widgetSearchString = value;
                });
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          IconButton(
            icon: Icon(
              Icons.clear,
              color: widgetSearchString.isEmpty ? Colors.grey : Colors.black,
            ),
            onPressed: widgetSearchString.isEmpty
                ? null
                : () {
                    setState(() {
                      widgetSearchString = "";
                      widgetSearchController.text = "";
                    });
                  },
          ),
        ],
      ),
    );
  }

  Widget widgetToExample(
    Widget w,
    String name,
    int id,
  ) {
    return (Center(
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Tooltip(
                    message: "$id",
                    child: Text(
                      "$name:",
                    ),
                  ),
                  w,
                ],
              ),
            ))));
  }

  void snack(BuildContext context, dynamic content) {
    if (content is String) {
      content = Text(content);
    }
    _messengerKey.currentState?.showSnackBar(SnackBar(content: content));
  }
}
