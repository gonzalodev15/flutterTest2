import 'dart:async';

mixin Validators{
  var emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if(email.contains("@") && email.contains(".com")){
        sink.add(email);
      }
      else{
        sink.addError("Email is not valid");
      }
    }
  );

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if(password.length > 7){
          sink.add(password);
        }
        else{
          sink.addError("Password should be at leat of 8 characters");
        }
      }
  );
}