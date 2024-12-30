import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../login/views/login_view.dart';

class RegisterController extends GetxController {
  var nama = ''.obs;
  var alamat = ''.obs;
  var noTelp = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  Future<void> register() async {
    try {
      // Validasi input
      if (nama.value.isEmpty ||
          alamat.value.isEmpty ||
          noTelp.value.isEmpty ||
          email.value.isEmpty ||
          password.value.isEmpty) {
        Get.snackbar("Error", "Semua field wajib diisi!",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Buat akun baru di Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Simpan data pengguna di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'nama': nama.value,
        'alamat': alamat.value,
        'noTelp': noTelp.value,
        'email': email.value,
        'role': 'customer', // Default role
      });

      // Log untuk debugging
      print("Data user berhasil disimpan ke Firestore");

      // Arahkan ke halaman login
      Get.off(() => LoginView());
    } catch (e) {
      print("Register error: $e");
      // Get.snackbar("Register Gagal", "Terjadi kesalahan: $e",
      //     snackPosition: SnackPosition.BOTTOM);
    }
  }
}
