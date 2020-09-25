import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meenforquei/components/busy_button.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:meenforquei/ui/shared/ui_helpers.dart';
import 'package:meenforquei/ui/widgets/social_icon.dart';
import 'package:meenforquei/ui/shared/shared_styles.dart';
import 'package:meenforquei/viewmodel/login_view_model.dart';

class LoginView extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    ScreenUtil.init(allowFontScaling: true, designSize: Size(750, 1334));

    // dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,

          body: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('image/login.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter
                  )
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(screenWidth * 0.10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          headerSection(),

                          if (MediaQuery.of(context).viewInsets.bottom == 0) // Não exibe o teclado
                            SizedBox(height: ScreenUtil().setHeight(180)),
                          if (MediaQuery.of(context).viewInsets.bottom != 0) // Exibe o teclado
                            SizedBox(height: ScreenUtil().setHeight(10)),

                          Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(485),
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
                                ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Login",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40),
                                          fontFamily: "Poppins-Bold",
                                          letterSpacing: .6)),
                                  SizedBox(height: ScreenUtil().setHeight(30)),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        hintText: "E-mail",
                                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                  ),
                                  verticalSpaceMedium30,
                                  TextField(
                                    obscureText: true,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                  ),
                                  verticalSpaceMedium,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: (){
                                          if (_emailController.text.isEmpty){
                                            _scaffoldKey.currentState.showSnackBar(
                                                SnackBar(
                                                  content: Text("Insira seu e-mail para recuperar a senha"),
                                                  backgroundColor: Colors.redAccent,
                                                  duration: Duration(seconds: 2),
                                                )
                                            );
                                          }else{
                                            model.recoverPass(_emailController.text);
                                            _scaffoldKey.currentState.showSnackBar(
                                                SnackBar(
                                                  content: Text("Um e-mail de recuperação de senha foi enviado"),
                                                  backgroundColor: Colors.redAccent,
                                                  duration: Duration(seconds: 2),
                                                )
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Esqueceu a senha?",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil().setSp(30)),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          // buttonSection(model),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  //GestureDetector(
                                  //  onTap: _radio,
                                  //  child: radioButton(_isSelected),
                                  //),
                                  SizedBox(width: 8.0,),
                                  //Text("Remember me",
                                  //    style: TextStyle(fontSize: 12, fontFamily: "Poppins-Medium")
                                  //)
                                ],
                              ),
                              BusyButton(
                                title: 'Login',
                                busy: model.busy,
                                onPressed: () {
                                  model.login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          //socialSectionHeader(),
                          //SizedBox(height: ScreenUtil().setHeight(30)),
                          //socialSectionBody(),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Novo por aqui? ",
                                style: TextStyle(fontFamily: "Poppins-Medium"),
                              ),
                              InkWell(
                                onTap: () {
                                  model.navigateToSignUp();
                                },
                                child: Text("Cadastre-se",
                                    style: TextStyle(
                                        color: Color(0xFF5d74e3),
                                        fontFamily: "Poppins-Bold")),
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
          )
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
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Row buttonSection(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 12.0,
            ),
            //GestureDetector(
            //  onTap: _radio,
            //  child: radioButton(_isSelected),
            //),
            SizedBox(width: 8.0,),
            //Text("Remember me",
            //    style: TextStyle(fontSize: 12, fontFamily: "Poppins-Medium")
            //)
          ],
        ),
        BusyButton(
          title: 'Login',
          busy: model.busy,
          onPressed: () {
            model.login(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
          },
        ),
      ],
    );
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  Row socialSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        horizontalLine(),
        Text("Social Login",
            style: TextStyle(fontSize: 16.0, fontFamily: "Poppins-Medium")
        ),
        horizontalLine()
      ],
    );
  }

  Row socialSectionBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SocialIcon(
          colors: [
            Color(0xFF102397),
            Color(0xFF187adf),
            Color(0xFF00eaf8),
          ],
          iconData: CustomIcons.facebook,
          onPressed: () {
            print('Facebook');
          },
        ),
        SocialIcon(
          colors: [
            Color(0xFFff4f38),
            Color(0xFFff355d),
          ],
          iconData: CustomIcons.googlePlus,
          onPressed: () {
            print('Google');
          },
        ),
        SocialIcon(
          colors: [
            Color(0xFF17ead9),
            Color(0xFF6078ea),
          ],
          iconData: CustomIcons.twitter,
          onPressed: () {
            print('Twitter');
          },
        ),
        SocialIcon(
          colors: [
            Color(0xFF00c6fb),
            Color(0xFF005bea),
          ],
          iconData: CustomIcons.linkedin,
          onPressed: () {
            print('Linkdin');
          },
        )
      ],
    );
  }

}
