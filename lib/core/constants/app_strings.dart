
final class AppStrings {
  static const authErrors = _AuthErrorStrings();
  static const validationErrors = _ValidationErrorStrings();
  static const common = _CommonStrings();
  static const authScreen = _AuthScreenStrings();
  static const galleryErrors = _GalleryErrorStrings();
  static const galleryScreen = _GalleryScreenStrings();
  static const dialogs = _DialogStrings(); 
  static const drawing = _DrawingStrings();
}

final class _AuthErrorStrings {
  final String weakPassword = 'Пароль слишком слабый';
  final String emailInUse = 'Аккаунт с таким email уже существует';
  final String userNotFound = 'Пользователь не найден';
  final String wrongPassword = 'Неверный пароль';
  final String networkError = 'Ошибка сети. Проверьте подключение к интернету';
  final String invalidEmail = 'Неверный формат email';
  final String userDataNotFound = 'Данные пользователя не найдены';
  final String operationNotAllowed = 'Эта операция не разрешена';
  final String unknownError = 'Произошла непредвиденная ошибка';
  final String signInFailed = 'Не удалось войти в систему';
  final String userCreationFailed = 'Не удалось создать пользователя';
  
  const _AuthErrorStrings();
}

final class _ValidationErrorStrings {
  final String emptyEmail = 'Email не может быть пустым';
  final String emptyPassword = 'Пароль не может быть пустым';
  final String emptyUsername = 'Имя пользователя не может быть пустым';
  final String userNameTooShort = 'Имя пользователя должно содержать минимум 2 символа';
  final String passwordTooShort = 'Пароль должен содержать минимум 8 символов';
  final String passwordsDoNotMatch = 'Пароли не совпадают';
  final String invalidEmailFormat = 'Неверный формат email';
  
  const _ValidationErrorStrings();
}

final class _CommonStrings {
  final String error = 'Ошибка';
  final String success = 'Успешно';
  final String tryAgain = 'Попробовать снова';
  final String loading = 'Загрузка...';
  final String cancel = 'Отмена';
  final String confirm = 'Подтвердить';
  final String galleryTitle = 'Галерея';
  final String create = 'Создать';
  
  const _CommonStrings();
}

final class _AuthScreenStrings {
  final String registrationTitle = 'Регистрация';
  final String loginTitle = 'Вход';
  final String nameFieldTitle = 'Имя';
  final String nameFieldPlaceholder = 'Введите ваше имя';
  final String emailFieldTitle = 'e-mail';
  final String emailFieldPlaceholderSignUp = 'Ваша электронная почта';
  final String emailFieldPlaceholderSignIn = 'Введите электронную почту';
  final String passwordFieldTitle = 'Пароль';
  final String passwordFieldPlaceholderLength = '8-16 символов';
  final String passwordFieldPlaceholderSignIn = 'Введите пароль';
  final String confirmPasswordFieldTitle = 'Подтверждение пароля';
  final String signUpButton = 'Зарегистрироваться';
  final String signInButton = 'Войти';
  
  const _AuthScreenStrings();
}

final class _GalleryErrorStrings {
  final String loadError = 'Не удалось загрузить изображения';
  final String saveError = 'Не удалось сохранить изображение';
  final String deleteError = 'Не удалось удалить изображение';
  final String unknownError = 'Произошла непредвиденная ошибка';
  
  const _GalleryErrorStrings();
}

final class _GalleryScreenStrings {
  final String openImage = 'Открыть изображение';
  final String deleteImage = 'Удалить изображение';
  
  const _GalleryScreenStrings();
}

final class _DialogStrings {
  final String logoutTitle = 'Выход';
  final String logoutMessage = 'Вы уверены, что хотите выйти?';
  final String logout = 'Выйти';
  final String deleteTitle = 'Удалить изображение?';
  final String deleteMessage = 'Это действие нельзя отменить.';
  final String delete = 'Удалить';
  
  const _DialogStrings();
}

final class _DrawingStrings {
  final String newTitle = 'Новое изображение';
  final String editTitle = 'Редактирование';

  const _DrawingStrings();
}