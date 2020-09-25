import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:meenforquei/components/busy_button.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/viewmodel/signup_view_model.dart';

class SignUpView extends StatefulWidget {
  SignUpView({Key key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

const String MIN_DATETIME = '15/05/2020';
const String MAX_DATETIME = '31/12/2050';
const String INIT_DATETIME = '18/05/2020';
const String DATE_FORMAT = 'dd/MM/yyyy';

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameCController = TextEditingController();
  final _emailCController = TextEditingController();
  final _passCController = TextEditingController();
  final _phoneCController = TextEditingController();
  final _dataController = TextEditingController();
  final _tagController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    ScreenUtil.init(allowFontScaling: true, designSize: Size(750, 1334));

    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,

        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Image.asset("image/login_header.png"),
                ),
                Expanded(
                  child: Container(),
                ),
                Image.asset("image/login_footer.png")
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28, right: 28, top: 60),
                child: Column(
                  children: <Widget>[
                    headerSection(),
                    SizedBox(height: ScreenUtil().setHeight(180)),
                    formCard(
                        _nameController, _emailController, _passController,
                        _phoneController, _nameCController, _emailCController,
                        _passCController, _phoneCController, _dataController,
                        _tagController, MediaQuery.of(context).viewInsets.bottom == 0),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    bodySection(model),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Não quer se cadastrar? ",
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                          onTap: () {
                            model.goToLogin();
                          },
                          child: Text("Clique aqui",
                              style: TextStyle(
                                  color: Color(0xFF5d74e3),
                                  fontFamily: "Poppins-Bold")),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Row headerSection() {
    return Row(
      children: <Widget>[
        Image.asset(
          "image/login_logo.png",
          width: ScreenUtil().setWidth(75),
          height: ScreenUtil().setHeight(100),
        ),
        Text("MEnforquei",
            style: TextStyle(
                fontFamily: "Poppins-Bold",
                fontSize: ScreenUtil().setSp(40),
                letterSpacing: .5,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Form formCard(txtNome, txtEmail, txtPass, txtPhone, txtNomeC, txtEmailC, txtPassC, txtPhoneC, txtData, txtTag, boolKey){
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(boolKey ? 636 : 333),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 12),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Cadastro",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
                //SizedBox(height: ScreenUtil.getInstance().setHeight(5)),
                TextField(
                  controller: txtNome,
                  decoration: InputDecoration(
                      hintText: "name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextField(
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "e-mail",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextField(
                  controller: txtPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "phone",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextField(
                  obscureText: true,
                  controller: txtPass,
                  decoration: InputDecoration(
                      hintText: "password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Row(
                  children: <Widget>[
                    if (!_isSelected)
                      Expanded(
                        child: TextField(
                          controller: txtTag,
                          decoration: InputDecoration(
                              hintText: "tag do casal, ex: #JM10122020",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: _radio,
                      child: radioButton(_isSelected),
                    ),
                    SizedBox(width: 8.0),
                    Text("Meu casamento",
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins-Medium", color: Colors.black87)
                    )
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                if (_isSelected)
                  Column(
                    children: <Widget>[
                      Text("Data casamento",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              fontFamily: "Poppins-Bold",
                              letterSpacing: .6)),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      TextField(
                        onTap: (){
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                                setState(() {
                                  txtData.text = stringAtIndex(date.toString());
                                });
                              }, onConfirm: (date) {
                                setState(() {
                                  txtData.text = stringAtIndex(date.toString());
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.pt
                          );
                        },
                        controller: txtData,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            hintText: "name",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      Text("Dados do meu amor",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              fontFamily: "Poppins-Bold",
                              letterSpacing: .6)),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      TextField(
                        controller: txtNomeC,
                        decoration: InputDecoration(
                            hintText: "name",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      TextField(
                        controller: txtEmailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "e-mail",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      TextField(
                        controller: txtPhoneC,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "phone",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      TextField(
                        obscureText: true,
                        controller: txtPassC,
                        decoration: InputDecoration(
                            hintText: "password",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row bodySection(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BusyButton(
          title: 'Cadastrar', // ToDo: string fixa
          busy: model.busy,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (_nameController.text != "" && _emailController.text != "" &&
                  _phoneController.text != "" && _passController.text != "") {

                Map<String, dynamic> userData = {
                  "name": _nameController.text.trim(),
                  "email": _emailController.text.trim(),
                  "phone": _phoneController.text,
                };
                Map<String, dynamic> userCData;
                String dataCasal, tagCasal;

                if (_isSelected){
                  if (_nameCController.text != "" && _emailCController.text != "" &&
                      _phoneCController.text != "" && _passCController.text != ""  && _dataController.text != "") {

                    userCData = {
                      "name": _nameCController.text,
                      "email": _emailCController.text,
                      "phone": _phoneCController.text,
                    };

                    dataCasal = _dataController.text;
                    tagCasal  = '#' + _nameController.text.substring(0, 1) + _nameCController.text.substring(0, 1) + dataCasal.replaceAll('/', '');
                  }else{
                    _onFieldBlank();
                    return;
                  }
                }else{
                  tagCasal = _tagController.text;
                  if (tagCasal == null || tagCasal == ""){
                    _onFieldBlank();
                    return;
                  }
                }

                // ToDo: para novo cadastro verificar permissão na base de dados
                model.signUp(
                    userData: userData,
                    userCData: userCData,
                    dataCasal: dataCasal,
                    tagCasal: tagCasal,
                    pass: _passController.text,
                    passC: _passCController.text,
                    ehCasal: _isSelected
                );
              } else {
                _onFieldBlank();
              }
            }
          },
        ),

      ],
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Usuário criado com sucesso"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      //Navigator.of(context).pop();
      // CustomNavigator.goToHome(context, true);
    });
  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao criar usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

  void _onFieldBlank(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Informe os campos acima"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.black87)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
    )
        : Container(),
  );

  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  String stringAtIndex(String index) {
    if (index.isNotEmpty) {
      var parsedDate = DateTime.parse(index);
      String dia = digits(parsedDate.day, 2).toString();
      String mes = digits(parsedDate.month, 2).toString();
      String ano = digits(parsedDate.year, 2).toString();
      return dia + '/' + mes + '/' + ano;
    } else {
      return '';
    }
  }
}
