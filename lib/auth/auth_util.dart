import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient _client = Supabase.instance.client;

Future<String?> login(String email, String password) async {
  try {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user != null
        ? 'Login successful'
        : 'Invalid email or password';
  } catch (e) {
    return 'Error: ${e.toString()}';
  }
}

Future<String?> signUp(String email, String password) async {
  try {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return response.user != null
        ? 'Account created successfully'
        : 'Sign up failed';
  } catch (error) {
    return 'Error: ${error.toString()}';
  }
}

Future<String?> recoverAccount(String email) async {
  try {
    await _client.auth.resetPasswordForEmail(email);
    return 'Password reset email sent successfully.';
  } catch (error) {
    return 'Error: ${error.toString()}';
  }
}

Future<String?> logout() async {
  try {
    await _client.auth.signOut();
    return 'Logged out successfully';
  } catch (error) {
    return 'Error: ${error.toString()}';
  }
}
