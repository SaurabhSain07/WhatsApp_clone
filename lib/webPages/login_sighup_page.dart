import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';
import '../default_color/default_color.dart';

class LoginSighupPage extends StatefulWidget {
  const LoginSighupPage({super.key});

  @override
  State<LoginSighupPage> createState() => _LoginSighupPageState();
}

class _LoginSighupPageState extends State<LoginSighupPage> {

  // For Login & Sign Up
  bool doesUserWantToSignup=false;

  // For select image
  Uint8List? selectedImage;

  // For visible choose profile picture Button
  bool errorInPicture=false;

  bool errorInName=false;
  bool errorInEmail=false;
  bool errorInPassword=false;

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  bool loadingOn=false;

  // For file choose (as image)
  chooseImage()async{
   FilePickerResult? chosenImageFile = await FilePicker.platform.pickFiles(type: FileType.image);

   setState(() {
     selectedImage =chosenImageFile!.files.single.bytes;
   });
  }

  uploadImageToStorage(UserModel userData)
  {
    if(selectedImage!=null)
    {
       Reference imageRef =FirebaseStorage.instance.ref("ProfileImage/${userData.uid}.jpg");
       UploadTask task =imageRef.putData(selectedImage!);
       task.whenComplete(() async
       {
         String urlImage=await task.snapshot.ref.getDownloadURL();
         userData.image=urlImage;

       // 3. save userDate to firestore database
       await FirebaseAuth.instance.currentUser?.updateDisplayName(userData.name);
       await FirebaseAuth.instance.currentUser?.updatePhotoURL(urlImage);

       final usersReference= FirebaseFirestore.instance.collection("users");
       usersReference.doc(userData.uid).set(userData.toJson()).then((value) {
         setState(() {
           loadingOn=false;
         });

         Navigator.pushReplacementNamed(context, "/home");
       });
       });
    }
    else
    {
      var snackBar=const SnackBar(content: Center(child: Text("Please choose image first.")),
        backgroundColor: DefaultColor.primaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  signUpUserNow(nameInput, emailInput, passwordInput)async
  {
   // 1. Create new user in firebase authentication
    final userCreated= await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailInput, password: passwordInput
    );

  // 2. upload image to storage
    String? uidOfCreatedUser=userCreated.user!.uid;
     if(uidOfCreatedUser !=null)
     {
      final userData = UserModel(uidOfCreatedUser, nameInput, emailInput, passwordInput);
       uploadImageToStorage(userData);
     }
  }

  loginUserNow(emailInput, passwordInput){
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailInput,
        password: passwordInput)
        .then((value) {
          setState(() {
            loadingOn=false;
          });
          Navigator.pushReplacementNamed(context, "/home");
    });
  }

  formValidation(){
    setState(() {
      loadingOn=true;
      errorInName=false;
      errorInEmail=false;
      errorInPassword=false;
      errorInPicture=false;
    });

    String nameInput=nameController.text.trim();
    String emailInput=emailController.text.trim();
    String passwordInput=passwordController.text.trim();

    if(emailInput.isNotEmpty && emailInput.contains("@"))
    {
      if(passwordInput.isNotEmpty && passwordInput.length>7)
      {
        if(doesUserWantToSignup==true)
          // signup form
        {
          if(nameInput.isNotEmpty && nameInput.length >=3)
          {
            signUpUserNow(nameInput, emailInput, passwordInput);
          }
          else
          {
            var snackBar=const SnackBar(content: Center(child: Text("Name is not valid"),),
             backgroundColor: DefaultColor.primaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
        else // login form
          {
            loginUserNow(emailInput, passwordInput);
          }
      }
      else
      {
        var snackBar=const SnackBar(content: Center(child: Text("Password is not valid.")),
          backgroundColor: DefaultColor.primaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // page is not loading
        setState(() {
          loadingOn=false;
        });
      }
    }
    else
    {
      var snackBar=const SnackBar(content: Center(child: Text("Email Is not valid.")),
        backgroundColor: DefaultColor.primaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // page is not loading
      setState(() {
        loadingOn=false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: DefaultColor.backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.5,
              color: DefaultColor.primaryColor,
            ),),
            
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:const EdgeInsets.all(17),
                  child: Card(
                    elevation: 6,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      width: 500,
                      child: Column(
                        children: [

                          // Profile image
                          Visibility(
                            visible: doesUserWantToSignup,
                            child: ClipOval(
                              child: selectedImage!=null
                                  ?Image.memory(selectedImage!, width: 124, height: 124, fit: BoxFit.cover,)
                                  :Image.asset("images/avatar.png" ,width: 124, height: 124, fit: BoxFit.cover,),
                            ),
                          ),

                          // outlined choose profile button
                          Visibility(
                            visible: doesUserWantToSignup,
                              child: OutlinedButton(
                                onPressed: (){
                                  chooseImage();
                                },
                                style: errorInPicture
                                    ?OutlinedButton.styleFrom(
                                  side: const BorderSide(width: 3, color: Colors.red)
                                )
                                    :null,
                              child: Text("Choose Picture"),),
                          ),

                          // For spacing
                          const SizedBox (height: 9,),

                        // name text Field
                          Visibility(
                            visible: doesUserWantToSignup,
                              child: TextField(
                               keyboardType: TextInputType.text,
                               controller: nameController,
                               decoration: InputDecoration(
                               hintText: "Write a valid name",
                               labelText: "Name",
                               suffixIcon: const Icon(Icons.person_outlined),
                               enabledBorder: errorInName
                               ? const OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.red)
                               )
                                  : null,
                                ),
                              ),
                          ),

                           // Email text field
                           TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Write a valid email",
                              labelText: "Email",
                              suffixIcon: const Icon(Icons.mail_outline_outlined),
                              enabledBorder: errorInName
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.red)
                              )
                                  : null,
                            ),
                          ),

                           // password text field
                           TextField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText:  doesUserWantToSignup
                                  ? "Must have grater then 7 characters"
                                  : "Write a valid password",
                              labelText: "Password",
                              suffixIcon: const Icon(Icons.lock_outline_rounded),
                              enabledBorder: errorInName
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.red)
                              )
                                  : null,
                            ),
                          ),

                         // For spacing
                         const SizedBox (height: 22,),

                          // login signup button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                formValidation();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DefaultColor.primaryColor,
                                foregroundColor: DefaultColor.barBackgruondColor
                              ),
                                child: Padding(
                                  padding:const EdgeInsets.symmetric(
                                    vertical: 8
                                  ),

                                  child: loadingOn
                                      ? const SizedBox(
                                       height: 19,
                                       width: 19,
                                       child: Center(
                                       child: CircularProgressIndicator(color: Colors.white,),
                                    ),
                                  )
                                      : Text(
                                    doesUserWantToSignup ? "Singh Up" :"Login"
                                  ),
                                ),
                            ),
                          ),

                        //   toggle button
                          Row(
                            children: [
                              const Text("Login"),
                              Switch(
                                  value: doesUserWantToSignup,
                                  onChanged: (bool value){
                                    setState(() {
                                      doesUserWantToSignup=value;
                                    });
                                  },
                              ),
                              const Text("Sign Up"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
