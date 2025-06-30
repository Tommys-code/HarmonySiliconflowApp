import SplashViewModel from '../viewmodel/SplashViewModel';
import { PersistenceV2 } from '@kit.ArkUI';
import { Splash } from './Splash';
import { Login } from './Login';
import { Main } from 'main';

@Entry
@ComponentV2
struct Index {
  @Local splash: SplashViewModel = PersistenceV2.connect(SplashViewModel, "Splash", () => new SplashViewModel())!;

  build() {
    Navigation() {
      if (this.splash.isLogin == true) {
        Main()
      } else if (this.splash.isLogin == false) {
        Login({
          loginSuccess: () => {
            this.splash.isLogin = true
          }
        })
      } else {
        Splash()
      }
    }.mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}