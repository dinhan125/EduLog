import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IAuthService {
	Future<String> loginWithEmail({
		required String email,
		required String password,
	});

	Future<String> loginWithGoogle();

	Future<void> logout();
}

class AuthService implements IAuthService {
	AuthService({
		FirebaseAuth? firebaseAuth,
		FirebaseFirestore? firebaseFirestore,
		GoogleSignIn? googleSignIn,
	})  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
				_firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
				_googleSignIn = googleSignIn ?? GoogleSignIn.instance;

	final FirebaseAuth _firebaseAuth;
	final FirebaseFirestore _firebaseFirestore;
	final GoogleSignIn _googleSignIn;
	bool _isGoogleSignInInitialized = false;

	Future<void> _ensureGoogleSignInInitialized() async {
		if (_isGoogleSignInInitialized) {
			return;
		}

		// Khởi tạo Google Sign-In đúng một lần trước khi gọi authenticate hoặc signOut.
		await _googleSignIn.initialize();
		_isGoogleSignInInitialized = true;
	}

	/// Đăng nhập bằng email và mật khẩu, sau đó đọc quyền người dùng từ Firestore.
	@override
	Future<String> loginWithEmail({
		required String email,
		required String password,
	}) async {
		try {
			// Bước 1: Đăng nhập vào Firebase Authentication bằng email và mật khẩu.
			final UserCredential userCredential =
					await _firebaseAuth.signInWithEmailAndPassword(
				email: email,
				password: password,
			);

			final User? user = userCredential.user;
			if (user == null) {
				throw Exception('Không thể xác định người dùng sau khi đăng nhập');
			}

			// Bước 2: Lấy document người dùng trong collection users theo uid.
			final DocumentSnapshot<Map<String, dynamic>> userDocument =
					await _firebaseFirestore.collection('users').doc(user.uid).get();

			if (!userDocument.exists) {
				throw Exception('Không tìm thấy dữ liệu phân quyền');
			}

			// Bước 3: Đọc trường role để UI biết người dùng là sinh viên hay giảng viên.
			final Map<String, dynamic>? data = userDocument.data();
			final String? role = data?['role'] as String?;

			if (role == null || role.isEmpty) {
				throw Exception('Không tìm thấy dữ liệu phân quyền');
			}

			return role;
		} on FirebaseAuthException catch (error) {
			// Chuyển đổi mã lỗi Firebase thành thông báo tiếng Việt thân thiện với UI.
			throw Exception(_mapFirebaseAuthErrorToVietnamese(error));
		} catch (error) {
			if (error is Exception) {
				rethrow;
			}
			throw Exception('Đã xảy ra lỗi không xác định khi đăng nhập');
		}
	}

	/// Đăng nhập bằng Google, sau đó kiểm tra quyền người dùng trong Firestore.
	@override
	Future<String> loginWithGoogle() async {
		try {
			// Bước 1: Khởi tạo Google Sign-In trước khi bắt đầu quy trình đăng nhập.
			await _ensureGoogleSignInInitialized();

			// Bước 2: Hiển thị luồng xác thực Google cho người dùng.
			final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

			// Bước 3: Lấy token ID từ tài khoản Google vừa xác thực.
			final GoogleSignInAuthentication googleAuth = googleUser.authentication;
			final String? idToken = googleAuth.idToken;
			if (idToken == null || idToken.isEmpty) {
				throw Exception('Không lấy được thông tin xác thực từ Google');
			}

			final AuthCredential credential = GoogleAuthProvider.credential(
				idToken: idToken,
			);

			// Bước 4: Đăng nhập Firebase Auth bằng credential của Google.
			final UserCredential userCredential =
					await _firebaseAuth.signInWithCredential(credential);

			final User? user = userCredential.user;
			if (user == null) {
				throw Exception('Không thể xác định người dùng sau khi đăng nhập Google');
			}

			// Bước 4: Tìm thông tin phân quyền trong Firestore theo uid.
			final DocumentSnapshot<Map<String, dynamic>> userDocument =
					await _firebaseFirestore.collection('users').doc(user.uid).get();

			// Nếu chưa có document thì đây là tài khoản đăng nhập lần đầu.
			if (!userDocument.exists) {
				return 'new_user';
			}

			final Map<String, dynamic>? data = userDocument.data();
			final String? role = data?['role'] as String?;

			if (role == null || role.isEmpty) {
				throw Exception('Không tìm thấy dữ liệu phân quyền');
			}

			return role;
		} on FirebaseAuthException catch (error) {
			// Chuyển đổi mã lỗi Firebase thành thông báo tiếng Việt thân thiện với UI.
			throw Exception(_mapFirebaseAuthErrorToVietnamese(error));
		} on GoogleSignInException catch (error) {
			throw Exception(_mapGoogleSignInErrorToVietnamese(error));
		} catch (error) {
			if (error is Exception) {
				rethrow;
			}
			throw Exception('Đã xảy ra lỗi không xác định khi đăng nhập Google');
		}
	}

	/// Đăng xuất khỏi cả Firebase Authentication và Google Sign-In.
	@override
	Future<void> logout() async {
		try {
			// Đảm bảo Google Sign-In đã được khởi tạo trước khi đăng xuất.
			await _ensureGoogleSignInInitialized();

			// Bước 1: Đăng xuất Google trước để hủy phiên đăng nhập bên ngoài.
			await _googleSignIn.signOut();

			// Bước 2: Đăng xuất Firebase Authentication.
			await _firebaseAuth.signOut();
		} on FirebaseAuthException catch (error) {
			throw Exception(_mapFirebaseAuthErrorToVietnamese(error));
		} on GoogleSignInException catch (error) {
			throw Exception(_mapGoogleSignInErrorToVietnamese(error));
		} catch (error) {
			if (error is Exception) {
				rethrow;
			}
			throw Exception('Đã xảy ra lỗi không xác định khi đăng xuất');
		}
	}

	/// Chuyển lỗi của Google Sign-In thành thông báo tiếng Việt dễ hiển thị trên UI.
	String _mapGoogleSignInErrorToVietnamese(GoogleSignInException error) {
		switch (error.code) {
			case GoogleSignInExceptionCode.canceled:
				return 'Đăng nhập Google đã bị hủy';
			case GoogleSignInExceptionCode.interrupted:
				return 'Đăng nhập Google bị gián đoạn';
			case GoogleSignInExceptionCode.uiUnavailable:
				return 'Không thể hiển thị màn hình đăng nhập Google';
			default:
				return error.description ?? 'Đã xảy ra lỗi khi đăng nhập Google';
		}
	}

	/// Chuyển mã lỗi Firebase Authentication thành thông báo tiếng Việt dễ hiển thị trên UI.
	String _mapFirebaseAuthErrorToVietnamese(FirebaseAuthException error) {
		switch (error.code) {
			case 'invalid-email':
				return 'Định dạng email không hợp lệ';
			case 'user-not-found':
				return 'Tài khoản không tồn tại';
			case 'wrong-password':
				return 'Sai mật khẩu';
			case 'invalid-credential':
				return 'Thông tin đăng nhập không hợp lệ';
			case 'user-disabled':
				return 'Tài khoản đã bị vô hiệu hóa';
			case 'too-many-requests':
				return 'Thử quá nhiều lần, vui lòng thử lại sau';
			case 'network-request-failed':
				return 'Không thể kết nối mạng';
			case 'account-exists-with-different-credential':
				return 'Tài khoản đã tồn tại với phương thức đăng nhập khác';
			case 'operation-not-allowed':
				return 'Phương thức đăng nhập này chưa được bật';
			case 'credential-already-in-use':
				return 'Thông tin xác thực này đã được sử dụng';
			case 'invalid-verification-code':
				return 'Mã xác thực không hợp lệ';
			case 'invalid-verification-id':
				return 'Mã định danh xác thực không hợp lệ';
			default:
				return error.message ?? 'Đã xảy ra lỗi xác thực';
		}
	}
}
