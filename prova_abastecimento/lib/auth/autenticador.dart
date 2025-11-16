import 'package:firebase_auth/firebase_auth.dart';

firebase_auth = firebaseAuth_instance;

Future signInWithEmailPassword(String email, String password)async{
  try{
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    print('Utilizador logado: ${userCredential.user?.uid}');
  } on FirebaseAuthException catch (e) { print('Erro de login: ${e.message}'); }
}

Future createUserWithEmailPassword(String email, String password)async{
  try{
    UserCredential userCredential = await auth.createUserWithEmailPassword(email: email, password: password);
    print('Utilizador criado: ${userCredential.user?.uid}');
  } on FirebaseAuthException catch (e) { print('Erro ao criar: ${e.message}'); }
}
Future signOut()async{
  await.auth.signOut();
  print('USUARIO DESLOGADO!!');
}