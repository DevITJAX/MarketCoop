import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketcoop/models/user.dart' as app_user;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _firebaseUser;
  app_user.User? _user;
  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  app_user.User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _firebaseUser = user;
    if (user != null) {
      _loadUserData(user.uid);
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = app_user.User.fromJson({...doc.data()!, 'id': uid});
      } else {
        // Create user document if it doesn't exist
        _user = app_user.User(
          id: uid,
          email: _firebaseUser!.email ?? '',
          displayName: _firebaseUser!.displayName,
        );
        await _saveUserData();
      }
    } catch (e) {
      _error = 'Failed to load user data: $e';
    }
    notifyListeners();
  }

  Future<void> _saveUserData() async {
    if (_user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(_user!.id)
            .set(_user!.toJson());
      } catch (e) {
        _error = 'Failed to save user data: $e';
        notifyListeners();
      }
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError('${_getAuthErrorMessage(e.code)}\n[${e.code}] ${e.message}');
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password, String displayName,
      {String? phoneNumber, String role = 'customer'}) async {
    _setLoading(true);
    _clearError();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        _user = app_user.User(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          role: role,
        );
        await _saveUserData();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError('${_getAuthErrorMessage(e.code)}\n[${e.code}] ${e.message}');
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _firebaseUser = null;
    } catch (e) {
      _setError('Failed to sign out');
    }
  }

  Future<bool> updateProfile({
    String? displayName,
    String? address,
    String? email,
    String? phoneNumber,
  }) async {
    if (_user == null) return false;
    _setLoading(true);
    _clearError();
    try {
      // Update email in FirebaseAuth if changed
      if (email != null && email != _firebaseUser?.email) {
        await _firebaseUser?.updateEmail(email);
        _user = _user!.copyWith(email: email);
      }
      _user = _user!.copyWith(
        displayName: displayName,
        address: address,
        phoneNumber: phoneNumber,
      );
      await _saveUserData();
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    _setLoading(true);
    _clearError();
    try {
      await _firebaseUser?.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      default:
        return 'Authentication failed';
    }
  }
}
