import 'package:flutter/material.dart';
import 'package:meenforquei/models/meus_convidados_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/meus_convidados_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CreateMeusConvidadosView extends StatefulWidget {
  final MeusConvidadosModel edittingMeusConvidados;

  CreateMeusConvidadosView({Key key, this.edittingMeusConvidados})
      : super(key: key);

  @override
  _CreateMeusConvidadosViewState createState() =>
      _CreateMeusConvidadosViewState();
}

class _CreateMeusConvidadosViewState extends State<CreateMeusConvidadosView> {
  TextEditingController searchController = new TextEditingController();
//  List<Contact> contacts = [];
//  List<Contact> contactsFilter = [];
  bool isShown = true;

  String debugText = "";

  @override
  void initState() {
    super.initState();
    _askPermissions();

    searchController.addListener(() {
      // ToDo: Remover listener
      filterContacts();
    });
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();

    setState(() {
      debugText = '_0: ' + permissionStatus.toString();
    });

    if (permissionStatus != PermissionStatus.granted) {
      setState(() {
        debugText = '_1: _handleInvalidPermissions';
      });

      _handleInvalidPermissions(permissionStatus);
    }else{
      getAllContacts();
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;

    setState(() {
      debugText = '_2: ' + permission.toString();
    });

    if (permission == PermissionStatus.granted){
      setState(() {
        debugText = '_3: PermissionStatus.granted';
        isShown = true;
      });

      return permission;
    }else if (permission == PermissionStatus.permanentlyDenied) {
      setState(() {
        debugText = '_4: openAppSettings()';
      });

      openAppSettings();
      return null;
    } else if (permission == PermissionStatus.denied) {
      setState(() {
        debugText = '_5: PermissionStatus.denied';
      });

      await Permission.contacts.request();
      return Permission.contacts.status;
    } else {
      setState(() {
        debugText = '_6: ' + permission.toString();
      });

      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      setState(() {
        debugText = '_7';
        isShown = false;
      });
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      setState(() {
        debugText = '_8';
        isShown = false;
      });
    }
  }

  getAllContacts() async {
    isShown = await Permission.contacts.isGranted;

    if (isShown) {
      /*
      List<Contact> _contacts = (await ContactsService.getContacts()).toList();
      setState(() {
        contacts = _contacts;
      });
      */
    }

    /*
    if (await Permission.contacts.request().isGranted) {
      List<Contact> _contacts = (await ContactsService.getContacts()).toList();
      setState(() {
        contacts = _contacts;
      });
    }
    */

    if (await Permission.contacts.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  filterContacts() {
    /*
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = contact.phones.firstWhere((phone) {
          String phoneFlatten = flattenPhoneNumber(phone.value);
          return phoneFlatten.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });

      setState(() {
        contactsFilter = _contacts;
      });
    }
     */
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final convidadoProvider = Provider.of<MeusConvidadosViewModel>(context);

    bool isSearching = searchController.text.isNotEmpty;

    return Scaffold(
        appBar: AppBar(title: Text(MEString.titleConvidadosCadastro)),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: MEString.search + ' ' + debugText,
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          prefixIcon: Icon(Icons.search,
                              color: Theme.of(context).primaryColor))),
                ),
                isShown
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: 0, /*isSearching
                                ? contactsFilter.length
                                : contacts.length,
                                */
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              /*
                              Contact contact = isSearching
                                  ? contactsFilter[index]
                                  : contacts[index];
                               */
                              return GestureDetector(
                                onTap: (){
                                  convidadoProvider.addConvidado(
                                    MeusConvidadosModel(
//                                      name: contact.displayName,
//                                      email: contact.emails.elementAt(0).value,
//                                      phone: contact.phones.elementAt(0).value,
                                      date: DateTime.now().toString()
                                    )
                                  );
                                },
                                child: ListTile(
                                  title: Text('contact.displayName'),
                                  subtitle: Text('contact.phones.elementAt(0).value'),
                                  /*
                                  leading: (contact.avatar != null &&
                                          contact.avatar.length > 0)
                                      ? CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(contact.avatar))
                                      : CircleAvatar(
                                          child: Text(contact.initials())),
                                   */
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: Text(MEString.errorPermitContact,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)))
              ],
            )));
  }
}
